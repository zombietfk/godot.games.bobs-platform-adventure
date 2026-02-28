extends Node2D

const OPENING_LABELS = [
	"one sunny day, bob was at home relaxing",
	"\"wow, what a beautiful day!\" said bob \"i'm going to go for a stroll!\"",
	"And so bob went for a walk!",
	"The sun was shining, birds were singing, everything was perfect!",
	"...",
	"just like every day!",
	"...",
	"okay, actually it was a little boring, there's not much outside",
	"anyway, bob was starting to get really hot",
	"so bob decided to go rest in some shade under a tree",
	"and that's when bob found something strange...",
	"\"wow, look at this!\" said bob",
	"He bent down to take a deeper look",
	"\"i've never seen a hole like this before! it's so...\"",
	"...",
	"\"dark!\"",
	"sure bob, why not, it's a really cool hole",
	"...",
	"...",
	"uh...",
	"*shove*",
	"\"wait, how did you...!?\"",
	"Oh no! bob tripped and fell down the hole!",
	"And so begins...",
	"bob's big adventure!",
];

const OPENING_PLAY_NEXT_CLIP_AFTER_LABEL_INDEX = [
	0,
	1,
	2,
	8,
	10,
	12,
	19,
];

var _c_clip_index = 0;
var _c_label_index = 0;
@export var cutscene_typewriter: TypewriterLabel;
@export var animation_player: AnimationPlayer;
@onready var music: AudioStreamPlayer = $AudioStreamPlayer;

func _init()->void:
	RenderingServer.set_default_clear_color(Color.WHITE);

func _ready()->void:
	music.seek(2.0);
	animation_player.play("RESET");
	cutscene_typewriter.finished_writing.connect(_wait_for_input_then_play_next);

func _input(event)->void:
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("jump"); 
		else:
			Input.action_release("jump");

func _wait_for_input_then_play_next():
	while !Input.is_action_pressed("jump"):
		await get_tree().process_frame;
	if _c_clip_index < OPENING_PLAY_NEXT_CLIP_AFTER_LABEL_INDEX.size():
		if _c_label_index == OPENING_PLAY_NEXT_CLIP_AFTER_LABEL_INDEX[_c_clip_index]:
			_c_clip_index += 1;
			animation_player.play("clip_" + str(_c_clip_index))
	_c_label_index += 1;
	if _c_label_index > OPENING_LABELS.size() - 1:
		get_tree().change_scene_to_file("res://main.tscn");
		return;
	cutscene_typewriter.update_text(OPENING_LABELS[_c_label_index]);
