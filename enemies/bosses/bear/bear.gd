class_name Bear;
extends AbstractEnemy;

var is_beehived := false;
var _knockback_strength := 600;
@export var lives := 3;
@onready var state_machine: StateMachine = $StateMachine;

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
	var original_scale = scale;
	for i in 100:
		Gib.spawn(global_position, Vector2(sin((i * 4) / 50.0), -1));
		scale = lerp(original_scale, Vector2.ZERO, i / 100.0);
		await get_tree().create_timer(0.05, false).timeout;
	super.gib_and_kill();
