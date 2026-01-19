class_name Bear;
extends AbstractEnemy;

var is_beehived = false;
var _knockback_strength = 600;
@export var lives = 3;

@warning_ignore("unused_signal")
signal on_hit_by_beehive();

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_attack_area_enter(body: Node2D)->void:
	if body is Player:
		body.damage(
			1,
			(global_position - body.global_position),
			Vector2.ONE * _knockback_strength
		);

func gib_and_kill() -> void:
	for i in 100:
		Gib.spawn(global_position, Vector2(sin((i * 4) / 50.0), -1));
		scale.x -= 0.01;
		scale.y += 0.01;
		await get_tree().create_timer(0.05).timeout;
	super.gib_and_kill();
