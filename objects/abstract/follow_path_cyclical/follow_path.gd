class_name Path2DLinear;
extends Path2D;

# SETTINGS
@export var speed: float = 50;

# LIFECYCLE
func _physics_process(delta: float) -> void:
	$PathFollow2D.progress += speed * delta;
