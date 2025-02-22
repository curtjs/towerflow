class_name ConductorComponent
extends Area2D

@export var energized: bool = false

@onready var structure := get_parent() as Structure

var surrounding_conductors: Array[ConductorComponent] = []

func _ready() -> void:
	# Update visual state based on initial energized value
	$EnergizedVisualizer.visible = energized

func _on_area_entered(area: Area2D) -> void:
	if !structure.placed: return
	
	if area is ConductorComponent:
		var conductor := area as ConductorComponent
		if not surrounding_conductors.has(conductor):
			# Add each other to surrounding conductors
			surrounding_conductors.append(conductor)
			conductor.surrounding_conductors.append(self)
			
		# Propagate energy state
		if conductor.energized:
			make_energized()
		elif energized:
			conductor.make_energized()

func _on_area_exited(area: Area2D) -> void:
	if !structure.placed: return
	
	if area is ConductorComponent:
		var conductor := area as ConductorComponent
		if surrounding_conductors.has(conductor):
			# Remove mutual connection
			surrounding_conductors.erase(conductor)
			if conductor.surrounding_conductors.has(self):
				conductor.surrounding_conductors.erase(self)
			
			# Check if we need to de-energize
			if energized and not has_energized_source():
				deenergize()
			
			# Check if other conductor needs to de-energize
			if conductor.energized and not conductor.has_energized_source():
				conductor.deenergize()

func make_energized() -> void:
	if energized || !structure.placed: return
	
	energized = true
	$EnergizedVisualizer.visible = true
	# Propagate to surrounding conductors
	for conductor in surrounding_conductors:
		conductor.make_energized()

func deenergize() -> void:
	if !energized || !structure.placed: return
	
	energized = false
	$EnergizedVisualizer.visible = false
	# Notify neighbors to check their connections
	for conductor in surrounding_conductors:
		conductor.check_energy_connection()

func check_energy_connection() -> void:
	if !structure.placed: return
	
	if energized && !has_energized_source():
		deenergize()

func has_energized_source(visited: Array[ConductorComponent] = []) -> bool:
	if !structure.placed: return false
	
	if self in visited:
		return false
	visited.append(self)
	
	if energized:
		return true
	
	for conductor in surrounding_conductors:
		if conductor.has_energized_source(visited):
			return true
	return false
