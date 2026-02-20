class_name JumpingSpiderState;
extends AbstractSpiderState;

@export var jump_sound: AudioStreamPlayer2D;
@export var jumping_animated_sprite: AnimatedSprite2D;
@export var max_horizontal_jump_speed = 300;
var _jump_impulse: Vector2 = Vector2.ZERO;
var airbone_check_flag = false;

func enter(_from: AbstractState)->void:
	jump_sound.play();
	airbone_check_flag = false;
	jumping_animated_sprite.visible = true;
	_jump_impulse = -Vector2(
		0,
		body.global_position.y - Main.instance.player.global_position.y + body.get_gravity().y * 0.5,
	);
	body.velocity = _jump_impulse;

func exit(_to: AbstractState)->void:
	jumping_animated_sprite.visible = false;

func process(_delta: float)->void:
	if !body.is_on_floor():
		airbone_check_flag = true;
	if airbone_check_flag and body.is_on_floor():
		airbone_check_flag = false;
		body.velocity = Vector2.ZERO;
		transition.emit("FloorState");

func physics_process(_delta: float)->void:
	if body.velocity.x == 0:
		var distance_to_player = Main.instance.player.global_position.x - body.global_position.x;
		body.velocity.x = sign(distance_to_player) * min(
			abs(distance_to_player),
			max_horizontal_jump_speed
		);
	body.velocity += body.get_gravity() * _delta;
	pass;
