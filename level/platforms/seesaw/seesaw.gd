extends Node2D

var is_on_platform = false;
var player_body: Player;
var rotation_speed = 0;
@export var rotation_sensitivity = 0.001;
@export var rotation_slowdown_ratio = 1;

func _on_seesaw_area_enter(body: Node2D)->void:
	if body is Player:
		is_on_platform = true;
		player_body = body;

func _on_seesaw_area_leave(body: Node2D)->void:
	if body is Player:
		is_on_platform = false;
		player_body = null;
	
func _physics_process(delta: float) -> void:
	if is_on_platform and player_body and player_body.is_on_floor():
		var y_difference_from_pivot = player_body.global_position.x - $Pivot.global_position.x;
		rotation_speed += y_difference_from_pivot * rotation_sensitivity
	else:
		rotation_speed *= (1 - rotation_slowdown_ratio * delta);
	rotation_degrees += rotation_speed * delta;
