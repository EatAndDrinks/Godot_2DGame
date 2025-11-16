extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu


func _on_pause_pressed() -> void:
	'''游戏暂停按钮'''
	Engine.time_scale = 0
	pause_menu.visible = true


func _on_return_game_pressed() -> void:
	'''游戏恢复按钮'''
	pause_menu.visible = false
	Engine.time_scale = 1


func _on_return_menu_pressed() -> void:
	'''返回主菜单'''
	LevelManager.current_level = 0
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scene/UI/MainMenu.tscn")
