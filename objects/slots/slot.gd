class_name Slot;
extends Node2D;

@onready var slot_face_1 : SlotFace = $Face1;
@onready var slot_face_2 : SlotFace = $Face2;
@onready var slot_face_3 : SlotFace = $Face3;

func hold_real()->void:
	slot_face_1.stop();
	slot_face_2.stop();
	slot_face_3.stop();

func _ready()->void:
	pass;
	#await get_tree().create_timer(3).timeout;
	#stop_all_slot_faces();
	#print(slot_face_2.face_value);
