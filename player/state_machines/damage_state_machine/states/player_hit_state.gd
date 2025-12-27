class_name PlayerHitState;
extends AbstractPlayerDamageState;

var _movement_context: PlayerMovementContext;
var _knockback_context: PlayerKnockbackContext;
var _c_knockback_timer: float;
var _inital_knockback_impetus: Vector2;

func enter(_from: AbstractState)->void:
	_knockback_context = state_machine.get_context("KnockbackContext") as PlayerKnockbackContext
	_movement_context = state_machine.get_context("MovementContext") as PlayerMovementContext;
	_movement_context.knockback_impetus = (
		_knockback_context.knockback_direction.normalized() *
		_knockback_context.knockback_strength
	);
	body.velocity = Vector2.ZERO;
	_inital_knockback_impetus = Vector2(_movement_context.knockback_impetus);
	print('Hit')
	print(_knockback_context.knockback_direction.normalized());
	print(_knockback_context.knockback_strength);
	_c_knockback_timer = _knockback_context.knockback_duration;
	body.modulate.a = 0.5;
	
func exit(_to: AbstractState)->void:
	body.modulate.a = 1;
	
func process(delta: float)->void:
	_knockback_context.damage_immunity_duration -= delta;
	if _knockback_context.damage_immunity_duration <= 0:
		transition.emit("Unhit");
	
func physics_process(delta: float)->void:
	_c_knockback_timer -= delta;
	if _c_knockback_timer <= 0:
		_movement_context.knockback_impetus = Vector2.ZERO;
