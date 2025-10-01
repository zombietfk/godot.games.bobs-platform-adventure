class_name Gib
extends RigidBody2D

# SETTINGS
@export var gib_sprites: Array[Texture2D]
@export var inital_force: float = 10;
@export_range(-1, 1) var force_horizontal_direction_bias: float = 0;
@export_range(-1, 1) var force_vertical_direction_bias: float = 0;

# FACTORY
static var gib_scene_path: String = "res://player/gibs/gib.tscn";
static func spawn(
	at: Vector2,
	force_direction_bias: Vector2 = Vector2.ZERO
) -> void:
	var gib: Gib = load(gib_scene_path).instantiate();
	gib.global_position = at;
	gib.force_horizontal_direction_bias = force_direction_bias.normalized().x;
	gib.force_vertical_direction_bias = force_direction_bias.normalized().y;
	Main.instance.add_child(gib);

# TRIGGERS
func _on_despawn_timer_timeout() -> void:
	queue_free();
	
# LIFECYCLE
func _ready() -> void:
	$Sprite2D.texture = gib_sprites[randi() % gib_sprites.size()];
	apply_impulse(Vector2(
		randf() + force_horizontal_direction_bias - 0.5, 
		randf() + force_vertical_direction_bias - 0.5
	).normalized() * inital_force);
