class_name SawbladeTimedShooter;
extends Node2D;

@export var sawblade_scene: PackedScene;
@export var sawblade_travel_speed = 0;
@export var sawblade_travel_direction = Vector2.LEFT;
@export var sawblade_autodestroy = false;
@export var sawblade_autodestroy_after_x_seconds_timer = 0;
@export_flags_2d_physics var sawblade_physics_mask: int = 1;
@export var is_enabled = false;
@export var sawblade_scale: Vector2 = Vector2.ONE;

@export var fires_every_x_timer = 3.0;
var c_fires_every_x_timer = fires_every_x_timer;

func _enable_sawblade_on_swtich_press(_by: Node2D):
	is_enabled = true;

func _process(delta: float) -> void:
	if is_enabled:
		c_fires_every_x_timer += delta;
		if c_fires_every_x_timer > fires_every_x_timer:
			c_fires_every_x_timer = 0;
			var sawblade: Sawblade = sawblade_scene.instantiate();
			sawblade.scale = sawblade_scale;
			sawblade.travel_speed = sawblade_travel_speed;
			sawblade.travel_direction = sawblade_travel_direction;
			sawblade.autodestroy = sawblade_autodestroy;
			sawblade.autodestroy_after_x_seconds_timer = sawblade_autodestroy_after_x_seconds_timer;
			sawblade.position = global_position;
			sawblade.collision_mask = sawblade_physics_mask;
			Main.level_instance.add_child(sawblade);
