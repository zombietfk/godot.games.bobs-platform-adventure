class_name Imp;
extends CharacterBody2D;

# SETTINGS
@export var movement_speed: int = -25;
@export var knockpack_impetus = Vector2(1000, 2000);

# LIFECYCLE
func _ready() -> void:
	velocity = Vector2(movement_speed, 0);

func _physics_process(delta: float) -> void:
	velocity += get_gravity();
	move_and_slide();
	if !$RayCast2D.is_colliding() or is_on_wall():
		turn_around();

func _process_attacks() -> void:
	for collision in $ShapeCast2D.collision_result:
		var body = instance_from_id(collision["collider_id"]);
		if body is Player:
			body.damage(
				1,
				$ShapeCast2D.global_position - body.global_position,
				knockpack_impetus
			);
			
func _process(delta: float) -> void:
	_process_attacks();
	
# METHODS
func turn_around() -> void:
	scale = Vector2(-scale.x, scale.y)
	velocity = -velocity;
