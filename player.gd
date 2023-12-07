class_name Player
extends CharacterBody3D

signal interacting
@export var speed = 10
@onready var CAMERA_PIVOT := $Pivot
@onready var CAMERA := $Pivot/PlayerCamera
@onready var INVENTORY := $Inventory

var target_velocity = Vector3.ZERO
func _ready():
	INVENTORY.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * .005)
			CAMERA_PIVOT.rotate_x(event.relative.y * .005)
			CAMERA_PIVOT.rotation.x = clamp(CAMERA_PIVOT.rotation.x, deg_to_rad(-30), deg_to_rad(60))
		
func _physics_process(delta):
	var direction = on_input_select()
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	velocity = target_velocity * delta
	move_and_collide(velocity)

func on_input_select():
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("up"):
		direction += transform.basis.z
	if Input.is_action_pressed("down"):
		direction -= transform.basis.z
	if Input.is_action_pressed("left"):
		direction += transform.basis.x
	if Input.is_action_pressed("right"):
		direction -= transform.basis.x
	if Input.is_action_just_pressed("interact"):
		print("interact")
	if Input.is_action_just_pressed("inventory"):
		if INVENTORY.is_visible_in_tree():
			INVENTORY.hide()
		else:
			INVENTORY.show()
	direction = direction.normalized()
	return direction
