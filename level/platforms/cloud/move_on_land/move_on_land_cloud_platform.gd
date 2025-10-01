class_name MoveOnLandCloudPlatform;
extends Path2D;

# SETTINGS
@export var speed: float = 500;

# INTERNAL STATE
var previous_position: Vector2;

# FLAGS
var is_triggered = false;

# TRIGGERS
func _on_cloud_platform_player_landed(platform: CloudPlatform) -> void:
	is_triggered = true;

# LIFECYCLE
func _ready() -> void:
	previous_position = global_position;

func _physics_process(delta: float) -> void:
	previous_position = global_position;
	if is_triggered:
		$PathFollow2D.progress += speed * delta;
