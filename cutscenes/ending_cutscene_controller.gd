extends Node2D

const ENDING_LABELS = [
	"\"bobette!\" yelled bob! \"I've found you!\"",
	"\"oh bob, where have you been?!\" said bobette",
	"\"this guy narrating what we're dong pushed me down a hole!\"",
	"\"huh? what are you talking about bob?\" asked bobette",
	"\"you know! the voice! the voice in my head!\" bob exlaimed",
	"\"oh bob... not again...\" bobette muttered with a look of conern",
	"...",
	"\"okay bob, anyway, it's time to come home now, do you want to come home?\"",
	"\"yes please! I love you bobette!\"",
	"\"I love you too bob, I love you too\" bobette began to tear up slightly",
	"...",
	"and so they left the hole bob had fell into",
	"...",
	"...",
	"but it seems as though bob still has a lot of demons to face",
	"and lots more big adventures to have!",
	"...",
	"(bobette unlocked!)",
];

const ENDING_PLAY_NEXT_CLIP_AFTER_LABEL_INDEX = [
	0,
	8,
	11,
	17,
];

var _c_clip_index = 0;
var _c_label_index = 0;
var _freeze_input := false;
@export var cutscene_typewriter: TypewriterLabel;
@export var animation_player: AnimationPlayer;
@onready var music: AudioStreamPlayer = $AudioStreamPlayer;

func _init()->void:
	RenderingServer.set_default_clear_color(Color.WHITE);

func _ready()->void:
	music.seek(2.0);
	animation_player.play("RESET");
	cutscene_typewriter.finished_writing.connect(_wait_for_input_then_play_next);
	
func _wait_for_input_then_play_next():
	if _freeze_input:
		return;
	while !Input.is_action_pressed("jump"):
		await get_tree().process_frame;
	if _c_clip_index < ENDING_PLAY_NEXT_CLIP_AFTER_LABEL_INDEX.size():
		if _c_label_index == ENDING_PLAY_NEXT_CLIP_AFTER_LABEL_INDEX[_c_clip_index]:
			_c_clip_index += 1;
			animation_player.play("clip_" + str(_c_clip_index))
	_c_label_index += 1;
	if _c_label_index > ENDING_LABELS.size() - 1:
		_freeze_input = true;
		await animation_player.animation_finished;
		get_tree().change_scene_to_file("res://main_menu.tscn");
		return;
	cutscene_typewriter.update_text(ENDING_LABELS[_c_label_index]);
