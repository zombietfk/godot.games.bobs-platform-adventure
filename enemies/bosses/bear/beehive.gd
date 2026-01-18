class_name Beehive;
extends CharacterBody2D

@export var is_falling: bool = false;
@export var falling_rotation_speed = 180;
@export var spawn_bee_every_x_seconds: float = 5;
@export var max_spawn_bees: int = 3;
@export var bee_scene: PackedScene;
var _bees_spawned = 0;
var _c_spawn_bee_timer = 0;
var _is_being_destroyed = false;

signal on_destroy();

func _ready() -> void:
	pass;

func _on_player_enter_area2D(body: Node2D) -> void:
	if !is_falling and body is Player:
		is_falling = true;

func _on_boss_bear_area_enter(body: Node2D) -> void:
	if is_falling and body is Bear:
		body.on_hit_by_beehive.emit();
		queue_free();

func _process(delta: float) -> void:
	_c_spawn_bee_timer += delta;
	if _c_spawn_bee_timer > spawn_bee_every_x_seconds and _bees_spawned < max_spawn_bees:
		_c_spawn_bee_timer = 0;
		var bee: Bee = bee_scene.instantiate();
		on_destroy.connect(bee.gib_and_kill);
		bee.on_death.connect(_reduce_bees_spawned_counter);
		bee.global_position = global_position;
		Main.instance.level_instance.add_child(bee);
		_bees_spawned += 1;
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
