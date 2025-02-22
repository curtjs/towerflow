extends Node2D


@onready var sprite := get_parent() as Sprite2D
@onready var raycasts: Dictionary[Vector2, RayCast2D] = {
	Vector2.RIGHT: $RayCastRight,
	Vector2.UP: $RayCastUp,
	Vector2.LEFT: $RayCastLeft,
	Vector2.DOWN: $RayCastDown
}

enum {RIGHT = 0, UP = 1, LEFT = 2, DOWN = 3}

var connection_mask: int = 0
var neighboring_conductors: Dictionary[Vector2, Area2D] = {
	Vector2.RIGHT: null,
	Vector2.UP: null,
	Vector2.LEFT: null,
	Vector2.DOWN: null
}


func _process(delta: float) -> void:
	update_connections()


func update_connections() -> void:
	for dir in raycasts:
		var ray = raycasts[dir]
		ray.force_raycast_update()
		
		if ray.is_colliding():
			var collider = ray.get_collider()
			
			if collider.is_in_group("reciever"):
				neighboring_conductors[dir] = collider
			else:
				neighboring_conductors[dir] = null
		else:
			neighboring_conductors[dir] = null
	
	var new_mask = 0
	if neighboring_conductors[Vector2.RIGHT]: new_mask |= 1 << RIGHT
	if neighboring_conductors[Vector2.UP]: new_mask |= 1 << UP
	if neighboring_conductors[Vector2.LEFT]: new_mask |= 1 << LEFT
	if neighboring_conductors[Vector2.DOWN]: new_mask |= 1 << DOWN
	
	if connection_mask != new_mask:
		connection_mask = new_mask
		update_visual_state()


func update_visual_state() -> void:
	print(connection_mask)
	sprite.frame = connection_mask
