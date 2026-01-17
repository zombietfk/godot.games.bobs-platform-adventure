class_name Bear;
extends CharacterBody2D;

var _knockback_strength = 600;

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_attack_area_enter(body: Node2D)->void:
	if body is Player:
		body.damage(
			1,
			(global_position - body.global_position),
			Vector2.ONE * _knockback_strength
		);
