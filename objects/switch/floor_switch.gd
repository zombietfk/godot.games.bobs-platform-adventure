class_name FloorSwitch;
extends AbstractSwitchArea;

@onready var switch_sound: AudioStreamPlayer = $AudioStreamPlayer;

func _on_switch_on():
	switch_sound.play();
	$AnimatedSprite2D.play("switch_flipped");
	
func _on_switch_off():
	switch_sound.play();
	$AnimatedSprite2D.play("default");
