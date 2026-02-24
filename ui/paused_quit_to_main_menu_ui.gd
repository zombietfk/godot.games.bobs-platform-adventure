extends Button;

var _has_pressed_once = false;

@export var inital_message := "Main Menu"
@export var confirm_message := "For Sure?"

func reset()->void:
	_has_pressed_once = false;
	text = inital_message;

func _on_quit()->void:
	if !_has_pressed_once:
		_has_pressed_once = true;
		text = confirm_message;
	else:
		get_tree().change_scene_to_file("res://main_menu.tscn");
