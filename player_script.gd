extends CharacterBody2D

var movement_speed: int = 300;

func get_movement_direction() -> Vector2:
	var movement_direction: Vector2 = Vector2(0,0);
	if Input.is_action_pressed("ui_left"):
		movement_direction += Vector2(-1,0);
	if Input.is_action_pressed("ui_right"):
		movement_direction += Vector2(1,0);
	return movement_direction;

func _physics_process(delta: float) -> void:
	velocity = get_movement_direction() * movement_speed;
	move_and_slide();
