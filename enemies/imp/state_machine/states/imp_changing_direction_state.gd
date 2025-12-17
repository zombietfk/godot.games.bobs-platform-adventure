class_name ImpChangingDirectionState;
extends AbstractImpState;

@export var turn_around_timer = 1.0;
var _walking_context: ImpMovementContext;
var _target_x_movement_speed: float = 0.0;
var _target_body_scale: Vector2;
@export var animation_player: AnimationPlayer;

func enter(_from: AbstractState)->void:
	print('Turn');
	_walking_context = state_machine.get_context(
		"MovementContext"
	);
	body.velocity = Vector2.ZERO;
	turn_then_walk();
	
func exit(_to: AbstractState)->void:
	match body.flip_direction:
		Imp.FlipDirection.LEFT:
			body.flip_direction = Imp.FlipDirection.RIGHT;
			body.rotation = PI;
			body.scale = Vector2(1, -1);
		Imp.FlipDirection.RIGHT:
			body.flip_direction = Imp.FlipDirection.LEFT;
			body.rotation = 0;
			body.scale = Vector2(1, 1);
	_walking_context.x_movement_speed *= -1;
	
func process(_delta: float)->void:
	pass;
	
func physics_process(_delta: float):
	pass;

func turn_then_walk()->void:
	animation_player.play("Turn");
	await animation_player.animation_finished;
	print('Animation_Finished');
	transition.emit("Walk");
	
