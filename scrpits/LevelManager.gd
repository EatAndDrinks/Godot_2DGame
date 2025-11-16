extends Node

const level_path = "res://resource/level/"

var level_data : Array[LevelData]	#存放关卡数据
var current_level = 0

signal on_level_change(level_data :LevelData)

func _ready() -> void:
	'''指定件路径，并且将level数据存放到level_data'''
	var files = DirAccess.get_files_at(level_path)
	for file_name in files:
		level_data.append(load(level_path + file_name)) 
	
func next_level():
	'''切换关卡信号'''
	current_level += 1
	print("切换关卡")
	on_level_change.emit(level_data[current_level - 1])
	
func stop():
	EnemyManager.timer.stop()
