class_name FlyingImpPrepareAttackState;
extends AbstractFlyingImpState;

@export var attack_pause_length_timer = 1.0;
var c_attack_pause_length_timer = 0.0;
@export var body_alert_notification: Node2D;

func is_movement_enabled() -> bool:
	return false;

func enter(_from: AbstractState)->void:
	body_alert_notification.visible = true;

func exit(_to: AbstractState)->void:
	body_alert_notification.visible = false;

func process(delta: float)->void:
	c_attack_pause_length_timer += delta;
	if c_attack_pause_length_timer > attack_pause_length_timer:
		c_attack_pause_length_timer = 0;
		transition.emit("Attack");

func physics_process(_delta: float):
	pass;
