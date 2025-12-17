class_name Imp;
extends AbstractEnemy;

enum FlipDirection { LEFT = 1, RIGHT = -1 }

@export var flip_direction: FlipDirection = FlipDirection.LEFT;

# LIFECYCLE
func _ready() -> void:
	scale.x = flip_direction;


func _physics_process(_delta: float) -> void:
	move_and_slide();
