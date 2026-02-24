extends Button;

@export_file() var checkpoint_level_path: String;
@export var checkpoint_index: int;

func _ready()->void:
	visibility_changed.connect(check_enabled);
	check_enabled();

func _load_checkpoint()->void:
	Main.inital_level_path_static = checkpoint_level_path;
	get_tree().change_scene_to_file("res://main.tscn");

func check_enabled()->void:
	var saved_checkpoint_index = CheckpointSaveManager.get_unlocked_checkpoint_index();
	if checkpoint_index <= saved_checkpoint_index:
		disabled = false;
	else:
		disabled = true;
