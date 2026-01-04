class_name WalkingSpiderState;
extends AbstractSpiderState;

@export var animation_player: AnimationPlayer;
@export var jump_every_x_seconds_timer: float = 3;
@export var idle_animated_sprite: AnimatedSprite2D;
var _c_jump_every_x_seconds_timer: float = 0;

func enter(_from: AbstractState)->void:
	idle_animated_sprite.visible = true;
	body.velocity = Vector2.ZERO;
	
func exit(_to: AbstractState)->void:
	idle_animated_sprite.visible = false;
	animation_player.stop();

func process(delta: float)->void:
	_c_jump_every_x_seconds_timer += delta;
	if _c_jump_every_x_seconds_timer > jump_every_x_seconds_timer / 2:
		animation_player.play("shake");
	if _c_jump_every_x_seconds_timer > jump_every_x_seconds_timer:
		_c_jump_every_x_seconds_timer = 0;
		transition.emit("JumpingState");
	
func physics_process(_delta: float)->void:
	pass;
