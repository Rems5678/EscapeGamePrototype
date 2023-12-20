extends RigidBody3D

@export var item: InventoryItem
@export var completed_material: Material

var player: Player
var is_empty: bool = true
func _ready():
	player = get_tree().get_first_node_in_group("player")
	$InteractionTrigger.interact = Callable(self, "_on_interact")

func _on_interact():
	if is_empty:
		var removed_item = player.remove_from_inventory(item)
		if removed_item:
			is_empty = false
			var new_material = completed_material
			$Mesh.set_surface_override_material(0, new_material)
