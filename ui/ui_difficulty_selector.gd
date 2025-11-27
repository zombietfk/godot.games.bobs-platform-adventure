class_name PlayerDifficultyUI;
extends HBoxContainer;

const level_1_path = "res://level/levels/level_1.tscn";

func _on_hard_mode_pressed() -> void:
	# ALWAYS START AT THE BEGINNING!
	Main.update_spawn(
		level_1_path,
		0
	);
	Main.difficulty = Main.DIFFICULTY.HARD;
	print('hard');
	move_child($Selector, 2);

func _on_normal_mode_pressed() -> void:
	# Set checkpoint to current level, only flagpoles from now on
	Main.difficulty = Main.DIFFICULTY.NORMAL;
	print('normal');
	Main.update_spawn(
		Main.current_level_path,
		0
	);
	move_child($Selector, 1);
	
func _on_easy_mode_pressed() -> void:
	# Set checkpoint to current level, every screen sets the checkpoint
	print('easy');
	Main.difficulty = Main.DIFFICULTY.EASY;
	Main.update_spawn(
		Main.current_level_path,
		0
	);
	move_child($Selector, 0);
