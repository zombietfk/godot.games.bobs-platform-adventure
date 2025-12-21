class_name StateMachine;
extends Node;

@export var inital_state: AbstractState;
@export var external_contexts: Array[AbstractContext];
var _states: Dictionary[String, AbstractState];
var _contexts: Dictionary[String, AbstractContext];
var current_state: AbstractState;

func _ready() -> void:
	for n in get_children():
		if n is AbstractState:
			_states[n.name] = n;
			n.state_machine = self;
		if n is AbstractContext:
			_contexts[n.name] = n;
	for n in external_contexts:
		if _contexts.has(n.name):
			push_warning("Overriding duplicate context with name ", n.name);
		_contexts[n.name] = n;
	await get_parent().ready;
	for n in _states:
		_states[n].init();
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
	if current_state:
		current_state.exit(new_state);
		if !current_state.transition.is_connected(_set_state):
			new_state.transition.disconnect(_set_state);
	if !new_state.transition.is_connected(_set_state):
		new_state.transition.connect(_set_state);
	var previous_state = current_state;
	current_state = new_state;
	new_state.enter(previous_state);

func _physics_process(delta: float) -> void:
	current_state.physics_process(delta);

func _process(delta: float) -> void:
	current_state.process(delta);
	
func get_context(context_name: String) -> AbstractContext:
	return _contexts[context_name];
