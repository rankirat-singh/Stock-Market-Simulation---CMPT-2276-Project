extends Button

# Question mark button that shows tooltip on hover
@export var tooltip_key: String = ""  # Key for the definition (buy, sell, hold, etc.)
var tooltip_manager: Control = null
var is_hovering: bool = false

func _ready():
	# Set button appearance
	text = "?"
	flat = true
	custom_minimum_size = Vector2(30, 30)
	
	# Style the button
	add_theme_color_override("font_color", Color(0.5, 0.7, 1.0, 1.0))
	add_theme_color_override("font_hover_color", Color(0.7, 0.9, 1.0, 1.0))
	add_theme_font_size_override("font_size", 18)
	
	# Make sure button can receive mouse events
	mouse_filter = MOUSE_FILTER_STOP
	
	# Find tooltip manager in the scene - try multiple paths
	call_deferred("_find_tooltip_manager")
	
	# Connect signals
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	
	print("Question mark button ready for key: ", tooltip_key)

func _find_tooltip_manager():
	"""Find the tooltip manager node"""
	tooltip_manager = get_node_or_null("/root/MainScene/GameWindow/TooltipManager")
	if not tooltip_manager:
		# Try alternative paths
		var scene_root = get_tree().root.get_child(0)
		if scene_root:
			tooltip_manager = scene_root.find_child("TooltipManager", true, false)
	
	if tooltip_manager:
		print("TooltipManager found for key: ", tooltip_key)
	else:
		print("WARNING: TooltipManager not found for key: ", tooltip_key)

func _process(_delta):
	"""Update tooltip position while hovering"""
	if is_hovering and tooltip_manager and tooltip_manager.has_method("show_tooltip"):
		var definition = tooltip_manager.get_definition(tooltip_key)
		# Use viewport mouse position which is more reliable
		var mouse_pos = get_viewport().get_mouse_position()
		tooltip_manager.show_tooltip(definition, mouse_pos)

func _on_mouse_entered():
	"""Show tooltip when mouse enters"""
	print("Mouse entered question mark: ", tooltip_key)
	is_hovering = true
	if not tooltip_manager:
		_find_tooltip_manager()
	
	if tooltip_manager:
		if tooltip_manager.has_method("show_tooltip"):
			var definition = tooltip_manager.get_definition(tooltip_key)
			# Use viewport mouse position which is more reliable
			var mouse_pos = get_viewport().get_mouse_position()
			print("Showing tooltip for: ", tooltip_key, " at position: ", mouse_pos)
			tooltip_manager.show_tooltip(definition, mouse_pos)
		else:
			print("TooltipManager doesn't have show_tooltip method")
	else:
		print("TooltipManager is null!")

func _on_mouse_exited():
	"""Hide tooltip when mouse exits"""
	is_hovering = false
	if tooltip_manager and tooltip_manager.has_method("hide_tooltip"):
		tooltip_manager.hide_tooltip()

func _on_pressed():
	"""Prevent button from being clickable (just for hover)"""
	# Do nothing - this is just for hover tooltips
	pass
