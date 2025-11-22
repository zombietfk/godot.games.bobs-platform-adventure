class_name Main;
extends Node2D;

enum DIFFICULTY {
	EASY,
	NORMAL,
	HARD,
}

# SETTINGS
@export_file() var inital_level_path: String;

# INTERNAL STATE
static var player: Player;
static var instance: Main;
static var level_instance: Level;
static var current_level_path: String;
static var current_spawn_level: String;
static var current_spawn_index = 0;
static var difficulty = DIFFICULTY.NORMAL;

# TRIGGERS
func _on_level_ready() -> void:
	$GameUI/UI/LoadingPanel.set_visible(false);

# LIFECYCLE
func _ready() -> void:
	player = $Player;
	instance = self;
	RenderingServer.set_default_clear_color(Color.BLACK);
	update_spawn(inital_level_path, 0);
	load_level();
	print('Game Start, setting player position', player.global_position);

# UTILITY
static func update_spawn(next_level_path: String, with_spawn_index: int = 0) -> void:
	current_spawn_level = next_level_path;
	current_spawn_index = with_spawn_index;

static func load_level(
	level_path: String = current_spawn_level,
	spawn_index: int = current_spawn_index,
) -> void:
	if Main.difficulty == Main.DIFFICULTY.EASY:
		update_spawn(level_path, spawn_index);
	current_level_path = level_path;
	if level_instance != null:
		level_instance.queue_free();
	var level = load(level_path).instantiate() as Level;
	level.ready.connect(instance._on_level_ready);
	level_instance = level;
	# Set limits for game camera
	player.camera.limit_left = int(level_instance.level_binding_box.position.x);
	player.camera.limit_top = int(level_instance.level_binding_box.position.y);
	player.camera.limit_right = int(
		level_instance.level_binding_box.position.x +
		level_instance.level_binding_box.size.x
	);
	player.camera.limit_bottom = int(
		level_instance.level_binding_box.position.y +
		level_instance.level_binding_box.size.y
	);
	instance.call_deferred("add_child", level);
	player.velocity = Vector2.ZERO;
	player.global_position = level.spawn_locations[spawn_index].global_position;
