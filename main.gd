class_name Main;
extends Node2D;

static var player: Player;
static var instance: Main;
static var level_instance: Level;
@export_file() var inital_level_path: String;

static func load_next_level(next_level_path: String) -> void:
	if level_instance != null:
		level_instance.queue_free();
	var level = load(next_level_path).instantiate();
	level.ready.connect(instance._on_level_ready);
	level_instance = level;
	player.spawn_position = level.player_start_marker.global_position;
	player.global_position = level.player_start_marker.global_position;
	instance.add_child(level);

func _on_level_ready() -> void:
	instance.get_node("./Game_UI/UI/Loading_Panel").set_visible(false);

func _ready() -> void:
	player = $Player;
	instance = self;
	load_next_level(inital_level_path);
