extends Node2D

@export_file var inital_level_path: String;

func _init() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK);
	
func _ready() -> void:
	$CanvasLayer/Control/CenterContainer/VBoxContainer/Button.grab_focus();

func _begin_game() -> void:
	get_tree().change_scene_to_file("res://cutscenes/opening.tscn");
