extends Node

var enemies = []		#怪物数量数组
var current_level_data : LevelData
var timer = Timer.new()

signal on_enemy_death

func _ready() -> void:
	timer.one_shot = false
	timer.timeout.connect(time_out)
	add_child(timer)
	LevelManager.on_level_change.connect(on_level_change)

	
func on_level_change(level_data : LevelData):
	current_level_data = level_data
	timer.start(level_data.tick)
	
func time_out():
	if current_level_data:
		current_level_data.create_enemy()
	
func check_enemy():
	if enemies.size() == 0:
		LevelManager.next_level()
