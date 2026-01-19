class_name StageThreeBearState;
extends AbstractRunningAroundBearState;

@export var beehived_move_speed: float = 550.0;
@export var rage_duration = 10;
@export var cloud_platform: CloudPlatform;
var _c_rage_duration = 0;
var _is_dying = false;

func _ready()->void:
	_max_running_impetus = Vector2(200, 0);

func enter(from: AbstractState)->void:
	super.enter(from);
	bear.on_hit_by_beehive.connect(_hit_by_beehive);

func exit(to: AbstractState)->void:
	super.exit(to);
	bear.on_hit_by_beehive.disconnect(_hit_by_beehive);

func process(delta: float)->void:
	if _is_dying:
		return;
	if bear.is_beehived:
		_c_rage_duration += delta;
		if _c_rage_duration > rage_duration:
			_c_rage_duration = 0;
			bear.is_beehived = false;
			bear.lives -= 1;
			if bear.lives <= 0:
				bear.velocity = Vector2.ZERO;
				bear.gib_and_kill();
				_is_dying = true;
				animated_sprite.animation = "forward";
			else:
				transition.emit("Stage1State");
		if wallcheck_raycast.is_colliding() and _is_running:
			_change_direction();
	else:
		super.process(delta);

func physics_process(delta: float)->void:
	if _is_dying:
		return;
	if !bear.is_beehived:
		super.physics_process(delta);
	else:
		bear.velocity = _direction * beehived_move_speed * Vector2.RIGHT + bear.get_gravity();

func _hit_by_beehive()->void:
	cloud_platform.disable();
	bear.is_beehived = true;
	_interrupt_wait_then_run = true;
	animated_sprite.animation = "beehived";
