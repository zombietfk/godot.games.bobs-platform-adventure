class_name MushroomMan;
extends AbstractEnemy;

@export var chase_speed: float = 200;
@export var chase_time: float = 3;
@export var knockback_strength: Vector2 = Vector2.ONE * 400;
@onready var idle_sprite: AnimatedSprite2D = $IdleAnimatedSprite2D;
@onready var awaken_sprite: AnimatedSprite2D = $AwakenAnimatedSprite2D;
@onready var running_sprite: AnimatedSprite2D = $RunningAnimatedSprite2D;
@onready var awaken_area_2d: Area2D = $AwakenArea2D;
@onready var attack_area_2d: Area2D = $AttackArea2D;

enum State { IDLE, AWAKENING, AWAKENED, SLEEPING }

var _state = State.IDLE;
var _player_body: Player;
var _is_already_awakening = false;

func _process(_delta: float) -> void:
	match _state:
		State.IDLE:
			if _is_already_awakening:
				return;
			for body in awaken_area_2d.get_overlapping_bodies():
				if body is Player:
					awaken_area_2d.monitoring = false;
					_state = State.AWAKENING;
					idle_sprite.visible = false;
					awaken_sprite.visible = true;
					awaken_sprite.play();
					_player_body = body;
					_awaken_after_awakening_animation();
		State.AWAKENING:
			velocity = Vector2.ZERO
		State.AWAKENED:
			var mushman_to_player_vec2 = (_player_body.global_position - global_position);
			var direction = sign(mushman_to_player_vec2.x);
			velocity = Vector2.RIGHT * direction * chase_speed;
			NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(
				self,
				direction
			)
		State.SLEEPING:
			velocity = Vector2.ZERO
				
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta;
	move_and_slide();
	
func _awaken_after_awakening_animation()->void:
	_is_already_awakening = true;
	await awaken_sprite.animation_finished;
	_state = State.AWAKENED;
	awaken_sprite.visible = false;
	running_sprite.visible = true;
	_is_already_awakening = false;
	_chase_for_x_seconds_then_go_idle(chase_time);

func _chase_for_x_seconds_then_go_idle(x: float)->void:
	attack_area_2d.monitoring = true;
	await get_tree().create_timer(x).timeout;
	attack_area_2d.monitoring = false;
	running_sprite.visible = false;
	awaken_sprite.visible = true;
	_state = State.SLEEPING;
	awaken_sprite.play_backwards();
	await awaken_sprite.animation_finished;
	awaken_area_2d.monitoring = true;
	awaken_sprite.visible = false;
	idle_sprite.visible = true;
	_state = State.IDLE;

func _on_attack_area_enter(body: Node2D)->void:
	if body is Player:
		body.damage(
			1,
			global_position - body.global_position,
			knockback_strength
		);
