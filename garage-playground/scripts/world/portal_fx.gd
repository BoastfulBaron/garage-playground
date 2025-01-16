extends Area3D


@export var connect_portal: Area3D
@export var active: bool = true
var teleported_to: bool = false
var offset = Vector3(0 , 0 , 3)


func _on_body_entered(body: Node3D) -> void:
	if active && body.name == "Player" && not teleported_to && connect_portal:
		var destination = connect_portal.global_transform.origin
		connect_portal.teleported_to = true
		body.global_transform.origin = destination
		


func _on_body_exited(body: Node3D) -> void:
	teleported_to = false
