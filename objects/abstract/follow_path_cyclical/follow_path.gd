class_name Path2DLinear;
extends Path2D;

# SETTINGS
@export var speed: float = 50;
@export var start_ratio := 0.0;

# LIFECYCLE
func _ready() -> void:
	$PathFollow2D.progress_ratio = start_ratio;

func _physics_process(delta: float) -> void:
	$PathFollow2D.progress += speed * delta;
