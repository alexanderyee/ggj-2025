extends Menu


func _ready() -> void:
	var fade_in_first_scene_options = SceneManager.create_options(1, "circle")
	var first_scene_general_options = SceneManager.create_general_options(Color(0, 0, 0), 1, false)
	SceneManager.show_first_scene(fade_in_first_scene_options, first_scene_general_options)
	
	print("Main Menu loaded successfully.")
	pass


func _on_play_pressed() -> void:
	print("Starting the game...")
	SceneManager.change_scene(
		scene, 
		fade_out_options,
		fade_in_options,
		general_options)
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	print("Quiting the game.")
	get_tree().quit()
	pass # Replace with function body.
