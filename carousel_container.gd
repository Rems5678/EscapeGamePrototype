extends Container
class_name CarouselContainer

signal active_slot_changed(active_child_index: int)
@onready var children := get_children()
@onready var active_child_index = 0
@onready var parent_node = get_parent()
@onready var active_slot_position: Vector2 = size / 2 if not parent_node else parent_node.size/2
@export var transition_time := 0
@export var scroll_amount := 30
var original_stylebox
var original_modulate 

func _ready():
	if get_children().size() > 0:
		active_slot_changed.emit(active_child_index)
		original_stylebox = get_children()[0].get_theme_stylebox("panel").duplicate()
		original_modulate = get_children()[0].modulate
		initialize_position()
		tween_children('down', true)

func _draw():
	if get_children().size() > 0:
		print("has children, init position")
		initialize_position()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if get_children().size() > 0:
			if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN] and event.pressed and is_visible_in_tree():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					move_up()
				else:
					move_down()

func move_up() -> void:
	if (active_child_index == 0):
		return
	else:
		active_child_index = active_child_index - 1
		active_slot_changed.emit(active_child_index)
		tween_children('up')

func move_down() -> void:
	if (active_child_index == get_children().size() - 1):
		return
	else:
		active_child_index = active_child_index + 1
		active_slot_changed.emit(active_child_index)
		tween_children('down')

func tween_children(direction, is_init = false) -> void:
	for i in get_children().size():
		var c := get_children()[i]
		var tween := create_tween()
		var target_position = calculate_child_position(i, direction) if !is_init else calculate_init_child_position(i)
		#if (i == active_child_index):
			#print("active child")
		#print(target_position)
		#print("global rect %s" % get_global_rect()) 
		tween.tween_method(get_modulate_and_position.bind(c), c.position, target_position, transition_time)
		
func get_modulate_and_position(child_position: Vector2, child: InventoryItemSlotUI):
	var new_alpha = calculate_child_modulate(child_position.y)
	child.position = child_position
	
	if (!original_stylebox):
		original_stylebox = child.get_theme_stylebox("panel").duplicate()
	if (!original_modulate):
		original_modulate = child.modulate
	
	if child == get_children()[active_child_index]:
		var new_stylebox_panel = original_stylebox.duplicate()
		new_stylebox_panel.border_width_top = 3
		new_stylebox_panel.border_color = Color('54aa52')
		child.add_theme_stylebox_override("panel", new_stylebox_panel)
	else:
		child.add_theme_stylebox_override("panel", original_stylebox)
		child.modulate = Color(original_modulate, new_alpha)

func initialize_position():
	var active_child = get_children()[active_child_index]
	#print(active_child.position.y)
	#print(active_slot_position.y)
	#print((size / 2).y)
	#print(active_slot_position.y - active_child.position.y)
	set_offset(SIDE_TOP, active_slot_position.y - active_child.position.y/ 2)
	#set_offset(SIDE_TOP, active_slot_position.y)

func calculate_init_child_position(i: int):
	var child = get_children()[i]
	child.position.y + (child.size.y * i)
	return child.position
	
func calculate_child_position(i: int, direction) -> Vector2:
	var current_position = get_children()[i].position
	var new_position = current_position
	var current_size = get_children()[i].size
	if direction == 'up':
		if (i+1 < get_children().size() - 1):
			var next_child = get_children()[i+1]
			new_position = next_child.position
		else:
			new_position.y += current_size.y
	elif direction == 'down':
		if (i-1 >= 0):
			var prev_child = get_children()[i-1]
			new_position = prev_child.position
		else:
			new_position.y -= current_size.y
	return new_position

func calculate_child_modulate(position_y):
	var active_child = get_children()[active_child_index]
	var target_position_y = active_child.position.y / 2
	var difference = abs(position_y - target_position_y) / 300
	return 1 - difference if 1 - difference > 0 else 0

