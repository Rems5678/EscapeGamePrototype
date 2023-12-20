extends Panel
class_name InventoryItemSlotUI

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var item_name: Label = $CenterContainer/Panel/ItemName

#func update(slot: InventorySlot):
	#if slot:
		#if !slot.item:
			#item_name.visible = false
			#item_visual.visible = false
		#else:
			#item_name.visible = true
			#item_name.text = slot.item.item_name
			#item_visual.visible = true
			#item_visual.texture = slot.item.texture

func update(item: InventoryItem):
	if !item:
		item_name.visible = false
		item_visual.visible = false
	else:
		item_name.visible = true
		item_name.text = item.item_name
		item_visual.visible = true
		item_visual.texture = item.texture
