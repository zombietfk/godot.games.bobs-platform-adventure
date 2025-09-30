class_name MovementTrap;
extends Path2D;

@export var speed: float = 500;
var is_triggered = false;

func _on_trap_area_2d_entered(body: Node2D) -> void:
	is_triggered = true;

func _physics_process(delta: float) -> void:
	if is_triggered:
		$PathFollow2D.progress += speed * delta;
	
