class_name Main;
extends Node2D;

enum DIFFICULTY {
	EASY = 50,
	NORMAL = 10,
	HARD = 3,
}

const STANDARD_UNIT = 64;

# SETTINGS
@export_file() var inital_level_path: String;
@export_file() var inital_checkpoint_path: String;
@export var camera: Camera2D;

# INTERNAL STATE
static var player: Player;
static var instance: Main;
static var level_instance: Level;
static var current_level_path: String;
static var current_spawn_level: String;
static var current_spawn_index = 0;
static var checkpoint_spawn_level: String;
static var checkpoint_spawn_index = 0;
static var difficulty = DIFFICULTY.EASY;
static var persistant_trigger_labels: Array[String] = [];

# TRIGGERS
func _on_level_ready() -> void:
	$GameUI/UI/LoadingPanel.set_visible(false);

# LIFECYCLE
func _ready() -> void:
	player = $Player;
	instance = self;
	RenderingServer.set_default_clear_color(Color.BLACK);
	update_spawn(inital_level_path, 0);
	update_checkpoint(inital_checkpoint_path, 0);
	load_level();

# UTILITY
static func update_spawn(next_level_path: String, with_spawn_index: int = 0) -> void:
	current_spawn_level = next_level_path;
	current_spawn_index = with_spawn_index;

static func update_checkpoint(
	checkpoint_level_path: String,
	checkpoint_level_spawn_index: int = 0
) -> void:
	checkpoint_spawn_level = checkpoint_level_path;
	checkpoint_spawn_index = checkpoint_level_spawn_index;

static func reset_lives_load_checkpoint_level() -> void:
	player.lives = difficulty;
	load_level(checkpoint_spawn_level, checkpoint_spawn_index);

static func load_level(
	level_path: String = current_spawn_level,
	spawn_index: int = current_spawn_index,
	zero_velocity = true,
) -> void:
	Main.instance.player.camera.reparent(Main.instance.player);
	Main.instance.player.camera.position = Vector2.ZERO;
	update_spawn(level_path, spawn_index);
	current_level_path = level_path;
	if level_instance != null:
		level_instance.queue_free();
	await Main.instance.get_tree().process_frame;
	var level = load(level_path).instantiate() as Level;
	level.ready.connect(instance._on_level_ready);
	level_instance = level;
	# Set limits for game camera
	player.camera.limit_left = int(level_instance.level_binding_box.position.x);
	player.camera.limit_top = int(level_instance.level_binding_box.position.y);
	player.camera.limit_right = int(level_instance.level_binding_box.size.x);
	player.camera.limit_bottom = int(level_instance.level_binding_box.size.y);
	instance.call_deferred("add_child", level);
	if zero_velocity:
		player.velocity = Vector2.ZERO;
	player.global_position = level.spawn_locations[spawn_index].global_position;

func _process(_delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_H):
		$GameUI.visible = false;
