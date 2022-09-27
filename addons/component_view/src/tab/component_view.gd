@tool
extends Control
var editor_plugin:EditorPlugin
var search_term = ""

var search_in_all = false
var component_path = "res://assets/components/"
var default_component_image:Texture = load("res://addons/component_view/assets/default.png")

var scene_cache = {}
var items = {}
var categories = {}

func get_scene_for(item_name):
	if not scene_cache.has(item_name):
		scene_cache[item_name] = load(component_path + item_name + ".tscn")
		pass
	return scene_cache[item_name]
	pass

func get_edited_root() -> Node:
	var eds = editor_plugin.get_editor_interface().get_selection()
	var selected = eds.get_selected_nodes()
	print(selected)
	if selected.size():
		return selected[0]
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	update_categories()
	pass


func add_item(path,component_file,category):
	var component_name= component_file.split(".")[0]
	var icon:Texture
	var icon_path = path + "/" + component_name + ".png"
	
	var component_scene_path = path + "/" + component_name + ".tscn"
	var scene = load(component_scene_path)
	if ResourceLoader.exists(icon_path):
		icon = load(icon_path)
	else:
		icon = default_component_image

	items[component_name]= {
		"name" : component_name,
		"icon" : icon,
		"scene" : scene,
	}
	
	if(category.length()==0):
		category = "ungrouped"
	#print(category)
	add_item_to_category(category,component_name)
	pass

func add_item_to_category(category,component_name):
	if not categories.has(category):
		categories[category] = []
	categories[category].append(component_name)
	pass

func list_files_in_directory(path,category=""):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	#print("opened "+path)
	while true:
		var file = dir.get_next()
		#print(file)
		if file == "":
			break
		elif not file.begins_with(".") :
			if file.ends_with(".tscn"):
				#print("added as scene")
				add_item(path,file,category)
				pass
			elif file.count(".") == 0 and category.length() == 0:
				#print("added as category")
				list_files_in_directory(path + "/" + file,file)
				pass
	dir.list_dir_end()

func update_categories():
	#print("cleaning categories")
	categories.clear()
	list_files_in_directory(component_path)
	var category_list = $VBoxContainer2/VBoxContainer/CategoryMenu/CategoryList
	category_list.clear()
	
	for key in categories.keys():
		category_list.add_item(key)
	
	_on_CategoryList_item_selected(0)
	pass

func is_blank(text:String):
	var searched = text.replace(" ","")
	searched = searched.replace("	","")
	#print(searched.length())
	return searched.length()==0
	pass

func _on_UpdateCategoriesButton_pressed():
	update_categories()
	pass

func _on_SearchButton_pressed():
	var search_text_box = $VBoxContainer2/VBoxContainer/SearchMenu/TextEdit
	var search_all_checkbox = $VBoxContainer2/VBoxContainer/SearchMenu/SearchInAll
	search_term = search_text_box.text
	if(is_blank(search_term)):
		var category_list = $VBoxContainer2/VBoxContainer/CategoryMenu/CategoryList
		var selected = category_list.selected
		_on_CategoryList_item_selected(selected)
		pass
	var results = []
	var search_in = []
	
	if(search_all_checkbox.pressed):
		search_in.append_array(items.values())
		pass
	else:
		var category_list = $VBoxContainer2/VBoxContainer/CategoryMenu/CategoryList
		var index = category_list.selected
		var category = category_list.get_item_text(index)
		for item_name in categories[category]:
			search_in.append(items[item_name])
		pass
	#print(search_in)
	for item in search_in:
		if (item.name as String).find(search_term)>-1:
			results.append(item)
			pass

	_update_item_list(results)
	pass

func _on_SearchInAll_toggled(button_pressed):
	search_in_all = button_pressed
	pass 

func _on_ItemList_item_activated(index):
	var item_list = $VBoxContainer2/ScrollContainer/ItemList
	var root = get_edited_root()
	print(root)
	if root == null :
		return
	var item = item_list.get_item_text(index)
	
	var item_instance = items[item].scene.instantiate()
	item_instance.name = item
	
	
	root.add_child(item_instance)
	item_instance.set_owner(root.get_tree().get_edited_scene_root())
	
	pass 

func _on_CategoryList_item_selected(index):
	var item_list = $VBoxContainer2/ScrollContainer/ItemList
	var category_list = $VBoxContainer2/VBoxContainer/CategoryMenu/CategoryList
	var category = category_list.get_item_text(index)
	#print(category)
	#print(categories)
	var results = []
	for item in categories[category]:
		var item_data = items[item]
		results.append(item_data)
		pass
	_update_item_list(results)
	pass 
	
func _update_item_list(items:Array):
	var item_list = $VBoxContainer2/ScrollContainer/ItemList
	item_list.clear()
	for item in items:
		item_list.add_item(item.name,item.icon)
		pass
	pass
