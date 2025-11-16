class_name FollowPathCyclical;
extends Path2D;

# SETTINGS
@export var speed: float = 50;
@export var start_distance_ratio = 0.0;
@export var cycle_path = true;

# INTERNAL STATE
var is_in_return_cycle = false;

# LIFECYCLE
func _ready() -> void:
	$PathFollow2D.progress_ratio = start_distance_ratio;
	if cycle_path:
		#Turn off looping if cyclical, causes issues
		$PathFollow2D.loop = false; 

func _physics_process(delta: float) -> void:
	if cycle_path:
		if $PathFollow2D.progress_ratio >= 1:
			is_in_return_cycle = true;
		if $PathFollow2D.progress_ratio <= 0:
			is_in_return_cycle = false;
	if is_in_return_cycle:
		$PathFollow2D.progress += -speed * delta;	
	else:
		$PathFollow2D.progress += speed * delta;
