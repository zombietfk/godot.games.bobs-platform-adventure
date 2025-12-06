class_name Level;
extends Node2D;

# SETTINGS
@export var level_binding_box: Rect2;
@export var spawn_locations: Array[Marker2D];
@export var camera_zoom_to: Vector2 = Vector2(1.3, 1.3);
@export var camera_zoom_speed = 0.1;
var camera_zoom_timer: float = 2.0;
var c_camera_zoom_timer: float = 0;

# LIFECYCLE
func _process(delta: float) -> void:
	if Main.instance.player.camera.zoom != camera_zoom_to:
		c_camera_zoom_timer += delta * camera_zoom_speed;
		Main.instance.player.camera.zoom = (
			lerp(
				Main.instance.player.camera.zoom,
				camera_zoom_to,
				c_camera_zoom_timer / camera_zoom_timer
			)
		);
		if c_camera_zoom_timer >= camera_zoom_timer:
			Main.instance.player.camera.zoom = camera_zoom_to;
