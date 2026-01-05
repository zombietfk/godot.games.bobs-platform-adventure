class_name Spider;
extends AbstractEnemy;

@export var knockback_strength = Vector2.ONE * 500;

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_attack_area_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(
			1,
			global_position - body.global_position,
			knockback_strength
		);
