class_name Gib
extends RigidBody2D

# SETTINGS
@export var gib_sprites: Array[Texture2D]
@export var inital_force: float = 10;
@export_range(-1, 1) var force_horizontal_direction_bias: float = 0;
@export_range(-1, 1) var force_vertical_direction_bias: float = 0;
@export var gib_sounds: Array[AudioStreamPlayer];

# INTERNAL STATE
var shrink_timer = 0.3;
var c_shrink_timer = 0.0;
var inital_scale: Vector2;

# FLAGS
var is_shrinking = false;

# FACTORY
static var gib_scene_path: String = "res://player/gibs/gib.tscn";

static func spawn(
	at: Vector2,
	force_direction_bias: Vector2 = Vector2.ZERO,
	using_gib_scene: String = gib_scene_path,
) -> void:
	var gib: Gib = load(using_gib_scene).instantiate();
	gib.global_position = at;
	gib.force_horizontal_direction_bias = force_direction_bias.normalized().x;
	gib.force_vertical_direction_bias = force_direction_bias.normalized().y;
	Main.instance.call_deferred("add_child",gib);

# TRIGGERS
func _on_despawn_timer_timeout() -> void:
	is_shrinking = true;

# LIFECYCLE
func _ready() -> void:
	$Sprite2D.texture = gib_sprites[randi() % gib_sprites.size()];
	apply_impulse(Vector2(
		randf() + force_horizontal_direction_bias - 0.5, 
		randf() + force_vertical_direction_bias - 0.5
	).normalized() * inital_force);
	inital_scale = scale;

func _process(delta: float) -> void:
	if is_shrinking:
		c_shrink_timer += delta;
		if(c_shrink_timer >= shrink_timer):
			queue_free();
			return;
		scale = lerp(
			inital_scale,
			Vector2.ZERO,
			c_shrink_timer / shrink_timer
		);

var _has_had_contact = false;

func _physics_process(_delta: float) -> void:
	if get_contact_count() > 0 and _has_had_contact == false:
		_has_had_contact = true;
		_play_gib_sound();
	elif get_contact_count() == 0:
		_has_had_contact = false;

func _play_gib_sound()->void:
	var roll_lower_bond := 0;
	var roll_upper_bound := 9;
	var roll = randi_range(roll_lower_bond, roll_upper_bound);
	if roll <= 6:
		return;
	elif roll <= 7:
		gib_sounds[0].play();
	elif roll <= 8:
		gib_sounds[1].play();
	elif roll <= 9:
		gib_sounds[2].play();
		
func _disable_contact_reporting():
	contact_monitor = false;
	lock_rotation = true;

func _enable_contact_reporting():
	contact_monitor = true;
	lock_rotation = false;
