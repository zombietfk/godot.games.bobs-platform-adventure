class_name FlyingImpAttackingState;
extends AbstractFlyingImpState;

@export var attacking_speed = 800;
var attack_direction: Vector2;
@export var attacking_length_timer = 0.3;
var c_attacking_length_timer = 0.0;
@export var knockpack_impetus = Vector2(900, 900);
@export var attack_shape_cast: ShapeCast2D;

func is_floating_enabled() -> bool:
	return false;

func enter(_from: AbstractState)->void:
	attack_direction = (Main.instance.player.position - body.global_position).normalized();

func exit(_to: AbstractState)->void:
	pass;

func process(delta: float)->void:
	c_attacking_length_timer += delta;
	if c_attacking_length_timer > attacking_length_timer:
		c_attacking_length_timer = 0;
		transition.emit("Seeking");
	for result in attack_shape_cast.collision_result:
		var collision = instance_from_id(result["collider_id"]);
		if collision is Player:
			collision.damage(
				1,
				collision.normal,
				knockpack_impetus
			);

func physics_process(_delta: float):
	body.velocity = attack_direction * attacking_speed;
