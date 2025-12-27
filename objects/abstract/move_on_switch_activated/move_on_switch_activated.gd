class_name MoveOnSwitchActivated;
extends Node2D;

@export var movement_path: PathFollow2D;
@export var movement_speed: float = 50.0;

var _is_switched_on = false;

func _on_switch_flipped_on(_by: Node2D,) -> void:
	_is_switched_on = true;

func _on_switch_flipped_off(_by: Node2D) -> void:
	_is_switched_on = false;

func _change_speed(_by: Node2D, to: float) -> void:
	movement_speed = to;

func _physics_process(delta: float) -> void:
	if _is_switched_on and movement_path.progress_ratio < 1:
		movement_path.progress += movement_speed * delta;
	if !_is_switched_on and movement_path.progress_ratio > 0:
		movement_path.progress -= movement_speed * delta;
	movement_path.progress_ratio = clamp(
		movement_path.progress_ratio,
		0,
		1
	);
