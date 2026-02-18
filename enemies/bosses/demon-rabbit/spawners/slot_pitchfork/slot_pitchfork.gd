class_name SlotPitchfork;
extends Node2D;

var _fire_delay_time := 1.0;
var _fire_delay_time_variance := 0.2;
var _is_fired := false;
var _sum_delta_time := 0.0;
var _idle_movement_speed := 4.0;
var _idle_movement_speed_variance := 0.8;
var _idle_movement_displacement := 0.02;
var _fire_speed := 300.0;
var _inital_displacement_variance := 8;
var _destroy_after_timer := 7.0;
var _c_destroy_after_timer := 0.0;

func _ready()->void:
	_idle_movement_speed += randf_range(
		-_idle_movement_speed_variance,
		_idle_movement_speed_variance
	);
	global_position.x += randf_range(
		-_inital_displacement_variance,
		_inital_displacement_variance
	);
	await _inital_move_forward();
	_fire_after(
		_fire_delay_time + randf_range(
			-_fire_delay_time_variance,
			_fire_delay_time_variance
		)
	);

func _inital_move_forward()->void:
	var c_movement_timer = 0;
	var movement_timer = 2;
	var inital_x_position = global_position.x; 
	var target_x_position = inital_x_position + 64;
	while c_movement_timer < movement_timer:
		c_movement_timer += get_process_delta_time();
		global_position.x = lerp(inital_x_position, target_x_position, c_movement_timer / movement_timer);
		await get_tree().process_frame;

func _fire_after(time: float)->void: 
	await get_tree().create_timer(time).timeout;
	_is_fired = true;
	
func _process(delta: float)->void:
	if !_is_fired:
		_sum_delta_time += delta;
		global_position.x += sin(
			_sum_delta_time * _idle_movement_speed
		) * _idle_movement_displacement;
	else:
		global_position.x += _fire_speed * delta;
		_c_destroy_after_timer += delta;
		if _c_destroy_after_timer >= _destroy_after_timer:
			queue_free();
	
func _damage_player_in_area2d(body: Node2D)->void:
	if body is Player:
		body.damage(1, Vector2.LEFT, Vector2.ONE * 500);
