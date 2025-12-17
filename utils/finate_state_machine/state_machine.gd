class_name StateMachine;
extends Node;

@export var inital_state: AbstractState;
var _states: Dictionary[String, AbstractState];
var _contexts: Dictionary[String, AbstractContext];
var _current_state: AbstractState;

func _ready() -> void:
	for n in get_children():
		if n is AbstractState:
			_states[n.name] = n;
			n.state_machine = self;
		if n is AbstractContext:
			print(n.name);
			_contexts[n.name] = n;
	_set_state(inital_state.name)

func _set_state(new_state_name: String):
	var new_state = _states[new_state_name];
	if !new_state:
		push_warning(
			"Attempted to transit to non-existant state `" +
			new_state_name +
			"`"
		);
		return;
	if _current_state:
		_current_state.exit(new_state);
		if !_current_state.transition.is_connected(_set_state):
			new_state.transition.disconnect(_set_state);
	if !new_state.transition.is_connected(_set_state):
		new_state.transition.connect(_set_state);
	new_state.enter(_current_state);
	_current_state = new_state;

func _physics_process(delta: float) -> void:
	_current_state.physics_process(delta);

func _process(delta: float) -> void:
	_current_state.process(delta);
	
func get_context(context_name: String) -> AbstractContext:
	return _contexts[context_name];
