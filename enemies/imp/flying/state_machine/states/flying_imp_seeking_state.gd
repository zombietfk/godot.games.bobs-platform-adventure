class_name FlyingImpSeekingState;
extends AbstractFlyingImpState;

@export var seeking_speed = 200;
@export var prepare_attack_at_range = 125.0;

func enter(_from: AbstractState)->void:
	pass;

func exit(_to: AbstractState)->void:
	pass;

func process(_delta: float)->void:
	if (
		body.global_position.distance_to(
			Main.instance.player.position
		) < prepare_attack_at_range
	):
		transition.emit("PrepareAttack");
				

func physics_process(_delta: float):
	body.velocity = (
		Main.instance.player.position - body.global_position
	).normalized() * seeking_speed;
