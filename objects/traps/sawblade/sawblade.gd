class_name Sawblade
extends Area2D

@export var travel_speed = 0;
@export var travel_direction = Vector2.LEFT;
@export var autodestroy = false;
@export var autodestroy_after_x_seconds_timer = 0;

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('gib_and_kill'):
		body.gib_and_kill();

func _physics_process(delta: float) -> void:
	position += travel_direction * travel_speed * delta;

func _process(delta: float) -> void:
	if autodestroy:
		autodestroy_after_x_seconds_timer -= delta;
		if autodestroy_after_x_seconds_timer <= 0:
			queue_free();
		
