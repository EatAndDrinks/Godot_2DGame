extends Node

var player : Player		#存放玩家数据
var map : Node2D		#场景数据


func damage(attacker : Node2D , target : Node2D):
	'''伤害模块'''
	target.current_hp -= attacker.damage
	
