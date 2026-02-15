class_name Slot;
extends Node2D

@onready var reel_1 : Reel = $Reel;
@onready var reel_2 : Reel = $Reel2;
@onready var reel_3 : Reel = $Reel3;
var _is_spinning = false;
var _spin_cooldown_period := 1.0;
var spin_duration := 3.0;

signal stopped_spinning(reel_values: Array[ReelFace.Values]);

func _ready()->void:
	stop_all_reels();

func stop_all_reels()->void:
	await reel_1.stop();
	await reel_2.stop();
	await reel_3.stop();
	await get_tree().create_timer(_spin_cooldown_period).timeout;
	print('SPIN COMPLETE')
	stopped_spinning.emit([
		reel_1.slot_face_2.face_value,
		reel_2.slot_face_2.face_value,
		reel_3.slot_face_2.face_value,
	] as Array[ReelFace.Values]);
	_is_spinning = false;

func spin_all_reels(spin_duration: float = 3.0)->void:
	if _is_spinning:
		return;
	reel_1.spin();
	reel_2.spin();
	reel_3.spin();
	_is_spinning = true;
	await get_tree().create_timer(spin_duration).timeout;
	stop_all_reels();
