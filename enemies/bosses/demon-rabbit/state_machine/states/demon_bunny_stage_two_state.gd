class_name DemonBunnyStageTwoState;
extends AbstractDemonBunnyState;

@export var hop_size := 275.0;
@export var hop_timer := 0.5;
var _c_hop_timer := 0.0;
@export var hop_count := 5;
var _c_hop_count := hop_count;

@export var pitchfork_spawners: Array[SlotPitchforkSpawner];

var _is_awaiting_spin_result := false;

@export var slots_path: PathFollow2D;

var _skip_process = false;

func enter(_from: AbstractState)->void:
	_reset_state_variables();
	_c_hop_count = hop_count;
	body.sprite_body.play("angry");
	body.slots.stopped_spinning.connect(_on_slots_finish_spinning_handler);
	_skip_process = true;
	await _interpolate_slot_path_over_time(0, 1, 2);
	_skip_process = false;

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
	body.sprite_body.play("default");
	body.pitchfork.animation_player.play("spin_pitchfork");
	body.slots.spin_all_reels();
	_is_awaiting_spin_result = true;

func _on_slots_finish_spinning_handler(results: Array[ReelFace.Values])->void:
	_skip_process = true;
	body.pitchfork.animation_player.stop();
	_perform_slot_action(results);
	await get_tree().create_timer(5.0).timeout;
	transition.emit('StageOne');

func _reset_state_variables()->void:
	_c_hop_count = hop_count;
	_c_hop_timer = 0.0;
	_is_awaiting_spin_result = false;
	_skip_process = false;

func _perform_slot_action(faces: Array[ReelFace.Values])->void:
	for n in range(0,3):
		var face = faces[n];
		match face:
			ReelFace.Values.PITCHFORK:
				_fire_pitchforks(n);
			_:
				pass;

func _fire_pitchforks(in_zone: int):
	pitchfork_spawners[in_zone].spawn_pitchforks();
	
func _interpolate_slot_path_over_time(from: float, to: float, t: float)->void:
	var c_t := 0.0;
	while c_t < t:
		await get_tree().process_frame;
		slots_path.progress_ratio = lerp(from, to, (1 - cos(PI * (c_t / t))) / 2);
		c_t += get_process_delta_time();
	print(slots_path.progress_ratio);
