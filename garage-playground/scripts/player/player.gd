extends CharacterBody3D


const SPEED = 2.5
const JUMP_VELOCITY = 4.5
#var Grenade = preload("res://scenes/Portals/portal_node.tscn")
var canThrow = true


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
		
		
	move_and_slide()
	
	#Grenade function
	#grenadeThrow()
	
#func grenadeThrow():
	#if Input.is_action_just_released("Throw") && canThrow:
		#var grenadeins = Grenade.instantiate()
		#grenadeins.position = $visuals/player/Armature/Nadepos.global_position
		#get_tree().current_scene.add_child(grenadeins)
		#
		#canThrow = false
		#$Throwtimer.start()
		#
		##force var for grenade in negative so it moves away from player
		#var force = -20
		##Control Arch of grenade
		#var upDirection = 15
		#var direction =  
		#var impulse = direction * force + visuals.look_at
		#
		#var playerRotation = $visuals/player/Armature/Nadepos.global_transform.basis.z.normalized()
		#
		#grenadeins.apply_central_impulse(impulse)
		
		
		
		

		
		
		
		
		


func _on_throwtimer_timeout() -> void:
	canThrow = true
