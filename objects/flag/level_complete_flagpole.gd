class_name Level_Complete_Flagpole;
extends Node2D;

@export_file() var next_level_path: String;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !$Flag.is_being_raised:
		$Flag.raise_flag();
		$Load_Next_Level_Timeout.start();


func _on_load_next_level_timeout() -> void:
	if next_level_path != null:
		Main.load_next_level(next_level_path);
