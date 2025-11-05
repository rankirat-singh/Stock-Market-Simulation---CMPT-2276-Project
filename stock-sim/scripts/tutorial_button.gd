extends Button

# Connect this to any button that should show a tutorial
# Set the tutorial_key in the inspector

@export var tutorial_key: String = "welcome"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	var game_manager = get_node("/root/MainScene")
	if game_manager and game_manager.has_method("show_tutorial"):
		game_manager.show_tutorial(tutorial_key)
	else:
		print("Game_manager not found or doesn't have show_tutorial method")
