extends Node2D

var _rotation_speed = 0;
@export var rotation_sensitivity = 0.1;
@export var rotation_slowdown_ratio: float = 1;
@export var pivot: Node2D;
@export var overlap_area: Area2D;

func _physics_process(delta: float) -> void:
	var player = Main.instance.player;
	var is_colliding = false;
	for n in overlap_area.get_overlapping_bodies():
		if n == player:
			is_colliding = true;
			break;
	if is_colliding:
		var pivot_point: Vector2 = pivot.global_position;
		var player_local_to_pivot: Vector2 = player.global_position - pivot_point;
		var player_local_to_rotated_pivot = player_local_to_pivot.rotated(
			-rotation
		);
		var rotation_direction_sign: int = -sign(
			player_local_to_rotated_pivot.x *
			player_local_to_rotated_pivot.y
		);
		if rotation_direction_sign != 0:
			_rotation_speed = rotation_direction_sign * player_local_to_pivot.length() * rotation_sensitivity
		else:
			_rotation_speed = player_local_to_pivot.length() * rotation_sensitivity;
	else:
		_rotation_speed *= (1 - rotation_slowdown_ratio * delta);
	rotation_degrees += _rotation_speed * delta;
