extends Node3D

@onready var interaction_trigger: InteractionTrigger = $InteractionTrigger

func _ready():
	interaction_trigger.interact = Callable(self, "_on_interact")
	
func _on_interact():
	print("puzzle 1 interacted")
