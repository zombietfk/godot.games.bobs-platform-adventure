class_name PlayerGroundedState;
extends AbstractPlayerMovementState;

var _movement_context: PlayerMovementContext;
@export var _jump_forgiveness_timer: float = 0.08;
var _c_jump_forgiveness_timer: float;
@export var friction_strength: float = 9.0/8;
@export var jump_strength: int = 850;
@export var slope_slipperyness_factor: float = 1.6;

func enter(_from: AbstractState)->void:
	_movement_context = state_machine.get_context("MovementContext") as PlayerMovementContext;
	if !body.on_kill.is_connected(_kill_player):
		body.on_kill.connect(_kill_player);
	
func exit(_to: AbstractState)->void:
	if body.on_kill.is_connected(_kill_player):
		body.on_kill.disconnect(_kill_player);
	
func process(_delta: float)->void:
	if !body.is_on_floor() and _c_jump_forgiveness_timer >= _jump_forgiveness_timer:
		transition.emit("Airborn");
	
func physics_process(delta: float)->void:
	_process_horizontal_input(_movement_context);
	_process_jump_input(delta);
	_process_fall_through_platform_input();
	_process_object_interaction_input();
	_apply_horizontal_friction(delta);
	body.velocity += (
		body.get_gravity() * delta +
		_movement_context.movement_impetus +
		_movement_context.knockback_impetus
	);
	_clamp_horizontal_movement(_movement_context.max_movement_speed);
		
func _process_jump_input(delta: float):
	if body.is_on_floor():
		_c_jump_forgiveness_timer = 0;
	else:
		_c_jump_forgiveness_timer += delta;
	if Input.is_action_just_pressed("jump"):
		_jump();

func _process_fall_through_platform_input():
	if Input.is_action_pressed("drop"):
		body.set_collision_mask_value(PhysicsLayers.NAMES.LEVEL_2, false);
	if Input.is_action_just_released("drop"):
		body.set_collision_mask_value(PhysicsLayers.NAMES.LEVEL_2, true);

func _process_object_interaction_input():
	if Input.is_action_just_pressed("interaction"):
		body.player_interaction.emit();
	if Input.is_action_just_released("interaction"):
		body.player_interaction_end.emit();

func _jump() -> void:
	body.velocity += Vector2(0, -jump_strength);

func _apply_horizontal_friction(delta) -> void:
	if _is_on_slope():
		_apply_slope_slide(_movement_context.movement_impetus);
		_movement_context.movement_impetus = Vector2.ZERO;
	var friction_unit = sign(body.velocity.x) * (body.get_gravity().length() * delta);
	body.velocity.x -= friction_unit * friction_strength;
	if abs(body.velocity.x) < Player.VELOCITY_X_MIN and !_is_on_slope():
		body.velocity.x = 0;

func _is_on_slope(min_slope_angle: float = 5) -> bool:
	return body.is_on_floor() and rad_to_deg(
		abs(body.get_floor_normal().angle() + PI / 2)
	) > min_slope_angle;

func _apply_slope_slide(movement_impetus: Vector2 = Vector2.ZERO) -> void:
	var slope_angle_in_degrees = rad_to_deg(
		abs(body.get_floor_normal().angle() + PI / 2)
	);
	var vertical_angle_deg = rad_to_deg(PI / 2);
	var slope_impulse = (
		sign(body.get_floor_normal().x) *
		_movement_context.max_movement_speed *
		slope_slipperyness_factor *
		(slope_angle_in_degrees / vertical_angle_deg)
	);
	body.velocity.x = (
		slope_impulse + sign(movement_impetus.x) *
		(
			(vertical_angle_deg - slope_angle_in_degrees) /
			vertical_angle_deg
		) * _movement_context.max_movement_speed
	);
