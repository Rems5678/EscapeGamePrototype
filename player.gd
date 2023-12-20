class_name Player
extends CharacterBody3D

signal interacting
@export var speed = 10
@export var camera_rotate_speed_y = .005
@export var camera_rotate_speed_x = .005
@export var camera_y_clamp_min = -30
@export var camera_y_clamp_max = 60
@export var inventory: Inventory

const RAY_LENGTH = 10

@onready var CAMERA_PIVOT := $Pivot
@onready var CAMERA := $Pivot/PlayerCamera
@onready var INVENTORY_UI := $InventoryUI

var interactables: Array
var target_velocity = Vector3.ZERO
var interactable_mesh = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var viewportSize = CAMERA.get_viewport().get_visible_rect().size
	$MouseCursor.position = viewportSize / 2
	
func _unhandled_input(event: InputEvent) -> void:
	# todo: remove event		
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			get_interactable_from_mouse_position(event.position)
			rotate_y(-event.relative.x * camera_rotate_speed_y)
			CAMERA_PIVOT.rotate_x(event.relative.y * camera_rotate_speed_x)
			CAMERA_PIVOT.rotation.x = clamp(CAMERA_PIVOT.rotation.x, deg_to_rad(camera_y_clamp_min), deg_to_rad(camera_y_clamp_max))


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
	direction = direction.normalized()
	return direction
	
func detect_object_from_camera(mousePosition):
	var parameters = PhysicsRayQueryParameters3D.new()
	parameters.from = CAMERA.project_ray_origin(mousePosition)
	parameters.to = parameters.from + CAMERA.project_ray_normal(mousePosition) * RAY_LENGTH
	return get_world_3d().direct_space_state.intersect_ray(parameters)
	
func get_interactable_from_mouse_position(mousePosition):
	var result = detect_object_from_camera(mousePosition)
	if result.size() > 0:
		var groups = result.collider.get_groups()
		if groups.has("interactables"):
			for group in groups:
				if group == "interactables":
					var mesh = result.collider.get_node("Mesh")
					if mesh != null && !interactable_mesh:
						toggle_interactable_outline(mesh, true)
		elif interactable_mesh != null:
			toggle_interactable_outline(interactable_mesh, false)
	elif interactable_mesh != null:
		toggle_interactable_outline(interactable_mesh, false)
				
func toggle_interactable_outline(mesh: MeshInstance3D, show_outline: bool):
	#TODO: detect the last next_pass for more complicated materials
	var outline_material = preload("res://assets/outline.tres")
	var active_material = mesh.get_active_material(0)
	if show_outline:
		var new_material = active_material.duplicate()
		new_material.next_pass = outline_material
		mesh.set_surface_override_material(0, new_material)
		interactable_mesh = mesh
	elif active_material.next_pass:
		active_material.next_pass = null
		interactable_mesh = null

func collect(item):
	print("collecting item")
	inventory.insert(item)

func remove_from_inventory(item):
	print("removing item")
	var item_was_removed = inventory.remove_active_item(item)
	return item_was_removed
