extends RigidBody3D

@export var scene_to_spawn: PackedScene
@export var stop_threshold: float = 0.1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if linear_velocity.length() < stop_threshold:
		spawn_scene()
		set_process(false)

func spawn_scene():
	if scene_to_spawn:
		var spawned_object = scene_to_spawn.instantiate()
		
		spawned_object.position = position + Vector3 (0, 1, 0)
		get_parent().add_child(spawned_object)

	queue_free()
