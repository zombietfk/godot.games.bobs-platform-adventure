class_name StateOneBearState;
extends AbstractBearState;

@export var wallcheck_raycast: RayCast2D;
@export var move_acceleration_sqr = 0.01;
@export var jump_timer_range: Vector2 = Vector2(0.6, 1.2);
var _move_acceleration = 0.1;
var _direction: int = 1;
var _is_running = false;
var _wait_time_before_run: float = 1.0;
var _running_impetus: Vector2;
var _jump_impetus: Vector2;
var _jump_strength: float = -2700;
var _max_running_impetus: Vector2 = Vector2(400, 0);
var _passes_to_make = 1;
var _passes_made = 0;

func enter(_from: AbstractState)->void:
	animated_sprite.animation = "forward";
	_wait_then_run();
	
func exit(_to: AbstractState)->void:
	animated_sprite.animation = "forward";

func process(_delta: float)->void:
	if wallcheck_raycast.is_colliding() and _is_running:
		_passes_made += 1;
		if _passes_made > _passes_to_make:
			transition.emit("Stage2State");
		_change_direction();
		_wait_then_run();

func physics_process(delta: float)->void:
	if _is_running:
		_move_acceleration += move_acceleration_sqr;
		_running_impetus += _direction * _move_acceleration * Vector2.RIGHT;
		_running_impetus = _running_impetus.clamp(
			-_max_running_impetus,
			_max_running_impetus
		);
	else:
		_running_impetus = Vector2.ZERO;
	bear.velocity = _jump_impetus + _running_impetus + bear.get_gravity();
	_jump_impetus = _jump_impetus * (1 - delta);

func _change_direction()->void:
	bear.scale.x = -bear.scale.x;
	_direction = -_direction;

func _wait_then_run()->void:
	_move_acceleration = move_acceleration_sqr;
	animated_sprite.animation = "idle";
	_is_running = false;
	await get_tree().create_timer(_wait_time_before_run).timeout;
	animated_sprite.animation = "running";
	_is_running = true;
	await _jump_after(randf_range(jump_timer_range.x, jump_timer_range.y));

func _jump_after(t: float)->void:
	await get_tree().create_timer(t).timeout;
	_jump_impetus.y = _jump_strength;
