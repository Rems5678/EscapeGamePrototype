extends RigidBody3D

@export var item: InventoryItem
var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$InteractionTrigger.interact = Callable(self, "_on_interact")

func _on_interact():
	player.collect(item)
	print("collected box")
	queue_free()
