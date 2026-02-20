class_name EnemySpawner;
extends Node2D

@export var enemy_scene: PackedScene;
@export var spawn_every_x_seconds: float = 3.0;
var _c_spawn_timer: float = 0;
@export var stop_spawning_after_period := true;
@export var stop_spawning_after_x_seconds: float = 30;
@export var play_sound_on_spawn: AudioStreamPlayer2D = null;
var _c_stop_spawn_timer: float = 0;

func _spawn_on_trigger()->void:
	spawn();

func spawn()->Node2D:
	if play_sound_on_spawn != null:
		play_sound_on_spawn.play();
	var enemy: Node2D = enemy_scene.instantiate();
	enemy.global_position = global_position;
	Main.instance.level_instance.add_child(enemy);
	return enemy;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stop_spawning_after_period:
		_c_stop_spawn_timer += delta;
		if _c_stop_spawn_timer > stop_spawning_after_x_seconds:
			return;
	_c_spawn_timer += delta;
	if _c_spawn_timer > spawn_every_x_seconds:
		_c_spawn_timer = 0;
		_spawn_on_trigger();
