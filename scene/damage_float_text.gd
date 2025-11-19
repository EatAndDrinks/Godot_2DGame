extends Node2D

@onready var label: Label = $Label 

var position_tween : Tween	#控制位置的Tween动画
var scale_tween : Tween		#控制大小的Tween动画

var damaged 

func _ready() -> void:
	scale = Vector2.ZERO	#大小归零
	display_damage_text(damaged)
	pass 


func display_damage_text(damage_amount : float):
	if position_tween != null and position_tween.is_running():
		position_tween.kill()		#终止正在运行动画
	if scale_tween != null and position_tween.is_running():
		scale_tween.kill()			#终止正在运行动画
		
	label.text = str(damage_amount)	#将浮点转换为字符串输出，否则会报错
	
	position_tween = create_tween()	#创建Tween动画
	scale_tween = create_tween()
	
	position_tween.tween_property(self , "global_position" , global_position + Vector2.UP * 30 , 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE) #设置坐标位置的 终点 和 持续时间 + 自定义的缓动函数 ease + trans
	scale_tween.tween_property(self , "scale" , Vector2.ONE * 0.75  , 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)								#设置大小的 终点 和 持续时间 + 自定义的缓动函数 ease + trans
	position_tween.tween_property(self , "global_position" , global_position + Vector2.UP * 40 , 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(self , "scale" , Vector2.ZERO , 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	position_tween.tween_callback(queue_free)	#消除节点

func set_damage(damage):
	damaged = damage
