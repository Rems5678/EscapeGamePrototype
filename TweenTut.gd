extends Control

var tween: Tween
@onready var colorRect := $ColorRect

func _on_move_pressed():
	tween = create_tween()
	
	tween.tween_property(colorRect, "position:x", 512, 2.0)
	tween.tween_property(colorRect, "position:x", 320, 1.0)


func _on_move_bounce_pressed():
	tween = create_tween()
	
	tween.tween_property(colorRect, "position:x", 512, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(colorRect, "position:x", 320, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	


func _on_scale_pressed():
	tween = create_tween()
	
	tween.tween_property(colorRect, "scale", Vector2(2, 2), 2)
	tween.tween_property(colorRect, "scale", Vector2(1, 1), 2)


func _on_rotate_pressed():
	tween = create_tween().set_loops(2)
	
	tween.tween_property(colorRect, "rotation_degrees", 360, 1.0)
	tween.tween_interval(1)
	tween.tween_property(colorRect, "rotation_degrees", 0, 1.0)
	tween.tween_interval(1)


func _on_move_scale_pressed():
	tween = create_tween().set_parallel(true)
	
	tween.tween_property(colorRect, "position:x", 512, 2)
	tween.tween_property(colorRect, "scale", Vector2(2, 2), 2)
	
	tween.chain().tween_property(colorRect, "position:x", 320, 1)
	tween.tween_property(colorRect, "scale", Vector2(1, 1), 1)


func _on_red_pressed():
	tween = create_tween()
	
	tween.tween_property(colorRect, "color", Color.RED, 1).set_delay(1)
	tween.tween_property(colorRect, "color", Color.WHITE, 1)


func _on_transparent_pressed():
	tween = create_tween()
	
	tween.tween_property(colorRect, "modulate:a", 0, 2)
	tween.tween_property(colorRect, "modulate:a", 1, 1)

func _on_blue_pressed():
	tween = create_tween()
	
	tween.tween_callback(_set_blue)
	tween.tween_property(colorRect, "color", Color.WHITE, 1).set_delay(1)

func _set_blue():
	colorRect.color = Color.BLUE

func _on_green_pressed():
	tween = create_tween()
	
	tween.tween_method(_set_green, Color.BLUE, Color.GREEN, 2)
	tween.tween_property(colorRect, "color", Color.WHITE, 1).set_delay(1)

func _set_green(col: Color):
	colorRect.color = col
