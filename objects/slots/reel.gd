class_name Reel;
extends Node2D;

@onready var slot_face_1 : ReelFace = $Face1;
@onready var slot_face_2 : ReelFace = $Face2;
@onready var slot_face_3 : ReelFace = $Face3;

var is_spinning = false;

func stop()->void:
	slot_face_1.stop();
	slot_face_2.stop();
	await slot_face_3.stop();
	is_spinning = false;

func spin(speed_min: float, speed_max: float)->void:
	_set_faces_animation_speed(speed_min, speed_max);
	slot_face_1.spin();
	slot_face_2.spin();
	slot_face_3.spin();
	is_spinning = true;

func _set_faces_animation_speed(speed_min: float, speed_max: float)->void:
	var speed_roll := randf_range(speed_min, speed_max);
	slot_face_1.animation_player.speed_scale = speed_roll;
	slot_face_2.animation_player.speed_scale = speed_roll;
	slot_face_3.animation_player.speed_scale = speed_roll;

func hold_reel()->void:
	if is_spinning:
		stop();
