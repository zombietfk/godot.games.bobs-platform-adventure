class_name Path2DCyclical;
extends Path2D;

# SETTINGS
@export var speed: float = 50;
@export var start_distance_ratio = 0.0;
@export var cycle_path = true;

# INTERNAL STATE
var paused = false;
var _is_in_return_cycle = false;

# SIGNALS
signal path_end();

# LIFECYCLE
func _ready() -> void:
	var children = get_children();
	# Rechild Nodes
	for c in children:
		if c != $PathFollow2D:
			$PathFollow2D.add_child(c);
	$PathFollow2D.progress_ratio = start_distance_ratio;
	if cycle_path:
		#Turn off looping if cyclical, causes issues
		$PathFollow2D.loop = false;

func _physics_process(delta: float) -> void:
	if paused:
		return;
	if cycle_path:
		if $PathFollow2D.progress_ratio >= 1:
			if _is_in_return_cycle == false:
				path_end.emit();
			_is_in_return_cycle = !_is_in_return_cycle;
		if $PathFollow2D.progress_ratio <= 0:
			if _is_in_return_cycle == true:
				path_end.emit();
			_is_in_return_cycle = !_is_in_return_cycle;
	if _is_in_return_cycle:
		$PathFollow2D.progress += -speed * delta;	
	else:
		$PathFollow2D.progress += speed * delta;
