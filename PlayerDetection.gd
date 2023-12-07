extends Area3D

@export var nodePath: NodePath
@export var enterFunc: String

func _on_body_entered(body):
	if body is Player:
		print("Player detected")
		if nodePath:
			var nodeOrNull = get_node_or_null(nodePath)
			if nodeOrNull != null:
				var hasEnterFunc = nodeOrNull.has_method(enterFunc)
				if hasEnterFunc:
					nodeOrNull.call(enterFunc)
				else:
					printerr('no enter func was provided')
			else:
				printerr('no node path set')
				
				
				
