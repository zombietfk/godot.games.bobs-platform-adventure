class_name Imp;
extends AbstractEnemy;

# LIFECYCLE
func _ready() -> void:
	pass;

func _physics_process(_delta: float) -> void:
	move_and_slide();
