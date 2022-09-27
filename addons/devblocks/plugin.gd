@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("BasicBlock", "StaticBody3D", preload("blocks/basic_block.gd"), preload("textures/block_icon.svg"))
	add_custom_type("ColoredBlock", "StaticBody3D", preload("blocks/colored_block.gd"), preload("textures/block_icon.svg"))
	add_custom_type("EmissionBlock", "StaticBody3D", preload("blocks/emission_block.gd"), preload("textures/block_icon.svg"))
	pass


func _exit_tree():
	remove_custom_type("BasicBlock")
	remove_custom_type("ColoredBlock")
	remove_custom_type("EmissionBlock")
	pass
