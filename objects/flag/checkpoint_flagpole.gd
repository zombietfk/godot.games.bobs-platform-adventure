class_name CheckpointFlagpole;
extends Node2D;

# SETTINGS
@export_file() var level_path: String;
@export var spawn_index: int;

# TRIGGERS
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !$Flag.is_being_raised:
		$Flag.raise_flag();
		Main.update_spawn(level_path, spawn_index);
