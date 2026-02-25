class_name DemonBunnyStageTwoState;
extends AbstractDemonBunnyState;

@export var hop_size := 275.0;
@export var hop_timer := 0.5;
var _c_hop_timer := 0.0;
@export var hop_count := 5;
var _c_hop_count := hop_count;

@export var pitchfork_spawners: Array[SlotPitchforkSpawner];
@export var rock_spawners: Array[EnemySpawner];
@export var spike_spawners: Array[EnemySpawner];
@export var spider_spawners: Array[EnemySpawner];
@export var imp_spawner: EnemySpawner;
@export var super_bunny_spawner: EnemySpawner;
@export var spin_reels_sound: AudioStreamPlayer;

var _is_awaiting_spin_result := false;

@export var slots_path: PathFollow2D;

var _skip_process := false;
var _imp_ref : FlyingImp = null;
var _superbunny_summoned := false;
var _slot_spin_speed_min := 0.7;
var _slot_spin_speed_max := 0.9; 

func enter(_from: AbstractState)->void:
	_reset_state_variables();
	_c_hop_count = hop_count;
	body.sprite_body.play("angry");
	body.slots.stopped_spinning.connect(_on_slots_finish_spinning_handler);
	_skip_process = true;
	await _interpolate_slot_path_over_time(0, 1, 1);
	_skip_process = false;
	_imp_ref = imp_spawner.spawn() as FlyingImp;

func exit(_to: AbstractState)->void:
	body.slots.stopped_spinning.disconnect(_on_slots_finish_spinning_handler);
	
func process(_delta: float)->void:
	pass;

func physics_process(delta: float)->void:
	if _skip_process:
		return;
	if _c_hop_count > 0:
		_c_hop_timer += delta;
		if _c_hop_timer >= hop_timer and body.is_on_floor():
			body.velocity += Vector2.UP * hop_size;
			_c_hop_timer = 0;
			_c_hop_count -= 1; 
	elif body.is_on_floor() and !_is_awaiting_spin_result:
		_spin_reels();
	body.velocity += body.get_gravity() * delta;
	body.move_and_slide();

func _spin_reels()->void:
	spin_reels_sound.play();
	body.sprite_body.play("default");
	body.pitchfork.animation_player.play("spin_pitchfork");
	body.slots.spin_all_reels(_slot_spin_speed_min, _slot_spin_speed_max);
	_is_awaiting_spin_result = true;

func _on_slots_finish_spinning_handler(results: Array[ReelFace.Values])->void:
	_skip_process = true;
	_imp_ref.gib_and_kill();
	body.pitchfork.animation_player.stop();
	_perform_slot_action(results);
	_interpolate_slot_path_over_time(1, 0, 2);
	await get_tree().create_timer(5.0, false).timeout;
	if !_superbunny_summoned:
		transition.emit('StageOne');

func _reset_state_variables()->void:
	match body.health:
		1:
			_slot_spin_speed_min = 1.5;
			_slot_spin_speed_max = 1.9;
		2:
			_slot_spin_speed_min = 1.3;
			_slot_spin_speed_max = 1.6;
		_:
			_slot_spin_speed_min = 0.7;
			_slot_spin_speed_max = 0.9;
	_c_hop_count = hop_count;
	_c_hop_timer = 0.0;
	_is_awaiting_spin_result = false;
	_skip_process = false;
	_superbunny_summoned = false;

func _perform_slot_action(faces: Array[ReelFace.Values])->void:
	var superbunnies = 0;
	for n in range(0,3):
		var face = faces[n];
		match face:
			ReelFace.Values.PITCHFORK:
				_fire_pitchforks(n);
			ReelFace.Values.ROCK:
				_fire_rock(n);
			ReelFace.Values.SPIKE:
				_fire_spike(n);
			ReelFace.Values.SPIDER:
				_create_spider(n);
			ReelFace.Values.RABBIT:
				superbunnies += 1;
			_:
				pass;
	if superbunnies == 3:
		_create_super_bunny();

func _fire_pitchforks(in_zone: int):
	pitchfork_spawners[in_zone].spawn_pitchforks();

func _fire_rock(in_zone: int):
	await get_tree().create_timer(2.5, false).timeout;
	rock_spawners[in_zone].spawn();

func _fire_spike(in_zone: int):
	await get_tree().create_timer(3.0, false).timeout;
	spike_spawners[in_zone].spawn();

func _create_spider(in_zone: int):
	await get_tree().create_timer(2.0, false).timeout;
	spider_spawners[in_zone].spawn();

func _create_super_bunny():
	_superbunny_summoned = true;
	await get_tree().create_timer(2.0, false).timeout;
	super_bunny_spawner.spawn();

func _interpolate_slot_path_over_time(from: float, to: float, t: float)->void:
	var c_t := 0.0;
	while c_t < t:
		await get_tree().process_frame;
		slots_path.progress_ratio = lerp(from, to, (1 - cos(PI * (c_t / t))) / 2);
		c_t += get_process_delta_time();

func _on_death()->void:
	body.sprite_body.play('stunned');
	body.gib_and_kill();

func _on_take_damage()->void:
	body.sprite_body.play('stunned');
	await get_tree().create_timer(3.0, false).timeout;
	transition.emit("StageOne");
