class_name TeleportToLevelZone;
extends Area2D

# SETTINGS
@export_file("*.tscn") var to_level_path: String;
@export var to_spawn_location_with_index = 0;
@export var zero_player_velocity = true;

func _ready() -> void:
	# Called to avoid issues when loaded and player overlaps on spawn
	await get_tree().process_frame;
	monitoring = true;

# TRIGGERS
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if to_level_path != null:
			Main.load_level(to_level_path, to_spawn_location_with_index, zero_player_velocity);
