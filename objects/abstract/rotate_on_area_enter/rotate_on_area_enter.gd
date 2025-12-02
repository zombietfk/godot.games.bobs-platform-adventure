class_name RotateOnAreaEnter
extends Area2D

@export_range(-360,360) var rotate_to_angle_degrees: float;
@export var duration: float;
var c_duration: float = 0;
@export var target: Node2D;
var target_inital_rotation: float; 

var is_rotating = false;

func _on_area2d_enter(_body: Node2D)->void:
	is_rotating = true;
	target_inital_rotation = target.rotation_degrees;
	
func _physics_process(delta: float) -> void:
	if is_rotating and c_duration < duration:
		c_duration += delta;
		target.rotation_degrees = lerp(target_inital_rotation, rotate_to_angle_degrees, c_duration / duration)
		if c_duration >= duration:
			target.rotation_degrees = rotate_to_angle_degrees;
			
			
