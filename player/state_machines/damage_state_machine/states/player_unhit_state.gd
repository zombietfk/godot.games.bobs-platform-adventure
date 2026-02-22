class_name PlayerUnhitState;
extends AbstractPlayerDamageState;

var _knockback_context: PlayerKnockbackContext

@export var damage_immunity_after_hit: float = 1.0;
@export var damaged_sounds: Array[AudioStreamPlayer];

func enter(_from: AbstractState)->void:
	_knockback_context = state_machine.get_context("KnockbackContext") as PlayerKnockbackContext
	if !body.on_take_damage.is_connected(_take_damage):
		body.on_take_damage.connect(_take_damage);
	
func exit(_to: AbstractState)->void:
	if body.on_take_damage.is_connected(_take_damage):
		body.on_take_damage.disconnect(_take_damage);
	
func process(_delta: float)->void:
	pass;
	
func physics_process(_delta: float)->void:
	pass;

func _take_damage(
	amount: int,
	from_direction: Vector2,
	knockback_strength: Vector2,
	knockback_duration_in_s: float,
)->void:
	body.velocity = Vector2.ZERO;
	if amount > 0:
		_play_take_damage_sound();
	body.current_health -= amount;
	_knockback_context.damage_immunity_duration = damage_immunity_after_hit;
	_knockback_context.knockback_direction = -from_direction;
	_knockback_context.knockback_strength = knockback_strength;
	_knockback_context.knockback_duration = knockback_duration_in_s;
	state_machine.current_state.transition.emit("Hit");

func _play_take_damage_sound()->void:
	var roll_lower_bond := 0;
	var roll_upper_bound := 100;
	var roll = randi_range(roll_lower_bond, roll_upper_bound);
	if roll <= 20:
		damaged_sounds[0].play();
	elif roll <= 60:
		damaged_sounds[1].play();
	else:
		damaged_sounds[2].play();
