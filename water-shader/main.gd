extends Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if OS.is_debug_build():
		DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		if event.keycode == KEY_X and event.pressed:
			get_tree().quit()
			
		if event.keycode == KEY_F and event.pressed:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
