class_name IdleSpiderState;
extends AbstractSpiderState;

@export var awakening_raycast: RayCast2D;
@export var rotation_on_fall_timer = 0.5;
var _target_rotation = 0;
var _is_falling_already = false;


func enter(_from: AbstractState)->void:
	pass;

func exit(_to: AbstractState)->void:
	pass;
	
func process(_delta: float)->void:
	if awakening_raycast.is_colliding():
		fall_down_and_exit_to_walking_state();
	
func physics_process(_delta: float)->void:
	pass;
	
func fall_down_and_exit_to_walking_state()->void:
	if _is_falling_already:
		return;
	_is_falling_already = true;
	var c_rotation_on_fall_timer = 0;
	var inital_rotation = body.rotation_degrees;
	while c_rotation_on_fall_timer < rotation_on_fall_timer:
		body.rotation_degrees = lerp(
			inital_rotation,
			_target_rotation,
			c_rotation_on_fall_timer / rotation_on_fall_timer
		);
		await get_tree().process_frame;
		c_rotation_on_fall_timer += get_process_delta_time();
		body.velocity += body.get_gravity() * get_process_delta_time();
	while !body.is_on_floor():
		await get_tree().process_frame;
	transition.emit("WalkingState");
