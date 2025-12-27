class_name Boulder
extends CharacterBody2D

@export var travel_speed = 0;
@export var travel_direction = Vector2.LEFT;
@export var autodestroy = true;
@export var autodestroy_after_x_seconds_timer = 3.0;
@export var use_gravity = true;
@export var gravity_factor = 0.3;
@export var max_speed = 400;

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('gib_and_kill'):
		body.gib_and_kill();

func _ready()->void:
	velocity = travel_direction.normalized() * travel_speed;

func _physics_process(delta: float) -> void:
	if use_gravity:
		velocity += get_gravity() * delta * gravity_factor;
	velocity = clamp(velocity, -Vector2.ONE * max_speed, Vector2.ONE * max_speed);
	move_and_slide();

func _process(delta: float) -> void:
	if autodestroy:
		autodestroy_after_x_seconds_timer -= delta;
		if autodestroy_after_x_seconds_timer <= 0:
			queue_free();
		
