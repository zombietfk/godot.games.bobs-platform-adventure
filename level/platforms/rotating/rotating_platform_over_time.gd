class_name RotatingPlatformOverTime;
extends Node2D

@export var speed = 1.0;

func _physics_process(delta: float) -> void:
	rotation_degrees += speed * delta;
