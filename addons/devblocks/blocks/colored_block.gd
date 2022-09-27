@tool
extends BasicBlock
class_name ColoredBlock


@export var block_color : Color = Color.WHITE :
	set(value):
		block_color = value
		_update_mesh()


func _enter_tree():
	var mesh = MeshInstance3D.new()
	var shape = CollisionShape3D.new()
	
	mesh.mesh = preload("res://addons/devblocks/blocks/block_mesh.tres")
	mesh.set_surface_override_material(0, preload("res://addons/devblocks/blocks/colored_block_material.tres"))
	shape.shape = preload("res://addons/devblocks/blocks/block_shape.tres")
	
	add_child(mesh)
	add_child(shape)
	
	mesh.name = "Mesh"
	shape.name = "Shape"
	
	_mesh = mesh

func _update_mesh() -> void:
	super._update_mesh()
	if _mesh != null:
		_mesh.get_surface_override_material(0).set("albedo_color", block_color)
