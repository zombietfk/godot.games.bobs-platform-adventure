class_name StageThreeBearState;
extends AbstractRunningAroundBearState;

@export var beehived_move_speed: float = 450.0;
@export var rage_duration = 10;
@export var cloud_platform: CloudPlatform;
var _c_rage_duration = 0;

func _ready()->void:
	_max_running_impetus = Vector2(200, 0);

func enter(from: AbstractState)->void:
	super.enter(from);
	bear.on_hit_by_beehive.connect(_hit_by_beehive);

func exit(to: AbstractState)->void:
	super.exit(to);
	bear.on_hit_by_beehive.disconnect(_hit_by_beehive);

func process(delta: float)->void:
	if !bear.is_beehived:
		super.process(delta);
	elif bear.is_beehived:
		_c_rage_duration += delta;
		if _c_rage_duration > rage_duration:
			_c_rage_duration = 0;
			bear.is_beehived = false;
			transition.emit("Stage1State");
		if wallcheck_raycast.is_colliding() and _is_running:
			_change_direction();

func physics_process(delta: float)->void:
	if !bear.is_beehived:
		super.physics_process(delta);
	else:
		bear.velocity = _direction * beehived_move_speed * Vector2.RIGHT;

func _hit_by_beehive()->void:
	cloud_platform.disable();
	bear.is_beehived = true;
	animated_sprite.animation = "beehived";
