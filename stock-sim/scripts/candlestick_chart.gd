extends Control

# Candlestick Chart - Draws actual stock price data
# Attach this to a Control node in your scene

var price_data = []  # Array of prices [Q1, Q2, Q3, Q4]
var chart_margin = 40
var candle_width = 60
var candle_spacing = 30

# Colors
var color_up = Color(0.18, 0.8, 0.44)    # Green for price increase
var color_down = Color(0.91, 0.3, 0.24)  # Red for price decrease
var color_neutral = Color(0.7, 0.7, 0.7) # Gray for no change
var color_grid = Color(0.3, 0.3, 0.3)
var color_text = Color(0.9, 0.9, 0.9)

func _ready():
	# Example data - will be replaced by real stock data
	price_data = [150.0, 160.0, 155.0, 170.0]
	queue_redraw()

func set_stock_data(prices: Array):
	"""Update chart with new stock prices"""
	price_data = prices
	queue_redraw()

func _draw():
	if price_data.size() == 0:
		return
	
	var chart_area = get_size()
	var chart_width = chart_area.x - (chart_margin * 2)
	var chart_height = chart_area.y - (chart_margin * 2)
	
	# Find min and max prices for scaling
	var min_price = price_data.min()
	var max_price = price_data.max()
	var price_range = max_price - min_price
	
	# Add some padding to the range
	min_price -= price_range * 0.1
	max_price += price_range * 0.1
	price_range = max_price - min_price
	
	# Draw background
	draw_rect(Rect2(0, 0, chart_area.x, chart_area.y), Color(0.1, 0.1, 0.15))
	
	# Draw grid lines
	draw_grid(chart_margin, chart_margin, chart_width, chart_height, min_price, max_price)
	
	# Draw candlesticks
	var total_candles = price_data.size()
	var available_width = chart_width - (candle_spacing * (total_candles + 1))
	var actual_candle_width = min(candle_width, available_width / total_candles)
	
	for i in range(total_candles):
		var x_pos = chart_margin + candle_spacing + (i * (actual_candle_width + candle_spacing))
		var current_price = price_data[i]
		var previous_price = price_data[i - 1] if i > 0 else current_price
		
		draw_candlestick(
			x_pos,
			chart_margin,
			chart_height,
			current_price,
			previous_price,
			min_price,
			max_price,
			actual_candle_width,
			i
		)
	
	# Draw border
	draw_rect(Rect2(chart_margin, chart_margin, chart_width, chart_height), color_grid, false, 2.0)

func draw_grid(x_offset, y_offset, width, height, min_val, max_val):
	"""Draw grid lines and price labels"""
	var num_lines = 5
	var step = height / num_lines
	
	for i in range(num_lines + 1):
		var y = y_offset + (i * step)
		
		# Draw horizontal line
		draw_line(
			Vector2(x_offset, y),
			Vector2(x_offset + width, y),
			color_grid,
			1.0
		)
		
		# Draw price label
		var price_value = max_val - ((max_val - min_val) * i / num_lines)
		var label_text = "$%.2f" % price_value
		draw_string(
			ThemeDB.fallback_font,
			Vector2(x_offset - 35, y + 5),
			label_text,
			HORIZONTAL_ALIGNMENT_RIGHT,
			-1,
			12,
			color_text
		)

func draw_candlestick(x_pos, y_offset, chart_height, current_price, previous_price, min_price, max_price, width, quarter_index):
	"""Draw a single candlestick"""
	
	# Determine color based on price change
	var candle_color = color_neutral
	if current_price > previous_price:
		candle_color = color_up
	elif current_price < previous_price:
		candle_color = color_down
	
	# Calculate positions
	var price_range = max_price - min_price
	var open_y = y_offset + chart_height - ((previous_price - min_price) / price_range * chart_height)
	var close_y = y_offset + chart_height - ((current_price - min_price) / price_range * chart_height)
	
	# Add some volatility for wick (simulated high/low)
	var high_price = current_price + (abs(current_price - previous_price) * 0.3)
	var low_price = min(current_price, previous_price) - (abs(current_price - previous_price) * 0.2)
	
	var high_y = y_offset + chart_height - ((high_price - min_price) / price_range * chart_height)
	var low_y = y_offset + chart_height - ((low_price - min_price) / price_range * chart_height)
	
	var center_x = x_pos + (width / 2)
	
	# Draw wick (thin line for high/low)
	draw_line(
		Vector2(center_x, high_y),
		Vector2(center_x, low_y),
		candle_color,
		2.0
	)
	
	# Draw body (rectangle for open/close)
	var body_top = min(open_y, close_y)
	var body_bottom = max(open_y, close_y)
	var body_height = max(body_bottom - body_top, 2.0)  # Minimum height of 2 pixels
	
	draw_rect(
		Rect2(x_pos, body_top, width, body_height),
		candle_color,
		true
	)
	
	# Draw border around body
	draw_rect(
		Rect2(x_pos, body_top, width, body_height),
		candle_color.darkened(0.3),
		false,
		1.0
	)
	
	# Draw quarter label
	var quarter_label = "Q%d" % (quarter_index + 1)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(center_x - 10, y_offset + chart_height + 20),
		quarter_label,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		14,
		color_text
	)
	
	# Draw price label
	draw_string(
		ThemeDB.fallback_font,
		Vector2(center_x - 15, close_y - 10),
		"$%.0f" % current_price,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		11,
		candle_color
	)
