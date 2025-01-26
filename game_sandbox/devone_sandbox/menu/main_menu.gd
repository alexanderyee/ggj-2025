extends Menu

@onready var modeltester : Node3D = $SubViewportContainer/SubViewport/ModelTester
@onready var creditspanel : Panel = $MarginContainer/CreditsPanel
func _ready() -> void:
	var fade_in_first_scene_options = SceneManager.create_options(1, "circle")
	var first_scene_general_options = SceneManager.create_general_options(Color(0, 0, 0), 1, false)
	SceneManager.show_first_scene(fade_in_first_scene_options, first_scene_general_options)
	
	print("Main Menu loaded successfully.")
	$MarginContainer/VBoxContainer/Play.mouse_entered.connect(on_play_mouse_entered)
	$MarginContainer/VBoxContainer/Play.mouse_exited.connect(on_play_mouse_exited)
	
func _process(delta: float) -> void:
	var target_alpha :float = 0.0
	if $MarginContainer/VBoxContainer/Credits.is_hovered():
		target_alpha = 1.0
		print("hfdss")
	creditspanel.modulate.a = lerpf(creditspanel.modulate.a, target_alpha, delta*10.0)

func on_play_mouse_entered():
	modeltester.crab.set_shock()

func on_play_mouse_exited():
	modeltester.crab.set_normal()

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
