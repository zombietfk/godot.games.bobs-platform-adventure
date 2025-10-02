class_name Player;
extends CharacterBody2D;

# CONSTANTS
const FLOOR_COLLISION_MASK = (1 << 7) | (1 << 8) | (1 << 9);
const FLOOR_CORRECTION_DISTANCE = 100;

# SETTINGS
@export var play_area_bounds: Rect2;
@export var movement_speed: int = 200;
@export var jump_strength: int = 1000;
@export var player_heath_ui: PlayerHealthUI;
@export var death_count_label: Label;
@export var max_health = 3;
@export var current_health = 3;
@export var spawn_position: Vector2;

# INTERNAL STATE
var damage_timeout = 0.0;
var death_count = 0;

# FLAGS
var is_dead = false;

# TIMERS
@export var jump_forgiveness_timer = 0.08;
var c_jump_forgiveness_timer = 0.0;


func _on_reload_level_timer_timeout() -> void:
	Main.reload_current_level();
	current_health = max_health;
	visible = true;
	is_dead = false;
	damage(0, Vector2.ZERO);

func _on_respawn_timer_timeout() -> void:
	global_position = spawn_position;
	$ReloadLevelTimer.start();

# LIFECYCLE
func _process(delta: float) -> void:
	if is_dead:
		return;
	damage_timeout -= delta;
	if damage_timeout > 0:
		modulate.a = 0.5;
	else:
		modulate.a = 1;
	if is_out_of_bounds() or current_health <= 0:
		gib_and_kill(50);
	player_heath_ui.update_health_bar(current_health, max_health);

func _physics_process(delta: float) -> void:
	if is_dead:
		return;
	if is_on_floor():
		c_jump_forgiveness_timer = 0;
	else:
		c_jump_forgiveness_timer += delta;
	_process_update_movement_direction();
	move_and_slide();

func _process_is_jump_key_pressed() -> bool:
	return Input.is_action_just_pressed("ui_accept");

func _process_is_jump_key_released() -> bool:
	return Input.is_action_just_released("ui_accept");

func _process_update_movement_direction() -> void:
	var movement_impetus = Vector2.ZERO;
	if Input.is_action_pressed("ui_right") and velocity.x < movement_speed:
		movement_impetus += Vector2(movement_speed * 0.15, 0);
	if Input.is_action_pressed("ui_left") and velocity.x > -movement_speed:
		movement_impetus += Vector2(-movement_speed * 0.15, 0);
	if (
		!Input.is_action_pressed("ui_left") and
		!Input.is_action_pressed("ui_right")
	):
		movement_impetus -= Vector2(velocity.x * 0.25, 0);		
	if (
		_process_is_jump_key_pressed() and
		c_jump_forgiveness_timer <= jump_forgiveness_timer
	):
		jump();
	if _process_is_jump_key_released():
		cancel_jump();
	velocity += get_gravity() + movement_impetus;

# METHODS
func gib_and_kill(gibs: int = 25) -> void:
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	$RespawnTimer.start();
	death_count += 1;
	death_count_label.text = var_to_str(death_count);
	visible = false;
	is_dead = true;
	
func jump() -> void:
	velocity += Vector2(0, -jump_strength);

func cancel_jump() -> void:
	if velocity.y < 0:
		velocity.y = 0;
		
func is_out_of_bounds() -> bool:
	return !play_area_bounds.encloses(
		Rect2(position, Vector2.ONE)
	);
	
func damage(amount: int, from_direction: Vector2, knockback_strength: Vector2 = Vector2.ZERO) -> void:
	if damage_timeout <= 0:
		velocity += -from_direction.normalized() * knockback_strength;
		damage_timeout = 1.0;
		current_health -= amount;
