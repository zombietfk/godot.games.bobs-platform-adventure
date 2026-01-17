class_name StateTwoBearState;
extends AbstractBearState;

@export var middle_stage_marker: Marker2D;
@export var time: float = 2.0;
@export var cloud_platform: CloudPlatform;
var _move_speed = 75;
var _min_distance_to_marker = 8;
var _jump_strength = -2500;

func enter(_from: AbstractState)->void:
	cloud_platform.enable();
	animated_sprite.animation = "running";

func exit(_to: AbstractState)->void:
	pass;

func process(_delta: float)->void:
	pass;
	
func physics_process(delta: float)->void:
	#print(bear.velocity);
	var x_distance_to_marker = middle_stage_marker.global_position.x - bear.global_position.x;
	if abs(x_distance_to_marker) > _min_distance_to_marker:
		animated_sprite.animation = "running";
		NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(bear, sign(x_distance_to_marker));
		var direction = sign(x_distance_to_marker);
		bear.velocity = direction * _move_speed * Vector2.RIGHT;
	else:
		bear.velocity.x = 0;
		bear.global_position.x = middle_stage_marker.global_position.x;
		animated_sprite.animation = "forward";
		if bear.is_on_floor():
			print(bear.velocity);
			bear.velocity.y = -500;
			print('Bear Jump');
			_summon_beehive();
	bear.velocity += bear.get_gravity() * delta;

func _summon_beehive()->void:
	print('Summon Beehive')
	pass;
