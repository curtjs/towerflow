class_name BuildingController
extends Node2D


@export var structures: Array[PackedScene]
@export var grid_size: int = 16

@onready var build_menu := %BuildMenu

var structure_scene: PackedScene
var ghost_object: Sprite2D


func _process(delta: float) -> void:
	update_ghost_pos()


func update_ghost_pos() -> void:
	if !ghost_object:
		return
	
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
			if build_menu.get_global_rect().has_point(mbe.global_position):
				return
			place_structure()


func place_structure() -> void:
	if !structure_scene:
		return
	
	var new_structure := structure_scene.instantiate() as Structure
	new_structure.global_position = ghost_object.global_position
	new_structure.placed = true
	add_child(new_structure)


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if structures.size() > index:
		structure_scene = structures[index]
		
		if ghost_object:
			ghost_object.queue_free()
		
		ghost_object = structure_scene.instantiate()
		ghost_object.modulate = Color(1, 1, 1, 0.5)
		add_child(ghost_object)
