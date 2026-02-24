extends Button;

@export_file() var checkpoint_level_path: String;
@export var checkpoint_index: int;

func _ready()->void:
	var saved_checkpoint_index = CheckpointSaveManager.get_unlocked_checkpoint_index();
	if checkpoint_index <= saved_checkpoint_index:
		disabled = false;
	else:
		disabled = true;

func _load_checkpoint()->void:
	Main.inital_level_path_static = checkpoint_level_path;
	get_tree().change_scene_to_file("res://main.tscn");
