class_name Player;
extends CharacterBody2D;

# CONSTANTS
const FLOOR_COLLISION_MASK = (1 << 7) | (1 << 8) | (1 << 9);
const FLOOR_CORRECTION_DISTANCE = 100;
const VELOCITY_X_MIN = 10;

# SETTINGS
@export var camera: Camera2D;
@export var movement_speed: int = 34;
@export var max_movement_speed: int = 340; 
@export var jump_strength: int = 850;
@export var player_heath_ui: PlayerHealthUI;
@export var death_count_label: Label;
@export var max_health = 3;
@export var current_health = 3;
@export var spawn_position: Vector2;
@export var slope_slide_curve: Curve;

# INTERNAL STATE
var damage_timeout = 0.0;
var death_count = 0;
var knockback_impetus: Vector2 = Vector2.ZERO;

# FLAGS
var is_dead = false;
var is_movement_disabled = false;

# TIMERS
@export var jump_forgiveness_timer = 0.08;
var c_jump_forgiveness_timer = 0.0;
var knockback_duration_timer = 0.0;

func _on_respawn_grace_timer_timeout() -> void:
	Main.load_level();
	current_health = max_health;
	visible = true;
	is_dead = false;
	is_movement_disabled = false;
	damage(0, Vector2.ZERO);
	velocity = Vector2.ZERO;
	knockback_impetus = Vector2.ZERO;

func _on_respawn_timer_timeout() -> void:
	global_position = Vector2.ZERO;
	$RespawnGraceTimer.start();

# SIGNALS
signal player_interaction();
signal player_interaction_end();

# LIFECYCLE
func _process(delta: float) -> void:
	if is_dead:
		return;
	damage_timeout -= delta;
	if damage_timeout > 0:
		modulate.a = 0.5;
	else:
		modulate.a = 1;
	if Input.is_action_just_pressed("interaction"):
		player_interaction.emit();
	if Input.is_action_just_released("interaction"):
		player_interaction_end.emit();
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
	return Input.is_action_just_pressed("jump");

func _process_is_jump_key_released() -> bool:
	return Input.is_action_just_released("jump");

func _process_update_movement_direction(delta) -> void:
	if is_movement_disabled:
		velocity += get_gravity();
		return;
	if knockback_duration_timer > 0:
		knockback_duration_timer -= delta;
		velocity = knockback_impetus;
	var movement_impetus = Vector2.ZERO;
	if Input.is_action_pressed("move_right"):
		movement_impetus += Vector2.RIGHT * movement_speed;
	if Input.is_action_pressed("move_left"):
		movement_impetus += Vector2.LEFT * movement_speed;
	if (
		_process_is_jump_key_pressed() and
		c_jump_forgiveness_timer <= jump_forgiveness_timer
	):
		jump();
	if _process_is_jump_key_released():
		cancel_jump();
	if Input.is_action_pressed("drop"):
		set_collision_mask_value(PhysicsLayers.NAMES.LEVEL_2, false);
	else:
		set_collision_mask_value(PhysicsLayers.NAMES.LEVEL_2, true);
	if is_on_slope():
		apply_slope_slide();
	apply_friction();
	if knockback_duration_timer <= 0:
		velocity.x = clamp(
			velocity.x,
			-max_movement_speed,
			max_movement_speed
		);
	velocity += get_gravity() + movement_impetus;
	
# METHODS
func apply_friction() -> void:
	var friction_unit = sign(velocity.x) * get_gravity().length();
	velocity.x -= friction_unit * 1/4;
	#Apply extra friction, when traveling on the FLOOR
	if is_on_floor():
		velocity.x -= friction_unit * 7/8;
	#Apply extra friction, when traveling DOWN a slope
	if is_on_slope() and sign(velocity.x) == sign(get_floor_normal().x):
		velocity.x -= friction_unit * 2;
	if abs(velocity.x) < VELOCITY_X_MIN:
		velocity.x = 0;

func apply_slope_slide() -> void:
	var slope_angle_in_degrees = rad_to_deg(
		abs(get_floor_normal().angle() + PI / 2)
	);
	velocity.x += (
		sign(get_floor_normal().x) * slope_slide_curve.sample(
			slope_angle_in_degrees
		) * max_movement_speed
	);

func is_on_slope(min_slope_angle: float = 20) -> bool:
	return is_on_floor() and rad_to_deg(
		abs(get_floor_normal().angle() + PI / 2)
	) > min_slope_angle;

func gib_and_kill(gibs: int = 25) -> void:
	if is_dead:
		return;
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	$RespawnTimer.start();
	death_count += 1;
	death_count_label.text = var_to_str(death_count);
	visible = false;
	is_dead = true;
	velocity = Vector2.ZERO;
	
func jump() -> void:
	velocity += Vector2(0, -jump_strength);

func cancel_jump() -> void:
	if velocity.y < 0:
		velocity.y = 0;
		
func is_out_of_bounds() -> bool:
	return !Rect2(
		Main.level_instance.level_binding_box.position - 64 * Vector2.ONE,
		Main.level_instance.level_binding_box.size - Main.level_instance.level_binding_box.position + 64 * Vector2.ONE * 2,
	).has_point(position);
	
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

func set_alert_notification_visibility(show_alert = !$AlertNotification.visible):
	$AlertNotification.visible = show_alert;
