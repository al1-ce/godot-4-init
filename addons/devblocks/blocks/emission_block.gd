@tool
extends ColoredBlock
class_name EmissionBlock


@export_range(0.0, 4.0) var emission_energy : float = 1.0 :
	set(value):
		emission_energy = value
		_update_mesh()


func _enter_tree():
	var mesh = MeshInstance3D.new()
	var shape = CollisionShape3D.new()
	
	mesh.mesh = preload("res://addons/devblocks/blocks/block_mesh.tres")
	mesh.set_surface_override_material(0, preload("res://addons/devblocks/blocks/emission_block_material.tres"))
	shape.shape = preload("res://addons/devblocks/blocks/block_shape.tres")
	add_child(mesh)
	add_child(shape)
	
	mesh.name = "Mesh"
	shape.name = "Shape"
	
	_mesh = mesh

func _ready() -> void:
	super._ready()
	_mesh.get_surface_override_material(0).set("emission_enabled", true)
	

func _update_mesh() -> void:
	super._update_mesh()
	if _mesh != null:
		_mesh.get_surface_override_material(0).set("emission", block_color)
		_mesh.get_surface_override_material(0).set("emission_energy", emission_energy)
