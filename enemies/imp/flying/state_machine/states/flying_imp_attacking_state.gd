class_name FlyingImpAttackingState;
extends AbstractFlyingImpState;

@export var attacking_speed = 800;
var _attack_direction: Vector2;
@export var attacking_length_timer = 0.3;
var _c_attacking_length_timer = 0.0;
@export var knockpack_impetus = Vector2(900, 900);
@export var attack_shape_cast: ShapeCast2D;

func is_floating_enabled() -> bool:
	return false;

func enter(_from: AbstractState)->void:
	_attack_direction = (Main.instance.player.position - body.global_position).normalized();
	_c_attacking_length_timer = 0;
	
func exit(_to: AbstractState)->void:
	pass;

func process(delta: float)->void:
	_c_attacking_length_timer += delta;
	if _c_attacking_length_timer > attacking_length_timer:
		transition.emit("Seek");
	for result in attack_shape_cast.collision_result:
		var collided_with = instance_from_id(result["collider_id"]);
		if collided_with is Player:
			collided_with.damage(
				1,
				result.normal,
				knockpack_impetus
			);

func physics_process(_delta: float):
	body.velocity = _attack_direction * attacking_speed;
