extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
var active_areas = []
var can_interact = true
var closest_interactable = null

func _process(delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
#		TODO: do something with the closest active_area, e.g., show label above active_area
		closest_interactable = active_areas[0]
	else:
		closest_interactable = null
		

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	
	return area1_to_player < area2_to_player

func register_area(area: InteractionTrigger):
	active_areas.push_back(area)
		
func unregister_area(area: InteractionTrigger):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			
			await active_areas[0].interact.call()
			
			can_interact = true
