class_name LevelEnemyDeathController;
extends Node

var _is_bunny_killed := false;
var _imp_death_count := 0;
var _is_demon_bunny_already_summoned := false;
var _is_door_already_opened := false;
@export var total_imps_to_be_killed := 4;
@export var demon_bunny_scene: PackedScene;
@export var demon_bunny_spawn_point: Marker2D;
signal all_imps_killed(); 

func on_bunny_death_handler() -> void:
	_is_bunny_killed = true;
	
func on_imp_killed() -> void:
	_imp_death_count += 1;

func _process(_delta: float) -> void:
	if _is_bunny_killed:
		_summon_demon_bunny_to_kill_player();
	if _imp_death_count >= total_imps_to_be_killed:
		_open_door();

func _open_door()->void:
	if _is_door_already_opened:
		return;
	_is_door_already_opened = true;
	all_imps_killed.emit();
	
func _summon_demon_bunny_to_kill_player()->void:
	if _is_demon_bunny_already_summoned:
		return;
	_is_demon_bunny_already_summoned = true;
	var bunny = demon_bunny_scene.instantiate() as Node2D;
	Main.instance.level_instance.add_child(bunny);
	bunny.global_position = demon_bunny_spawn_point.global_position;
