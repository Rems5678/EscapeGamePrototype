extends Control

signal inventory_open
signal inventory_close
var is_open = false

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var inventory_slots: Array = $NinePatchRect/CarouselContainer.get_children()
@onready var carousel_container := $NinePatchRect/CarouselContainer

func _init():
	close()
	
func _ready():
	inventory.add_item.connect(add_slot)
	inventory.remove_item.connect(remove_slot)
	#inventory.update.connect(update_slots)
	#update_slots()
	
func update_slots():
	print(inventory_slots)
	for i in range(min(inventory.slots.size(), inventory_slots.size())):
		inventory_slots[i].update(inventory.slots[i])
		

func add_slot(item: InventoryItem):
	var has_no_children = carousel_container.get_children().size() == 0
	print(carousel_container.get_children())
	var new_slot = preload("res://inventory/inventory_item_slot_ui.tscn").instantiate()
	carousel_container.add_child(new_slot)
	new_slot.update(item)
	
	if (has_no_children):
		print("doesn't have children")
		inventory.set_active_slot(item)

func remove_slot(item):
	for i in inventory_slots.size():
		var slot = inventory_slots[i]
		if slot.item == item:
			inventory_slots[i].queue_free()
			break;

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			inventory_close.emit()
			close()
		else:
			inventory_open.emit()
			open()
			
func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true

func _on_carousel_container_active_slot_changed(active_child_index: int):
	#var active_slot = inventory.slots[active_child_index]
	#inventory.set_active_slot(active_slot)
	var active_item = inventory.items[active_child_index]
	inventory.set_active_slot(active_item)
