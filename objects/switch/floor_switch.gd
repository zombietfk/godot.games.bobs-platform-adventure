class_name FloorSwitch;
extends AbstractSwitchArea;

func _on_switch_on():
	$AnimatedSprite2D.play("switch_flipped");
	
func _on_switch_off():
	$AnimatedSprite2D.play("default");
