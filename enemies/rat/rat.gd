class_name Rat;
extends CharacterBody2D;

@export var move_speed: float = 100.0;
@export var is_idle: bool = true;
@export var idle_every_x_seconds_timer: float = 2.0;
var c_idle_every_x_seconds_timer: float = 0.0;
@export var idle_timer: float = 1.0;
var c_idle_timer: float = 0.0;
@export var wallcheck_raycast: RayCast2D;
@export var floorcheck_raycast: RayCast2D;
@export var idle_sprite_anim: AnimatedSprite2D;
@export var walking_sprite_anim: AnimatedSprite2D;
@export var attack_check_shape_cast: ShapeCast2D;

func _process(delta:float) -> void:
	if is_idle:
		velocity.x = 0;
		if c_idle_timer > idle_timer:
			c_idle_timer = 0;
			is_idle = false;
			idle_sprite_anim.visible = false;
			walking_sprite_anim.visible = true;
		else:
			c_idle_timer += delta;
	else:
		velocity.x = -move_speed;
		if c_idle_every_x_seconds_timer > idle_every_x_seconds_timer:
			c_idle_every_x_seconds_timer = 0;
			is_idle = true;
			idle_sprite_anim.visible = true;
			walking_sprite_anim.visible = false;
		else:
			c_idle_every_x_seconds_timer += delta;
	if wallcheck_raycast.is_colliding():
		_flip_direction();
	elif !floorcheck_raycast.is_colliding():
		_flip_direction();
	
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta;
	move_and_slide()
	for n in attack_check_shape_cast.get_collision_count():
		var collider = attack_check_shape_cast.get_collider(n);
		if collider is Player:
			collider.damage(
				1,
				attack_check_shape_cast.get_collision_normal(n),
				Vector2(1000, 600),
				0.3
			);

func _flip_direction()->void:
	move_speed = -move_speed;
	scale.x = -scale.x;
