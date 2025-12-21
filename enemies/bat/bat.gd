class_name Bat;
extends AbstractEnemy;

@export var knockback_strength = Vector2.ONE * 500;
@export var attack_shape_cast: ShapeCast2D;

func _physics_process(_delta: float) -> void:
	move_and_slide();

func process_attack() -> void:
	for n in attack_shape_cast.get_collision_count():
		if attack_shape_cast.get_collider(n) is Player:
			Main.instance.player.damage(
				1,
				attack_shape_cast.get_collision_normal(n),
				knockback_strength
			);
