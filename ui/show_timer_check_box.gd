extends CheckBox

func _ready()->void:
	button_pressed = Main.show_clock;

func _toggle_timer()->void:
	Main.show_clock = !Main.show_clock; 
