extends LinkButton

export var scene_to_load: String


func _on_Stage1_pressed():
	get_tree().change_scene(scene_to_load)


func _on_Stage2_pressed():
	get_tree().change_scene(scene_to_load)


