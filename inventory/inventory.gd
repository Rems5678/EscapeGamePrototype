extends Resource
class_name Inventory

signal update
signal add_item(item: InventoryItem)
signal remove_item(item: InventoryItem)
#@export var slots: Array[InventorySlot]
#@export var active_slot: InventorySlot
@export var items: Array[InventoryItem]
@export var active_item: InventoryItem

func insert(item: InventoryItem):
	#for i in range(slots.size()):
		#var slot = slots[i]
		#if slot.item == null:
			#slot.item = item
			#break
	items.push_front(item)
	#update.emit()
	add_item.emit(item)

#func remove_active_item(item: InventoryItem):
	#print(item)
	#print(active_item)
	#if item and item == active_item:
		#var active_slot_index = slots.find(active_slot)
		#if active_slot_index != -1:
			#slots[active_slot_index].item = null
			#active_slot.item = null
			#return true
	#return false
	
func remove_active_item(item: InventoryItem):
	print(item)
	print(active_item)
	if item and item == active_item:
		var active_item_index = items.find(active_item)
		if active_item_index != -1:
			remove_item.emit(item)
			items.pop_at(active_item_index)
			return true
	return false
	
#func set_active_slot(slot: InventorySlot):
	#active_slot = slot
	#active_item = slot.item
	
func set_active_slot(item: InventoryItem):
	active_item = item
