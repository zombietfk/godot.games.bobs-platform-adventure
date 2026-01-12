class_name Worm;
extends Node2D;

@onready var animation_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D;
@onready var collider_animation: AnimationPlayer = $AnimationPlayer;
@onready var attack_area: Area2D = $Area2D;
@export var worm_path: Path2DCyclical;
@export var in_ground_time: float = 1;
@export var knockback_strength = Vector2.ONE * 500;

func _ready() -> void:
	worm_path.paused = true;
	animation_sprite_2d.animation_finished.connect(_wait_until_reemerge);

func change_dig_direction()->void:
	scale *= -1;

func _on_player_enter_attack_area(body: Node2D)->void:
	if body is Player:
		body.damage(
			1,
			global_position - body.global_position,
			knockback_strength
		);

func _wait_until_reemerge()->void:
	worm_path.paused = false;
	attack_area.monitoring = false;
	collider_animation.stop();
	await get_tree().create_timer(in_ground_time).timeout;
	worm_path.paused = true;
	attack_area.monitoring = true;
	animation_sprite_2d.play();
	collider_animation.play("move_collider");
