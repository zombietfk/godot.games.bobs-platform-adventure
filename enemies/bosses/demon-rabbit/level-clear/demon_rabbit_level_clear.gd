class_name DemonRabbitLevelClear;
extends CharacterBody2D;

@export var enable_colliders_after_x_seconds := 0.0;
var _c_enable_colliders_after_x_seconds_timer := 0.0;
var _collision_mask := 0;
var _jump_timer := 0.6;
var _c_jump_timer := 0.0;
var _jump_movement: Vector2 = Vector2(-400, -200);

func _ready()->void:
	_collision_mask = collision_mask;
	collision_mask = 0;

func _process(delta: float)->void:
	_c_enable_colliders_after_x_seconds_timer += delta;
	if _c_enable_colliders_after_x_seconds_timer > enable_colliders_after_x_seconds:
		collision_mask = _collision_mask;

func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		_turn_around();
	if _c_enable_colliders_after_x_seconds_timer > enable_colliders_after_x_seconds:
		if is_on_floor():
			velocity = Vector2.ZERO;
		_c_jump_timer += delta;
		if _c_jump_timer > _jump_timer:
			_c_jump_timer = 0;
			velocity += _jump_movement;
	velocity += get_gravity() * delta;
	move_and_slide();
	for n in get_slide_collision_count():
		var c = get_slide_collision(n);
		var body = c.get_collider();
		if body is Player:
			body.gib_and_kill();

func _turn_around() -> void:
	_jump_movement.x *= -1;
	velocity.x *= -1;
	scale.x *= -1;
