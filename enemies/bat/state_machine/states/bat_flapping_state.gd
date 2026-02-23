class_name BatFlappingState;
extends AbstractBatState;

@export var move_speed: float = 50;
@export var flaps_until_return_to_glide: int = 6;
@export var rest_between_flaps_timer: float = 0.2;
@export var flap_strength: float = 200;
@export var flying_animated_sprite: AnimatedSprite2D;

var _flap_impulse: Vector2 = Vector2.ZERO;
var _c_flap_count: int = 0;

func enter(_from: AbstractState)->void:
	_c_flap_count = 0;
	_begin_flapping();
	pass;

func exit(_to: AbstractState)->void:
	flying_animated_sprite.frame = 0;
	flying_animated_sprite.stop();
	pass;

func process(_delta: float)->void:
	body.process_attack();

func physics_process(delta: float):
	body.velocity = (
		body._astar_get_next_step_to_target(
			Main.instance.player.global_position,
			Main.STANDARD_UNIT * 1
		)
	).normalized() * move_speed + body.get_gravity() * delta + _flap_impulse;
	_flap_impulse += body.get_gravity() * delta
	_flap_impulse.y = clamp(_flap_impulse.y, -flap_strength, 0);
	
func _begin_flapping() -> void:
	while _c_flap_count < flaps_until_return_to_glide:
		flying_animated_sprite.frame = 0;
		flying_animated_sprite.play();
		_flap_impulse = Vector2.UP * flap_strength;
		_c_flap_count += 1;
		await get_tree().create_timer(rest_between_flaps_timer, false).timeout;
	transition.emit("Glide");
