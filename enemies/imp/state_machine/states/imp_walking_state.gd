class_name ImpWalkingState;
extends AbstractImpState;

@export var knockpack_impetus = Vector2(1000, 1000);
@export var floor_check_raycast: RayCast2D;
@export var wall_check_raycast: RayCast2D;
@export var attack_shape_cast: ShapeCast2D;
var _walking_context: ImpMovementContext;

func enter(_from: AbstractState)->void:
	_walking_context = state_machine.get_context(
		"MovementContext"
	) as ImpMovementContext;
	NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(
		body,
		-sign(_walking_context.movement_direction.x),
		0
	);
	
func exit(_to: AbstractState)->void:
	body.velocity = Vector2.ZERO;
	pass;
	
func process(_delta: float)->void:
	if !floor_check_raycast.is_colliding() and _walking_context.turn_on_platform_edge:
		transition.emit("ChangeDirection");
		return;
	if wall_check_raycast.is_colliding():
		transition.emit("ChangeDirection");
		return;
	for result in attack_shape_cast.collision_result:
		var collided_with = instance_from_id(result["collider_id"]);
		if collided_with is Player:
			collided_with.damage(
				1,
				result.normal,
				knockpack_impetus,
			);
	
func physics_process(_delta: float):
	body.velocity = (
		_walking_context.movement_direction.normalized() *
		_walking_context.movement_speed +
		body.get_gravity()
	);
