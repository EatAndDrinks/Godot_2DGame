extends Resource
class_name LevelData

@export var enemy : PackedScene
@export var enemy_count : int
@export var tick : float		#刷怪间隔
@export var once_count : int 	#一次刷怪数量

var current_count = 0 			#计数已经刷怪个数

func create_enemy():
	for i in once_count:
		if current_count >= enemy_count:
			'''如果计数器大于刷怪数则不刷怪'''
			LevelManager.stop()
			return
		var instance = enemy.instantiate()
		instance.global_position = get_radom_position()
		print(get_radom_position())
		GameManager.map.add_child(instance)
		current_count += 1

func get_radom_position():
	var enemy_spawn = GameManager.map.enemy_spawn as Area2D
	var coll = enemy_spawn.get_node("CollisionShape2D") as CollisionShape2D
	var rect = coll.shape.get_rect()
	var point = Vector2(randf_range(-rect.size.x , rect.size.x) , randf_range(-rect.size.y , rect.size.y))
	return rect.position + point
