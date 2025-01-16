extends Node3D


var grabbed_object = null
var Zpos = 8  #distance bedtween viewport and item
var mouse = Vector2()
var grab_pos = Vector2()
var Distance = 2000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if grabbed_object:
		grabbed_object.global_position = get_grab_pos()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse = event.position
	if event is InputEventMouseButton:
		if event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
			get_mouse_world_pos(mouse)
		elif event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
			grabbed_object = null
	
	
	
func get_mouse_world_pos(mouse:Vector2):
	var space = get_world_3d().direct_space_state
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end = get_viewport().get_camera_3d().project_position(mouse,Distance)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	
	var result = space.intersect_ray(params)
	if result.is_empty() == false:
		grabbed_object = result.collider
	
	
func get_grab_pos():
	return get_viewport().get_camera_3d().project_position(mouse,Zpos)
