class_name Rabbit;
extends AbstractEnemy;

# SETTINGS
@export var jump_movement: Vector2 = Vector2(150, -200);
@export var turnaround_on_platform_edge = false;
@export var jump_variance: Vector2 = Vector2.ZERO;
@export var jump_inital_delay = 0;
@export var randomize_starting_direction = false;

# TIMERS
@export var jump_timer_variance = 0.0;
@export var jump_timer = 1.0;
var _c_jump_timer = 0.0;

# LIFECYCLE
func _ready() -> void:
	_c_jump_timer = randf_range(-jump_timer_variance, jump_timer_variance) - jump_inital_delay;
	if randomize_starting_direction:
		if randf() >= 0.5:
			_turn_around();

func _physics_process(delta: float) -> void:
	if !is_on_floor() and $RayCast2D.is_colliding() or (
		!$FloorCheckCast2D.is_colliding() and turnaround_on_platform_edge
	):
		_turn_around();
	if is_on_floor():
		_process_jump();
	_c_jump_timer += delta;
	velocity += get_gravity() * delta;
	move_and_slide();

# METHODS
func _process_jump() -> void:
	velocity = Vector2.ZERO;
	if _c_jump_timer > jump_timer:
		velocity += jump_movement + Vector2(
			randf() * sign(jump_movement.x) * jump_variance.x,
			randf() * sign(jump_movement.y) * jump_variance.y,
		);
		_c_jump_timer = 0 - randf_range(-jump_timer_variance, jump_timer_variance);

func _turn_around() -> void:
	jump_movement.x *= -1;
	velocity.x *= -1;
	scale.x = -1;
