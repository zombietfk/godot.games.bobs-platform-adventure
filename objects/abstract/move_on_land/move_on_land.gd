class_name MoveOnLandTrap;
extends Path2D;

# SETTINGS
@export var speed: float = 500;

# FLAGS
var is_triggered = false;

# TRIGGERS
func _on_trigger() -> void:
	is_triggered = true;

# LIFECYCLE
func _physics_process(delta: float) -> void:
	if is_triggered:
		$PathFollow2D.progress += speed * delta;
