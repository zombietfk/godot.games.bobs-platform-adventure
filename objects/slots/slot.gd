class_name Slot;
extends Node2D

@onready var reel_1 : Reel = $Reel;
@onready var reel_2 : Reel = $Reel2;
@onready var reel_3 : Reel = $Reel3;
var is_spinning = false;
var _spin_cooldown_period := 1.0;

signal stopped_spinning(reel_values: Array[ReelFace.Values]);

func _ready()->void:
	stop_all_reels();

func stop_all_reels()->void:
	await reel_1.stop();
	await reel_2.stop();
	await reel_3.stop();
	await get_tree().create_timer(_spin_cooldown_period).timeout;

func _await_all_reels_stopped()->void:
	while reel_1.is_spinning or reel_2.is_spinning or reel_3.is_spinning:
		await get_tree().process_frame;
	stopped_spinning.emit([
		reel_1.slot_face_2.face_value,
		reel_2.slot_face_2.face_value,
		reel_3.slot_face_2.face_value,
	] as Array[ReelFace.Values]);
	is_spinning = false;

func spin_all_reels(speed_min: float, speed_max: float)->void:
	if is_spinning:
		return;
	reel_1.spin(speed_min, speed_max);
	reel_2.spin(speed_min, speed_max);
	reel_3.spin(speed_min, speed_max);
	is_spinning = true;
	_await_all_reels_stopped();
