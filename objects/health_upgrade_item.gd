extends Sprite2D

@export var pickup_unique_name: String;

func _ready() -> void:
	if Main.instance.persistant_trigger_labels.has(pickup_unique_name):
		queue_free();
	
func _on_player_enter_area(body: Node2D) -> void:
	if body is Player:
		Main.instance.persistant_trigger_labels.push_back(pickup_unique_name);
		body.max_health += 1;
		body.current_health += 1;
		queue_free();
