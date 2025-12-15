class_name StateMachine;
extends Node;

var states: Dictionary[String, AbstractState];
var current_state: AbstractState;
@export var inital_state: AbstractState;

func _ready() -> void:
	for n in get_children():
		if n is AbstractState:
			states[n.name] = n;
	current_state = states[inital_state.name];

func _set_state(new_state_name: String):
	var new_state = states[new_state_name];
	if !new_state:
		push_warning(
			"Attempted to transit to non-existant state `" +
			new_state_name +
			"`"
		);
		return;
	if current_state:
		current_state.exit(new_state);
	new_state.enter(current_state);
	current_state = new_state;

func _physics_process(delta: float) -> void:
	current_state.physics_process(delta);

func _process(delta: float) -> void:
	current_state.process(delta);
