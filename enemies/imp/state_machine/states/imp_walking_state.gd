class_name ImpWalkingState;
extends AbstractImpState;

@export var knockpack_impetus = Vector2(500, 500);
@export var floor_check_raycast: RayCast2D;
@export var wall_check_raycast: RayCast2D;
@export var attack_shape_cast: ShapeCast2D;
@export var animation_player: AnimationPlayer;
var _walking_context: ImpMovementContext;

func enter(_from: AbstractState)->void:
	_walking_context = state_machine.get_context(
		"MovementContext"
	) as ImpMovementContext;
	animation_player.play("Walking");
	
func exit(_to: AbstractState)->void:
	pass;
	
func process(_delta: float)->void:
	if !floor_check_raycast.is_colliding() and _walking_context.turn_on_platform_edge:
		transition.emit("ChangeDirection");
	if wall_check_raycast.is_colliding():
		transition.emit("ChangeDirection");
	for result in attack_shape_cast.collision_result:
		var collided_with = instance_from_id(result["collider_id"]);
		if collided_with is Player:
			collided_with.damage(
				1,
				result.normal,
				knockpack_impetus
			);
	
func physics_process(delta: float):
	body.velocity.x = -sign(body.flip_direction) * _walking_context.x_movement_speed;
	body.velocity += body.get_gravity() * delta;
