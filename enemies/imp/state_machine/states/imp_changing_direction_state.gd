class_name ImpChangingDirectionState;
extends AbstractImpState;

@export var turn_around_timer = 1.0;
var _walking_context: ImpMovementContext;

func enter(_from: AbstractState)->void:
	_walking_context = state_machine.get_context(
		"MovementContext"
	);
	body.velocity = Vector2.ZERO;
	turn_then_walk();
	
func exit(_to: AbstractState)->void:
	pass;

func process(_delta: float)->void:
	pass;
	
func physics_process(_delta: float):
	pass;

func turn_then_walk()->void:
	_walking_context.movement_direction *= -1;
	NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(
		body,
		-sign(_walking_context.movement_direction.x),
		0
	);
	transition.emit("Walk");
	
	
