class_name BatSleepingState;
extends AbstractBatState;

@export var player_below_check_raycast: RayCast2D;
@export var hanging_sprite: AnimatedSprite2D;
@export var flying_sprite: AnimatedSprite2D;
@export var animation_player: AnimationPlayer;
@export var time_to_awaken: float = 2.0;

var _is_awakening: bool = false;

func enter(_from: AbstractState)->void:
	hanging_sprite.visible = true;
	flying_sprite.visible = false;
	pass;

func exit(_to: AbstractState)->void:
	hanging_sprite.visible = false;
	flying_sprite.visible = true;
	pass;
	
func process(_delta: float)->void:
	if player_below_check_raycast.get_collider() is Player:
		_awaken();

func physics_process(_delta: float):
	pass;

func _awaken() -> void:
	if _is_awakening:
		return;
	_is_awakening = true;
	hanging_sprite.play("waking_up");
	animation_player.play("awaken");
	await get_tree().create_timer(time_to_awaken).timeout;
	animation_player.stop();
	_is_awakening = false;
	transition.emit("Glide")
