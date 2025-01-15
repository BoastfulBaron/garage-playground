extends CharacterBody3D


const SPEED = 2.5
const JUMP_VELOCITY = 4.5
var grenade = preload("res://scenes/grenade_portal.tscn")
var canThrow = true
var last_thrown = null
var thrown_now = null

@export var marker: Node3D
@export var object_to_spawn: PackedScene
@export var throw_strength: float = 500.0
@export var player: Node3D

@onready var animation_player: AnimationPlayer = $visuals/player/AnimationPlayer
@onready var visuals: Node3D = $visuals

var walking = false


func _ready():
	GameManager.set_player(self)
#	blend the animation for smoother results
#	for left to right by the set value
	animation_player.set_blend_time("idle","walk",0.3)
	animation_player.set_blend_time("walk","idle",0.3)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "foreward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		visuals.look_at(direction + position)
		
		if !walking:
			walking = true
			animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if walking:
			walking = false
			animation_player.play("idle")
		
	if Input.is_action_just_pressed("Throw"):
		spawn_and_throw_object()
	
	
	
	is_on_wall()

	move_and_slide()
	
func spawn_and_throw_object():
	if object_to_spawn:
		var thrown_object = grenade.instantiate()
		
		thrown_object.position = marker.global_position
		
		get_parent().add_child(thrown_object)
		
		var player_forward_direction = -player.transform.basis.z.normalized()
		
		thrown_object.get_node("RigidBody3D").linear_velocity = player_forward_direction * throw_strength
		
		if last_thrown:
			thrown_object.get_node("Portal").connect_portal = last_thrown.get_node("Portal")
			last_thrown.get_node("Portal").connect_portal = thrown_object.get_node("Portal")
			last_thrown = null
		else:
			last_thrown = thrown_object
