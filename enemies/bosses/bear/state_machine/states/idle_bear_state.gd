class_name IdleBearState;
extends AbstractBearState;

func enter(_from: AbstractState)->void:
	animated_sprite.animation = "idle";
	await get_tree().create_timer(2.0, false).timeout;
	transition.emit("Stage1State");
	
	
func exit(_to: AbstractState)->void:
	pass;

func process(_delta: float)->void:
	pass;
	
func physics_process(delta: float)->void:
	bear.velocity += delta * bear.get_gravity();
