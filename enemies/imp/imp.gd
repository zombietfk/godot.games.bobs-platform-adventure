class_name Imp;
extends CharacterBody2D;

# SETTINGS
@export var movement_speed: int = -25;
@export var knockpack_impetus = Vector2(500, 500);

# LIFECYCLE
func _ready() -> void:
	velocity = Vector2(movement_speed, 0);

func _physics_process(delta: float) -> void:
	velocity = Vector2(movement_speed, velocity.y);
	velocity += get_gravity() * delta;
	move_and_slide();
	if !$FloorCheckRayCast2D.is_colliding():
		turn_around();
	if $WallCheckRayCast2D.is_colliding():
		turn_around();

func _process_attacks() -> void:
	for collision in $ShapeCast2D.collision_result:
		var body = instance_from_id(collision["collider_id"]);
		if body is Player:
			body.damage(
				1,
				collision.normal,
				knockpack_impetus
			);
			
func _process(_delta: float) -> void:
	_process_attacks();
	
# METHODS
func turn_around() -> void:
	scale = Vector2(-scale.x, scale.y)
	movement_speed = -movement_speed;

func gib_and_kill(gibs: int = 5) -> void:
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	queue_free();
