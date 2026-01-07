class_name CreateBoulderAbstractFactory;
extends Node2D;

@export var boulder_scene: PackedScene;
@export var boulder_travel_speed = 0.0;
@export var boulder_scale = Vector2.ONE;
@export var boulder_travel_direction = Vector2.LEFT;
@export var boulder_autodestroy = true;
@export var boulder_autodestroy_after_x_seconds_timer = 3.0;
@export var boulder_use_gravity = true;
@export var boulder_gravity_factor = 0.3;
@export_flags_2d_physics var boulder_physics_mask: int = 1;

func _create()->void:
	var boulder: Boulder = boulder_scene.instantiate();
	boulder.travel_speed = boulder_travel_speed;
	boulder.travel_direction = boulder_travel_direction;
	boulder.autodestroy = boulder_autodestroy;
	boulder.autodestroy_after_x_seconds_timer = boulder_autodestroy_after_x_seconds_timer;
	boulder.position = global_position;
	boulder.scale = boulder_scale;
	boulder.collision_mask = boulder_physics_mask;
	boulder.gravity_factor = boulder_gravity_factor;
	Main.level_instance.add_child(boulder);
