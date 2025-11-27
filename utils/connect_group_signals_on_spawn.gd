extends Node

@export var connects_to: Node;
@export var signal_names: Array[String];
@export var callback_names: Array[String];

func _ready() -> void:
	for c in get_children():
		for signal_name in signal_names:
			if connects_to.has_signal(signal_name):
				for callback_name in callback_names:
					connects_to.connect(signal_name, Callable(c, callback_name));
