extends Node

var player : Player


func damage(attacker : Node2D , target : Node2D):
	'''伤害模块'''
	target.current_hp -= attacker.damage
	
