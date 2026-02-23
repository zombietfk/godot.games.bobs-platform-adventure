class_name StageTwoBearState;
extends AbstractBearState;

@export var middle_stage_marker: Marker2D;
@export var time: float = 2.0;
@export var cloud_platform: CloudPlatform;
@export var beehive_scene: PackedScene;
@export var beehive_spawn_points: Array[Marker2D];
var _already_used_spawn_point: Array[Marker2D];
var _move_speed = 75;
var _min_distance_to_marker = 8;
var _jump_strength = -600;
var _jump_count = 0;
var _c_time = 0;

var _beehive_difficulty_by_bear_lives_remaining = [
	{
		"spawn_bee_every_x_seconds" : 1,
		"max_spawn_bees": 3,
	},
	{
		"spawn_bee_every_x_seconds" : 2,
		"max_spawn_bees": 1,
	},
	{
		"spawn_bee_every_x_seconds" : 60,
		"max_spawn_bees": 0,
	},
];

var beehives_to_summon_by_lives_remaining = [ 1, 2, 3 ]

func enter(_from: AbstractState)->void:
	cloud_platform.enable();
	animated_sprite.animation = "running";
	_already_used_spawn_point.clear();
	_jump_count = 0;
	_c_time = 0;
	bear.velocity = Vector2.ZERO;

func exit(_to: AbstractState)->void:
	pass;

func process(_delta: float)->void:
	pass;
	
func physics_process(delta: float)->void:
	var x_distance_to_marker = middle_stage_marker.global_position.x - bear.global_position.x;
	if abs(x_distance_to_marker) > _min_distance_to_marker:
		animated_sprite.animation = "running";
		NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(bear, sign(x_distance_to_marker));
		var direction = sign(x_distance_to_marker);
		bear.velocity += direction * _move_speed * delta * Vector2.RIGHT;
		bear.velocity.x = clamp(
			bear.velocity.x,
			-_move_speed,
			_move_speed
		);
	else:
		_c_time += delta;
		bear.velocity.x = 0;
		bear.global_position.x = middle_stage_marker.global_position.x;
		animated_sprite.animation = "forward";
		if bear.is_on_floor():
			if _c_time > time and bear.is_on_floor():
				animated_sprite.animation = "idle";
				transition.emit("Stage3State");
				return;
			if _jump_count == 1:
				var summoned_count = beehives_to_summon_by_lives_remaining[bear.lives - 1];
				while summoned_count > 0:
					_summon_beehive();
					summoned_count -= 1;
			bear.velocity.y = _jump_strength;
			_jump_count += 1;
	bear.velocity += bear.get_gravity() * delta;

func _summon_beehive()->void:
	if !bear.is_beehived:
		var pathed_beehive: Node2D = beehive_scene.instantiate();
		var spawn_point = beehive_spawn_points.pick_random();
		while _already_used_spawn_point.has(spawn_point):
			spawn_point = beehive_spawn_points.pick_random();
		_already_used_spawn_point.append(spawn_point);
		pathed_beehive.global_position = beehive_spawn_points.pick_random().global_position;
		Main.instance.level_instance.add_child(pathed_beehive);
		var beehive: Beehive = pathed_beehive.find_child("Beehive");
		var difficulty_adjustment = _beehive_difficulty_by_bear_lives_remaining[bear.lives - 1];
		beehive.spawn_bee_every_x_seconds = difficulty_adjustment["spawn_bee_every_x_seconds"];
		beehive.max_spawn_bees = difficulty_adjustment["max_spawn_bees"];
		beehive.wait_before_first_bee_spawn = 1.5;
		beehive.on_destroy.connect(func():
			_summon_beehive();
			_already_used_spawn_point.remove_at(
				_already_used_spawn_point.find(spawn_point)
			);
		);
		bear.on_hit_by_beehive.connect(beehive.knockdown_beehive);
