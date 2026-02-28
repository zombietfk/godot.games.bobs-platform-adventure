class_name VirtualController;
extends Control;

@export var max_radius: float = 100.0
@onready var base = $Base;
@onready var handle = $Base/Handle;

var touch_id := -1;
var handle_origin_position: Vector2;

func _ready():
	handle_origin_position = handle.position;

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and touch_id == -1:
			touch_id = event.index;
			_update_handle(event.position);
			accept_event();
		elif !event.pressed and event.index == touch_id:
			touch_id = -1;
			_reset_joystick();
			accept_event();
	elif event is InputEventScreenDrag:
		if event.index == touch_id:
			_update_handle(event.position);
			accept_event();

func _update_handle(touch_position: Vector2):
	var touch_relative_position: Vector2 = touch_position - base.size / 2;
	if touch_relative_position.length() > max_radius:
		handle.position = (
			touch_relative_position.normalized() * max_radius
		) + handle_origin_position;
	else:
		handle.position = touch_relative_position + handle_origin_position;
	var movement_direction = (touch_relative_position / max_radius).clamp(
		-Vector2.ONE,
		Vector2.ONE
	);
	if movement_direction.length() < 0.15:
		movement_direction = Vector2.ZERO
	_apply_input_actions(movement_direction);

func _reset_joystick():
	handle.position = handle_origin_position;
	_apply_input_actions(Vector2.ZERO);

func _apply_input_actions(movement_direction: Vector2):
	Input.action_release("move_right");
	Input.action_release("move_left");
	Input.action_release("move_up");
	Input.action_release("move_down");
	Input.action_release("drop");
	if movement_direction.x > 0:
		Input.action_press("move_right", movement_direction.x);
	elif movement_direction.x < -0:
		Input.action_press("move_left", -movement_direction.x);
	if movement_direction.y > 0:
		Input.action_press("move_down", movement_direction.y);
		Input.action_press("drop", movement_direction.y);
	elif movement_direction.y < 0:
		Input.action_press("move_up", -movement_direction.y);
