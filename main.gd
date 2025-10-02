class_name Main;
extends Node2D;

# SETTINGS
@export_file() var inital_level_path: String;

# INTERNAL STATE
static var player: Player;
static var instance: Main;
static var level_instance: Level;
static var current_level_path: String;

# TRIGGERS
func _on_level_ready() -> void:
	$GameUI/UI/LoadingPanel.set_visible(false);

# LIFECYCLE
func _ready() -> void:
	player = $Player;
	instance = self;
	load_next_level(inital_level_path);

# UTILITY
static func load_next_level(next_level_path: String) -> void:
	current_level_path = next_level_path;
	reload_current_level()

static func reload_current_level() -> void:
	if level_instance != null:
		level_instance.queue_free();
	var level = load(current_level_path).instantiate();
	level.ready.connect(instance._on_level_ready);
	level_instance = level;
	player.spawn_position = level.player_start_marker.global_position;
	player.global_position = level.player_start_marker.global_position;
	instance.add_child(level);
