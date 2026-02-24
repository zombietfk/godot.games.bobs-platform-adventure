class_name CheckpointSaveManager;
extends Node;

const SAVE_PATH := "user://bobs_big_save.ini"

static func get_unlocked_checkpoint_index()->int:
	var save_ini = ConfigFile.new();
	var error_code := save_ini.load(SAVE_PATH);
	if error_code != OK:
		return 0;
	return save_ini.get_value(
		"checkpoints",
		"unlocked",
		0
	) as int;

static func set_unlock_checkpoint(unlocked_checkpoint_index: int)->void:
	var save_ini := ConfigFile.new();
	var current_checkpoint = get_unlocked_checkpoint_index();
	if current_checkpoint < unlocked_checkpoint_index:
		save_ini.set_value(
			"checkpoints",
			"unlocked",
			unlocked_checkpoint_index
		);
		save_ini.save(SAVE_PATH);

static func clear_checkpoints()->void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH);
