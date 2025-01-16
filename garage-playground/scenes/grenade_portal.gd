extends Node3D

@export var object_to_spawn: PackedScene
@export var connect_to: Node3D 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$portal_fx.active = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	$portal_fx.global_position = $RigidBody3D.global_position + Vector3(0, 1, 0)
	$portal_fx.visible = true
	$portal_fx.active = true
	$RigidBody3D.queue_free()
	if connect_to:
		$portal_fx.connect_portal = connect_to.get_node("portal_fx")
