class_name Reel;
extends Node2D;

@onready var slot_face_1 : ReelFace = $Face1;
@onready var slot_face_2 : ReelFace = $Face2;
@onready var slot_face_3 : ReelFace = $Face3;

var _is_held = false;
var _is_spinning = false;

var min_base_animation_speed: float = 0.8;
var max_base_animation_speed: float = 1.6;

func stop()->void:
	slot_face_1.stop();
	slot_face_2.stop();
	await slot_face_3.stop();
	_is_spinning = false;

func spin()->void:
	if !_is_held:
		_set_faces_animation_speed();
		slot_face_1.spin();
		slot_face_2.spin();
		slot_face_3.spin();
		_is_spinning = true;
	_is_held = false;

func _set_faces_animation_speed()->void:
	var speed_roll := randf_range(min_base_animation_speed, max_base_animation_speed);
	slot_face_1.animation_player.speed_scale = speed_roll;
	slot_face_2.animation_player.speed_scale = speed_roll;
	slot_face_3.animation_player.speed_scale = speed_roll;

func hold_reel()->void:
	if !_is_spinning:
		_is_held = true;
