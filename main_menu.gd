class_name MainMenu;
extends Node2D

func _init() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK);
	
func _ready() -> void:
	$CanvasLayer/ContainerControl/Main/CenterContainer/VBoxContainer/StartButton.grab_focus();
	Main.inital_level_path_static = "";
	Player.use_bobette_as_player = false;
	if DisplayServer.has_feature(DisplayServer.FEATURE_TOUCHSCREEN) and _is_mobile_browser():
		Main.mobile_compatabilty_mode = true;
		$CanvasLayer/ContainerControl/Main/CenterContainer/VBoxContainer/MobileCompatability/UseMobileCompatCheckbox.button_pressed = true;

func _begin_game() -> void:
	get_tree().change_scene_to_file("res://cutscenes/opening.tscn");

func _show_checkpoints_ui_menu()->void:
	$CanvasLayer/ContainerControl/Main.visible = false;
	$CanvasLayer/ContainerControl/Checkpoints.visible = true;
	
func _show_main_ui_menu()->void:
	$CanvasLayer/ContainerControl/Main.visible = true;
	$CanvasLayer/ContainerControl/Checkpoints.visible = false;

func _show_bobette_option_if_unlocked()->void:
	if CheckpointSaveManager.is_bobette_unlocked():
		$CanvasLayer/ContainerControl/Main/CenterContainer/VBoxContainer/PlayAsBobette.visible = true;
	else:
		$CanvasLayer/ContainerControl/Main/CenterContainer/VBoxContainer/PlayAsBobette.visible = false;
		Player.use_bobette_as_player = false;
		
func _shader_loaded()->void:
	$CanvasLayer/ContainerControl/LoadingScreen.visible = false;

func _is_mobile_browser() -> bool:
	if !OS.has_feature("web"):
		return false;
	var user_agent = JavaScriptBridge.eval("navigator.userAgent");
	return (
		"Android" in user_agent
		or "iPhone" in user_agent
		or "iPad" in user_agent
		or "iPod" in user_agent
	);
	
