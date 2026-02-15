class_name DemonBunnyStageTwoState;
extends AbstractDemonBunnyState;

@export var hop_size := 275.0;
@export var hop_timer := 0.5;
var _c_hop_timer := 0.0;
@export var hop_count := 5;
var _c_hop_count := hop_count;

@export var slots_spin_duration := 3.0;

var _is_awaiting_spin_result := false;

func enter(_from: AbstractState)->void:
	_c_hop_count = hop_count;
	body.sprite_body.play("angry");
	body.slots.stopped_spinning.connect(_on_slots_finish_spinning_handler);

func exit(_to: AbstractState)->void:
	body.slots.stopped_spinning.disconnect(_on_slots_finish_spinning_handler);

func process(_delta: float)->void:
	pass;

func physics_process(delta: float)->void:
	if _c_hop_count > 0:
		_c_hop_timer += delta;
		if _c_hop_timer >= hop_timer and body.is_on_floor():
			body.velocity += Vector2.UP * hop_size;
			_c_hop_timer = 0;
			_c_hop_count -= 1; 
	elif body.is_on_floor() and !_is_awaiting_spin_result:
		_spin_reels_and_await();
	body.velocity += body.get_gravity() * delta;
	body.move_and_slide();

func _spin_reels_and_await()->void:
	print('SPIN!');
	body.sprite_body.play("default");
	body.pitchfork.animation_player.play("spin_pitchfork");
	body.slots.spin_all_reels();
	_is_awaiting_spin_result = true;

func _on_slots_finish_spinning_handler(results: Array[ReelFace.Values])->void:
	print('Slot Spin Complete');
	body.pitchfork.animation_player.stop();
	for n in results:
		print(n);
	_reset_state_variables();

func _reset_state_variables()->void:
	_c_hop_count = hop_count;
	_c_hop_timer = 0.0;
	_is_awaiting_spin_result = false;
