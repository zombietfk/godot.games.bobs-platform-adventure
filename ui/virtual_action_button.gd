class_name VirtualActionButton;
extends Button;

@export var virtual_action_name: String;

var touch_id := -1

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and touch_id == -1:
			touch_id = event.index;
			Input.action_press(virtual_action_name);
			button_pressed = true;
			accept_event();
		elif !event.pressed and event.index == touch_id:
			print('bzzt');
			touch_id = -1;
			Input.action_release(virtual_action_name);
			button_pressed = false;
			accept_event();
