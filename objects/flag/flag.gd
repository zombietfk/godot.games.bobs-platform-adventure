class_name Level_Complete_Flag;
extends Node2D;

var raised_target_local_pos: Vector2 = Vector2(0, -60);
var origin_target_local_pos: Vector2 = Vector2(0, 60);
var is_being_raised: bool = false;
@export var raise_duration = 1.0;
@export var confetti_particles_2d: GPUParticles2D;
var c_raise_duration = 0.0;

func raise_flag():
	confetti_particles_2d.emitting = true;
	is_being_raised = true;
	c_raise_duration = 0.0;

func reset_flag():
	c_raise_duration = 0;
	is_being_raised = false;
	position = origin_target_local_pos;

func _process(delta: float) -> void:
	if(is_being_raised && c_raise_duration <= raise_duration):
		c_raise_duration += delta;
		if(c_raise_duration > raise_duration):
			c_raise_duration = 1.0;
			is_being_raised = false;
		position = lerp(
			position,
			raised_target_local_pos,
			c_raise_duration / raise_duration
		)
