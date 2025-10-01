class_name LevelCompleteFlagpole;
extends Node2D;

# SETTINGS
@export_file() var next_level_path: String;

# TRIGGERS
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !$Flag.is_being_raised:
		$Flag.raise_flag();
		$LoadNextLevelTimeout.start();

func _on_load_next_level_timeout() -> void:
	if next_level_path != null:
		Main.load_next_level(next_level_path);
