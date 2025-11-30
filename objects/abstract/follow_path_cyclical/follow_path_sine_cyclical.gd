class_name Path2DSineCyclical;
extends Path2D;

# SETTINGS
@export var speed: float = 50;
@export_range(0,2) var start_distance_ratio = 0.0;

# INTERNAL STATE
var is_in_return_cycle = false;
var aggregate_time = 0;

func _ready() -> void:
	$PathFollow2D.loop = false; 
	var children = get_children();
	for c in children:
		if c != $PathFollow2D:
			$PathFollow2D.add_child(c);
	aggregate_time = start_distance_ratio;
	$PathFollow2D.progress_ratio = abs(sin(aggregate_time));
		
func _physics_process(delta: float) -> void:
	aggregate_time += delta * speed;
	$PathFollow2D.progress_ratio = abs(sin(aggregate_time));
