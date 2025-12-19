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
	_walking_context.movement_direction *= -1;
	pass;

func process(_delta: float)->void:
	pass;
	
func physics_process(_delta: float):
	pass;

func turn_then_walk()->void:
	var c_turn_around_timer = 0.0;
	var inital_scale = body.scale;
	while c_turn_around_timer < turn_around_timer:
		await get_tree().process_frame;
		c_turn_around_timer += get_process_delta_time();
		NegativeScaleUtil.lerp_emulated_flip_to_negative_x_scale(
			body,
			inital_scale,
			_walking_context.movement_direction.x,
			0,
			c_turn_around_timer / turn_around_timer,
		);
	NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(
		body,
		_walking_context.movement_direction.x,
		0,
	);
	transition.emit("Walk");
	
	
