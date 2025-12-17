@abstract
class_name AbstractFlyingImpState;
extends AbstractState;

@export var body: FlyingImp;

func is_movement_enabled() -> bool:
	return true;

func is_floating_enabled() -> bool:
	return true;
