class_name OneShotArea;
extends Area2D;

func _disable_area_after_enter() -> void:
	set_deferred("monitoring", false);
