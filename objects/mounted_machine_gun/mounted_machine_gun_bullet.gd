class_name MountedMachineGunBullet;
extends Node2D;

@export var movement_direction: Vector2 = Vector2.RIGHT;
@export var movement_speed: float = 500.0;
@onready var collision_raycast: RayCast2D = $RayCast2D;

func _physics_process(delta: float) -> void:
	rotation = movement_direction.angle();
	position += movement_direction.normalized() * movement_speed * delta;
	if collision_raycast.is_colliding():
		var collider: Node2D = $RayCast2D.get_collider();
		if collider.has_method("gib_and_kill"):
			collider.gib_and_kill();
		if collider.has_method("shatter"):
			collider.shatter();
		if collider.has_method("hit_by_bullet"):
			collider.hit_by_bullet();
		queue_free();
