extends Node2D

@export_file var inital_level_path: String;

func _init() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK);
	
func _ready() -> void:
	$CanvasLayer/ContainerControl/Main/CenterContainer/VBoxContainer/StartButton.grab_focus();

func _begin_game() -> void:
	get_tree().change_scene_to_file("res://cutscenes/opening.tscn");

func _show_checkpoints_ui_menu()->void:
	$CanvasLayer/ContainerControl/Main.visible = false;
	$CanvasLayer/ContainerControl/Checkpoints.visible = true;
	
func _show_main_ui_menu()->void:
	$CanvasLayer/ContainerControl/Main.visible = true;
	$CanvasLayer/ContainerControl/Checkpoints.visible = false;
