class_name Player;
extends CharacterBody2D;

# CONSTANTS
const FLOOR_COLLISION_MASK = (1 << 7) | (1 << 8) | (1 << 9);
const FLOOR_CORRECTION_DISTANCE = 100;

# SETTINGS
@export var camera: Camera2D;
@export var movement_speed: int = 400;
@export var jump_strength: int = 820;
@export var player_heath_ui: PlayerHealthUI;
@export var death_count_label: Label;
@export var max_health = 3;
@export var current_health = 3;
@export var spawn_position: Vector2;

# INTERNAL STATE
var damage_timeout = 0.0;
var death_count = 0;
var knockback_impetus: Vector2 = Vector2.ZERO;


# FLAGS
var is_dead = false;

# TIMERS
@export var jump_forgiveness_timer = 0.08;
var c_jump_forgiveness_timer = 0.0;
var knockback_duration_timer = 0.0;

func _on_reload_level_timer_timeout() -> void:
	Main.load_level();
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
	_process_update_movement_direction(delta);
	move_and_slide();

func _process_is_jump_key_pressed() -> bool:
	return Input.is_action_just_pressed("ui_accept");

func _process_is_jump_key_released() -> bool:
	return Input.is_action_just_released("ui_accept");

func _process_update_movement_direction(delta) -> void:
	if knockback_duration_timer > 0:
		knockback_duration_timer -= delta;
		velocity = knockback_impetus;
	var movement_impetus = Vector2.ZERO;
	if Input.is_action_pressed("ui_right") and velocity.x < movement_speed:
		movement_impetus += Vector2.RIGHT * movement_speed * 0.15;
	if Input.is_action_pressed("ui_left") and velocity.x > -movement_speed:
		movement_impetus += Vector2(-movement_speed * 0.15, 0);
	if (
		_process_is_jump_key_pressed() and
		c_jump_forgiveness_timer <= jump_forgiveness_timer
	):
		jump();
	if _process_is_jump_key_released():
		cancel_jump();
	if Input.is_action_pressed("ui_down"):
		set_collision_mask_value(PhysicsLayers.NAMES.LEVEL_2, false);
	else:
		set_collision_mask_value(PhysicsLayers.NAMES.LEVEL_2, true);
	apply_friction();
	velocity += get_gravity() + movement_impetus;
	
# METHODS
func apply_friction() -> void:
	velocity.x -= sign(velocity.x) * get_gravity().length();

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
	return !Rect2(
		Main.level_instance.level_binding_box.position.x - 64,
		Main.level_instance.level_binding_box.position.y - 64,
		-Main.level_instance.level_binding_box.position.x + Main.level_instance.level_binding_box.size.x + 128,
		-Main.level_instance.level_binding_box.position.y + Main.level_instance.level_binding_box.size.y + 128,
	).encloses(
		Rect2(position, Vector2.ONE)
	);
	
func damage(
	amount: int,
	from_direction: Vector2,
	knockback_strength: Vector2 = Vector2.ZERO,
	knockback_duration_in_s: float = 0.2,
) -> void:
	if damage_timeout <= 0:
		velocity = Vector2.ZERO;
		damage_timeout = 1.0;
		knockback_impetus = -from_direction.normalized() * knockback_strength;
		knockback_duration_timer = knockback_duration_in_s;
		current_health -= amount;
