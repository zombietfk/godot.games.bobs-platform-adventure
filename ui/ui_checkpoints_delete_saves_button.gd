extends Button;

var _has_pressed_once = false;

@export var inital_message := "Delete Save"
@export var confirm_message := "Press Again"
@export var main_menu_controller: MainMenu;

func reset()->void:
	_has_pressed_once = false;
	text = inital_message;

func _on_delete()->void:
	if !_has_pressed_once:
		_has_pressed_once = true;
		text = confirm_message;
	else:
		CheckpointSaveManager.clear_checkpoints();
		main_menu_controller._show_main_ui_menu();
		reset();
