class_name CreateBoulderOnTimeoutFactory;
extends CreateBoulderAbstractFactory;

@export var fire_on_ready = false;
@export var fires_every_x_timer = 3.0;
var _c_fires_every_x_timer = 0;

func _ready() -> void:
	if fire_on_ready:
		_c_fires_every_x_timer = fires_every_x_timer;

func _process(delta: float) -> void:
	_c_fires_every_x_timer += delta;
	if _c_fires_every_x_timer > fires_every_x_timer:
		_c_fires_every_x_timer = 0;
		_create();
