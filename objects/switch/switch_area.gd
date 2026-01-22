class_name SwitchArea;
extends AbstractSwitchArea;

@onready var collision_shape = $CollisionShape2D;

func _ready()->void:
	if !body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered);
	if !body_exited.is_connected(_on_body_exited):
		body_entered.connect(_on_body_entered);

func _on_switch_on():
	pass;

func _on_switch_off():
	pass;
