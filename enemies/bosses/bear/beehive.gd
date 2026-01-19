class_name Beehive;
extends CharacterBody2D

@export var is_falling: bool = false;
@export var falling_rotation_speed = 180;
@export var spawn_bee_every_x_seconds: float = 5;
@export var max_spawn_bees: int = 3;
@export var wait_before_first_bee_spawn: float = 0.0;
@export var bee_scene: PackedScene;
@export var optional_activation_area: Area2D;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;
var _bees_spawned = 0;
var _c_spawn_bee_timer = 0;
var _is_being_destroyed = false;

signal on_destroy();
signal on_knocked_down();

func _ready() -> void:
	_c_spawn_bee_timer -= wait_before_first_bee_spawn;

func knockdown_beehive() -> void:
	if !is_falling:
		on_knocked_down.emit();
		is_falling = true;

func _on_player_enter_area2D(body: Node2D) -> void:
	if body is Player:
		knockdown_beehive();

func _on_boss_bear_area_enter(body: Node2D) -> void:
	if is_falling and body is Bear:
		body.on_hit_by_beehive.emit();
		queue_free();

func _process(delta: float) -> void:
	_c_spawn_bee_timer += delta;
	var is_active = true;
	if optional_activation_area and !optional_activation_area.overlaps_body(Main.instance.player):
		is_active = false;
	if (_c_spawn_bee_timer > spawn_bee_every_x_seconds and 
		_bees_spawned < max_spawn_bees and
		is_active and
		!is_falling and
		!_is_being_destroyed
	):
		_c_spawn_bee_timer = 0;
		_bees_spawned += 1;
		if !animation_player.is_playing():
			animation_player.play("sway");
		await get_tree().create_timer(1).timeout;
		if is_falling or _is_being_destroyed:
			return;
		var bee: Bee = bee_scene.instantiate();
		on_knocked_down.connect(bee.gib_and_kill);
		bee.on_death.connect(_reduce_bees_spawned_counter);
		bee.global_position = global_position;
		Main.instance.level_instance.add_child(bee);
	if is_falling and is_on_floor():
		is_falling = false;
		_free_after_x_seconds(2.0);

func _physics_process(delta: float) -> void:
	if is_falling:
		velocity += get_gravity() * 0.1 * delta;
		rotation_degrees += falling_rotation_speed * delta;
	move_and_slide()

func _reduce_bees_spawned_counter()->void:
	_bees_spawned -= 1;

func _free_after_x_seconds(x: float)->void:
	if _is_being_destroyed:
		return;
	_is_being_destroyed = true;
	falling_rotation_speed = 0;
	modulate = Color(1.0,1.0,1.0,0.5);
	await get_tree().create_timer(x).timeout;
	on_destroy.emit();
	queue_free();
