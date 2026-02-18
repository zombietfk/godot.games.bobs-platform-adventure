class_name Reel;
extends Node2D;

@onready var slot_face_1 : ReelFace = $Face1;
@onready var slot_face_2 : ReelFace = $Face2;
@onready var slot_face_3 : ReelFace = $Face3;

var is_spinning = false;

var min_base_animation_speed: float = 0.8;
var max_base_animation_speed: float = 1.6;

func stop()->void:
	slot_face_1.stop();
	slot_face_2.stop();
	await slot_face_3.stop();
	is_spinning = false;

func spin()->void:
	_set_faces_animation_speed();
	slot_face_1.spin();
	slot_face_2.spin();
	slot_face_3.spin();
	is_spinning = true;

func _set_faces_animation_speed()->void:
	var speed_roll := randf_range(min_base_animation_speed, max_base_animation_speed);
	slot_face_1.animation_player.speed_scale = speed_roll;
	slot_face_2.animation_player.speed_scale = speed_roll;
	slot_face_3.animation_player.speed_scale = speed_roll;

func hold_reel()->void:
	if is_spinning:
		stop();
