extends LinkButton

export var scene_to_load: String 


func _on_NewGameButton_pressed():
	get_tree().change_scene(scene_to_load)

func _on_StageSelectButton_pressed():
	get_tree().change_scene(scene_to_load)
