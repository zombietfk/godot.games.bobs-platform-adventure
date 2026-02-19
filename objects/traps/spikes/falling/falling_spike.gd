class_name FallingSpike;
extends Node2D;

@onready var player_below_check_raycast: RayCast2D = $RayCast2D;
@onready var spike_body: Spike = $Spike;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@export var fall_speed: float = 200;
@export var fall_after_timer: float = 0.4;
@export var respawns = true;
@export var respawn_after_timer: float = 2;
@export var ignore_raycast_check := false;

var _inital_position: Vector2;
var _current_state: SpikeState = SpikeState.IDLE;

enum SpikeState { IDLE, TRIGGERED, FALLING, RESPAWNING };

func _ready()->void:
	_inital_position = spike_body.global_position;

func _process(_delta: float) -> void:
	if _current_state == SpikeState.IDLE:
		var collision = player_below_check_raycast.get_collider();
		if collision is Player or ignore_raycast_check:
			_current_state = SpikeState.TRIGGERED;
			animation_player.play("spike_shake");
			await get_tree().create_timer(fall_after_timer).timeout;
			animation_player.play("RESET");
			_current_state = SpikeState.FALLING;
			if respawns:
				await get_tree().create_timer(respawn_after_timer).timeout;
				_current_state = SpikeState.RESPAWNING;
				spike_body.visible = false;
				animation_player.play("respawn");
				await get_tree().process_frame;
				spike_body.visible = true;
				await animation_player.animation_finished;
				_current_state = SpikeState.IDLE;

func _physics_process(delta: float) -> void:
	if _current_state == SpikeState.FALLING:
		spike_body.position += -fall_speed * delta * Vector2.DOWN;
