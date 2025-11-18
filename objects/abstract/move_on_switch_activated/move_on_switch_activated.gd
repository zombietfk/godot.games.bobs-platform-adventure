extends Node2D

@export var movement_path: PathFollow2D;
@export var movement_speed: float = 50.0;

var is_switched_on = false;

func _on_switch_flipped_on(_by) -> void:
	is_switched_on = true;

func _on_switch_flipped_off(_by) -> void:
	is_switched_on = false;
	
func _physics_process(delta: float) -> void:
	if is_switched_on and movement_path.progress_ratio < 1:
		movement_path.progress += movement_speed * delta;
	if !is_switched_on and movement_path.progress_ratio > 0:
		movement_path.progress -= movement_speed * delta;
	movement_path.progress_ratio = clamp(
		movement_path.progress_ratio,
		0,
		1
	);
