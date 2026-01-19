class_name StageOneBearState;
extends AbstractRunningAroundBearState;

var _passes_to_make = 1;
var _passes_made = 0;

var lives_remaining_passes_to_make = [
	20,
	14,
	8,
];

func enter(_from: AbstractState)->void:
	_passes_made = 0;
	_passes_to_make = lives_remaining_passes_to_make[bear.lives - 1];
	super.enter(_from);
	
func process(_delta: float)->void:
	if wallcheck_raycast.is_colliding() and _is_running:
		_passes_made += 1;
		if _passes_made > _passes_to_make:
			transition.emit("Stage2State");
		_change_direction();
		_wait_then_run();
