class_name CreateBoulderOnSwitchPress;
extends CreateBoulderAbstractFactory;

func _fire_boulder_on_swtich_press(_by: Node2D):
	call_deferred("_create");
