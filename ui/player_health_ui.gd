class_name PlayerHealthUI;
extends HBoxContainer;

@export var ui_heart_container_scene: PackedScene;
var hearts: Array[UIHeartContainer] = [];

func update_health_bar(current_health: int, max_health: int) -> void:
	if hearts.size() != max_health:
		for heart in hearts:
			heart.queue_free();
		for n in max_health:
			var new_heart_container: UIHeartContainer = ui_heart_container_scene.instantiate();
			add_child(new_heart_container)
			hearts.append(new_heart_container);
	for n in hearts.size():
		if current_health - 1 >= n:
			hearts[n].heart_image.show();
		else:
			hearts[n].heart_image.hide();
