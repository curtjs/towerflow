class_name BuildingController
extends Node2D


@export var structure_scene: PackedScene
@export var grid_size: int = 16

var ghost_object: Sprite2D


func _ready() -> void:
	ghost_object = structure_scene.instantiate()
	ghost_object.modulate = Color(1, 1, 1, 0.5)
	add_child(ghost_object)


func _process(delta: float) -> void:
	update_ghost_pos()


func update_ghost_pos() -> void:
	var m_pos = get_global_mouse_position()
	var s_pos = snap_to_grid(m_pos)
	ghost_object.global_position = s_pos


func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / grid_size) * grid_size,
		round(pos.y / grid_size) * grid_size
	)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mbe = event as InputEventMouseButton
		
		if mbe.button_index == MOUSE_BUTTON_LEFT && mbe.pressed:
			place_structure()


func place_structure() -> void:
	var new_structure = structure_scene.instantiate()
	new_structure.global_position = ghost_object.global_position
	add_child(new_structure)
