class_name Main;
extends Node2D;

@export var inital_level: PackedScene;
static var player: Player;
static var instance: Main;

static func load_next_level(next_level: PackedScene) -> void:
	var level: Level = next_level.instantiate();
	level.ready.connect(instance._on_level_ready);
	player.spawn_position = level.player_start_marker.global_position;
	player.global_position = level.player_start_marker.global_position;
	instance.add_child(level);

func _on_level_ready() -> void:
	instance.get_node("./Game_UI/UI/Loading_Panel").set_visible(false);

func _ready() -> void:
	player = $Player;
	instance = self;
	load_next_level(inital_level);
