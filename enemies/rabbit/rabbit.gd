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

@onready var onscreen_enabler := $VisibleOnScreenEnabler2D;
@onready var wall_check_cast := $RayCast2D;
@onready var floor_check_cast := $FloorCheckCast2D;

# LIFECYCLE
func _ready() -> void:
	set_physics_process(false);
	_c_jump_timer = randf_range(-jump_timer_variance, jump_timer_variance) - jump_inital_delay;
	if randomize_starting_direction:
		if randf() >= 0.5:
			_turn_around();

func _on_screen_entered()->void:
	set_physics_process(true);

func _on_screen_exited()->void:
	set_physics_process(false);

func _physics_process(delta: float) -> void:
	if wall_check_cast.is_colliding() or (
		!floor_check_cast.is_colliding() and turnaround_on_platform_edge
	):
		_turn_around();
	if is_on_floor():
		_process_jump();
	_c_jump_timer += delta;
	velocity += get_gravity() * delta;
	if !is_on_floor():
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
		move_and_slide();

func _turn_around() -> void:
	jump_movement.x *= -1;
	velocity.x *= -1;
	scale.x *= -1;
