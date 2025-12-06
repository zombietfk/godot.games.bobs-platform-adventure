class_name PlayerDifficultyUI;
extends HBoxContainer;

const level_1_path = "res://level/levels/level_1.tscn";

func _on_hard_mode_pressed() -> void:
	Main.difficulty = Main.DIFFICULTY.HARD;
	Main.instance.player.lives = Main.DIFFICULTY.HARD;
	move_child($Selector, 2);

func _on_normal_mode_pressed() -> void:
	Main.difficulty = Main.DIFFICULTY.NORMAL;
	Main.instance.player.lives = Main.DIFFICULTY.NORMAL;
	move_child($Selector, 1);
	
func _on_easy_mode_pressed() -> void:
	Main.difficulty = Main.DIFFICULTY.EASY;
	Main.instance.player.lives = Main.DIFFICULTY.EASY;
	move_child($Selector, 0);
