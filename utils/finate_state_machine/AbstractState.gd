@abstract
class_name AbstractState;
extends Node;

@warning_ignore("unused_signal")
signal transition(to: AbstractState);

var context: StateMachine;

@abstract
func enter(_from: AbstractState)->void;

@abstract
func exit(_to: AbstractState)->void;

@abstract
func process(_delta: float)->void;
	
@abstract
func physics_process(_delta: float);
