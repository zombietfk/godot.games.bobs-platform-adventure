class_name DemonBunny;
extends AbstractEnemy;

@export var slots : Slot;
@onready var pitchfork : DemonBunnyPitchfork = $Pitchfork;
@onready var pitchfork_origin_marker: Marker2D = $PitchforkOriginMarker;
@onready var sprite_body: AnimatedSprite2D = $Body;
@export var enterance_sound: AudioStreamPlayer;

var health = 3;

signal on_damage();

func _ready()->void:
	enterance_sound.play();

func take_damage()->void:
	health -= 1;
	if health == 0:
		on_death.emit();
	else:
		on_damage.emit();

func gib_and_kill() -> void:
	var original_scale = scale;
	for i in 100:
		Gib.spawn(global_position, Vector2(sin((i * 4) / 50.0), -1));
		scale = lerp(original_scale, Vector2.ZERO, i / 100.0);
		await get_tree().create_timer(0.05, false).timeout;
	super.gib_and_kill();
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gib_and_kill();
