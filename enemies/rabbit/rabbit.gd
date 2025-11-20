class_name Rabbit;
extends CharacterBody2D;

# SETTINGS
@export var jump_movement: Vector2 = Vector2(150, -200);
@export var turnaround_on_platform_edge = false;
@export var jump_variance: Vector2 = Vector2.ZERO;
@export var randomize_starting_direction = false;

# TIMERS
@export var jump_timer_variance = 0.0;
@export var jump_timer = 1.0;
var c_jump_timer = 0.0;

# LIFECYCLE
func _ready() -> void:
	c_jump_timer = randf_range(-jump_timer_variance, jump_timer_variance);
	if randomize_starting_direction:
		if randf() >= 0.5:
			turn_around();

func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding() or (
		!$FloorCheckCast2D.is_colliding() and turnaround_on_platform_edge
	):
		turn_around();
	if is_on_floor():
		velocity = Vector2.ZERO;
		if c_jump_timer > jump_timer:
			velocity += jump_movement + Vector2(
				randf() * sign(jump_movement.x) * jump_variance.x,
				randf() * sign(jump_movement.y) * jump_variance.y,
			);
			c_jump_timer = 0 - randf_range(-jump_timer_variance, jump_timer_variance);
	c_jump_timer += delta;
	velocity += get_gravity() * delta;
	move_and_slide();

# METHODS
func turn_around() -> void:
	scale.x *= -1;
	jump_movement.x *= -1;
	velocity.x *= -1;
	
func gib_and_kill(gibs: int = 5) -> void:
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	queue_free();
