class_name CheckpointFlag;
extends Node2D;

# SETTINGS
@export var confetti_particles_2d: GPUParticles2D;

# INTERNAL STATE
var raised_target_local_pos: Vector2 = Vector2(0, -60);
var origin_target_local_pos: Vector2 = Vector2(0, 60);

# FLAGS
var is_being_raised: bool = false;

# TIMERS
@export var raise_duration = 1.0;
var c_raise_duration = 0.0;

# LIFECYCLE
func _process(delta: float) -> void:
	if(is_being_raised && c_raise_duration < raise_duration):
		c_raise_duration += delta;
		if(c_raise_duration > raise_duration):
			confetti_particles_2d.emitting = true;
			c_raise_duration = raise_duration;
	position = lerp(
		origin_target_local_pos,
		raised_target_local_pos,
		c_raise_duration / raise_duration
	)

# METHODS
func raise_flag():
	visible = true;
	if !is_being_raised:
		is_being_raised = true;
		c_raise_duration = 0.0;

func reset_flag():
	c_raise_duration = 0;
	is_being_raised = false;
	position = origin_target_local_pos;
