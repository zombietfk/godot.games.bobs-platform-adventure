extends Path2D

# SETTINGS
@export var speed: float = 50;
@export var start_distance_ratio = 0.0;

# LIFECYCLE
func _ready() -> void:
	$PathFollow2D.progress_ratio = start_distance_ratio;

func _physics_process(delta: float) -> void:
	$PathFollow2D.progress += speed * delta;
