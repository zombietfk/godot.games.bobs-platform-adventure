class_name MushroomSpore;
extends RigidBody2D

var _floor_raycast_check_length := 15.0;

func _process(delta: float) -> void:
	var floorcast_result = get_world_2d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + Vector2.DOWN * _floor_raycast_check_length,
			0b1000000
		)
	)
	if floorcast_result.has('collider'):
		if linear_velocity.y <= 0:
			queue_free();
	
func _player_hit_spore()->void:
	Main.instance.player.damage(1, Vector2.ZERO);
	queue_free();
