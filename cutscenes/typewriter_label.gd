class_name TypewriterLabel;
extends Label;

var _fast_text_input_debounce := 0.5;
var _c_fast_text_input_debounce := 0.0;
var _slow_text_speed := 0.05;
var _fast_text_speed := 0.005;
var _full_text := ""

@export var text_speed := _slow_text_speed; # seconds per character

signal finished_writing();

func _ready():
	_full_text = text;
	text = "";
	type_text();

func _process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		_c_fast_text_input_debounce += delta;
		if _c_fast_text_input_debounce > _fast_text_input_debounce:
			text_speed = _fast_text_speed;
	else:
		_c_fast_text_input_debounce = 0.0;
		text_speed = _slow_text_speed;

func type_text() -> void:
	var _char_index := 0
	while _char_index < _full_text.length():
		text += _full_text[_char_index];
		_char_index += 1;
		await get_tree().create_timer(text_speed, false).timeout;
	finished_writing.emit();

func update_text(message: String)->void:
	text = "";
	_full_text = message;
	type_text();
