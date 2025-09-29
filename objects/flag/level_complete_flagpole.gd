class_name Level_Complete_Flagpole;
extends Node2D;

@export var next_level: PackedScene;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$Flag.raise_flag();


func _on_load_next_level_timeout() -> void:
	if next_level != null:
		Main.load_next_level(next_level);
