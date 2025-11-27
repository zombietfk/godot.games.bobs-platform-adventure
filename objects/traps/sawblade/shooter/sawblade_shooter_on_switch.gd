class_name SawbladeSwitchedShooter;
extends Node2D;

@export var sawblade_scene: PackedScene;
@export var sawblade_travel_speed = 0;
@export var sawblade_travel_direction = Vector2.LEFT;
@export var sawblade_autodestroy = false;
@export var sawblade_autodestroy_after_x_seconds_timer = 0;
@export_flags_2d_physics var sawblade_physics_mask: int = 1;

func _fire_sawblade_on_swtich_press(_by: Node2D):
	var sawblade: Sawblade = sawblade_scene.instantiate();
	sawblade.travel_speed = sawblade_travel_speed;
	sawblade.travel_direction = sawblade_travel_direction;
	sawblade.autodestroy = sawblade_autodestroy;
	sawblade.autodestroy_after_x_seconds_timer = sawblade_autodestroy_after_x_seconds_timer;
	sawblade.position = global_position;
	sawblade.collision_mask = sawblade_physics_mask;
	Main.level_instance.call_deferred('add_child', sawblade);
