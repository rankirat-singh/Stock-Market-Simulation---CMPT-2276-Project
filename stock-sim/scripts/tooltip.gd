extends Control

# Tooltip script for showing definitions on hover
var tooltip_panel: Panel
var tooltip_label: Label
var is_visible: bool = false

# Definitions for each term
var definitions: Dictionary = {
	"buy": "BUY: Purchase shares of the selected stock at the current market price. You need enough cash to complete the transaction. Buying low and selling high is the key to profit!",
	"sell": "SELL: Sell shares of the selected stock that you currently own at the current market price. You can only sell shares you actually own. Selling at the right time maximizes your profit!",
	"hold": "HOLD: Skip taking any action this quarter. Your portfolio remains unchanged. Use this when you want to wait and see how the market moves before making a decision.",
	"next_quarter": "NEXT QUARTER: Advance to the next quarter of the game. Each quarter represents a period of time where stock prices change. You have 4 quarters total to grow your portfolio.",
	"learn": "LEARN: Access the tutorial menu to learn about stock trading concepts, market trends, sentiment analysis, diversification strategies, and quarter-by-quarter planning."
}

func _ready():
	print("TooltipManager _ready() called")
	# Create tooltip panel (initially hidden)
	tooltip_panel = Panel.new()
	tooltip_panel.visible = false
	tooltip_panel.z_index = 1000
	tooltip_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tooltip_panel.add_theme_stylebox_override("panel", create_tooltip_style())
	
	# Create label for tooltip text
	tooltip_label = Label.new()
	tooltip_label.add_theme_color_override("font_color", Color.WHITE)
	tooltip_label.add_theme_font_size_override("font_size", 14)
	tooltip_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tooltip_label.text = ""
	tooltip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	tooltip_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	tooltip_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Set margins
	tooltip_label.add_theme_constant_override("margin_left", 10)
	tooltip_label.add_theme_constant_override("margin_top", 10)
	tooltip_label.add_theme_constant_override("margin_right", 10)
	tooltip_label.add_theme_constant_override("margin_bottom", 10)
	
	tooltip_panel.add_child(tooltip_label)
	add_child(tooltip_panel)
	print("Tooltip panel created and added")

func create_tooltip_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.2, 0.95)
	style.border_color = Color(0.4, 0.4, 0.4, 1.0)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.content_margin_left = 10
	style.content_margin_top = 10
	style.content_margin_right = 10
	style.content_margin_bottom = 10
	return style

func show_tooltip(text: String, position: Vector2):
	"""Show tooltip at the given position (position should be viewport coordinates)"""
	if not tooltip_panel or not tooltip_label:
		print("ERROR: tooltip_panel or tooltip_label is null!")
		return
	
	print("show_tooltip called with text length: ", text.length(), " position: ", position)
	tooltip_label.text = text
	# Set a reasonable size - label will wrap text
	tooltip_panel.size = Vector2(320, 150)  # Fixed size, text will wrap
	tooltip_label.size = Vector2(300, 130)  # Leave margins
	
	# Position is already in viewport coordinates, and since TooltipManager covers the whole screen
	# with anchors, we can use the position directly (it's already in local coordinates)
	tooltip_panel.position = position + Vector2(15, 15)  # Offset from cursor
	
	# Adjust position if tooltip goes off screen
	var viewport_size = get_viewport().get_visible_rect().size
	if tooltip_panel.position.x + tooltip_panel.size.x > viewport_size.x:
		tooltip_panel.position.x = position.x - tooltip_panel.size.x - 15
	if tooltip_panel.position.y + tooltip_panel.size.y > viewport_size.y:
		tooltip_panel.position.y = position.y - tooltip_panel.size.y - 15
	
	# Make sure tooltip is on top and visible
	tooltip_panel.z_index = 1000
	tooltip_panel.visible = true
	is_visible = true
	
	# Force update
	tooltip_panel.queue_redraw()
	
	print("Tooltip shown at position: ", tooltip_panel.position, " visible: ", tooltip_panel.visible, " z_index: ", tooltip_panel.z_index)

func hide_tooltip():
	"""Hide the tooltip"""
	if tooltip_panel:
		tooltip_panel.visible = false
	is_visible = false

func get_definition(key: String) -> String:
	"""Get definition text for a given key"""
	return definitions.get(key, "Definition not found")
