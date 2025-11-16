extends Node2D

@onready var enemy_spawn: Area2D = $EnemySpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.map = self
