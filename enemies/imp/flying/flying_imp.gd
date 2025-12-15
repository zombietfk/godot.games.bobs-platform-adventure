class_name FlyingImp;
extends CharacterBody2D;

var floating_displacement_timer = 0.0;
var floating_displacement_magnitude = 25;
@export var state_machine: EnemyStateMachine;

func _process(delta: float) -> void:
	state_machine._process(delta);
	
func _physics_process(delta: float) -> void:
	var current_state = state_machine.current_state as AbstractFlyingImpState;
	state_machine._physics_process(delta);
	if current_state.is_floating_enabled():
		floating_displacement_timer += delta;
		position.y += sin(floating_displacement_timer) * floating_displacement_magnitude;
	if current_state.is_movement_enabled():
		move_and_slide();
