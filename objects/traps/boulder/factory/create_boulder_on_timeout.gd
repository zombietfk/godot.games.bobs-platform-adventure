class_name CreateBoulderOnTimeoutFactory;
extends Node2D;

@export var boulder_scene: PackedScene;
@export var boulder_travel_speed = 0.0;
@export var boulder_travel_direction = Vector2.LEFT;
@export var boulder_autodestroy = true;
@export var boulder_autodestroy_after_x_seconds_timer = 3.0;
@export var boulder_use_gravity = true;
@export_flags_2d_physics var boulder_physics_mask: int = 1;
@export var is_enabled = true;

@export var fires_every_x_timer = 3.0;
var c_fires_every_x_timer = fires_every_x_timer;

func _enable_sawblade_on_swtich_press(_by: Node2D):
	is_enabled = true;

func _process(delta: float) -> void:
	if is_enabled:
		c_fires_every_x_timer += delta;
		if c_fires_every_x_timer > fires_every_x_timer:
			c_fires_every_x_timer = 0;
			var boulder: Boulder = boulder_scene.instantiate();
			boulder.travel_speed = boulder_travel_speed;
			boulder.travel_direction = boulder_travel_direction;
			boulder.autodestroy = boulder_autodestroy;
			boulder.autodestroy_after_x_seconds_timer = boulder_autodestroy_after_x_seconds_timer;
			boulder.position = global_position;
			boulder.collision_mask = boulder_physics_mask;
			Main.level_instance.add_child(boulder);
