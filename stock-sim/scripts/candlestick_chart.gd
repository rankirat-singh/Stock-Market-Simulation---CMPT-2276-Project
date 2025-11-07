extends Control

# Candlestick Chart - Draws actual stock price data with OHLC
# Attach this to a Control node in your scene

var price_data = []  # Array of OHLC dicts: [{open, high, low, close}, ...]
var chart_margin = 50       
var chart_margin_right = 20 
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
	price_data = [
		{"open": 150.0, "high": 155.0, "low": 148.0, "close": 152.0},
		{"open": 152.0, "high": 165.0, "low": 150.0, "close": 160.0},
		{"open": 160.0, "high": 162.0, "low": 153.0, "close": 155.0},
		{"open": 155.0, "high": 175.0, "low": 154.0, "close": 170.0}
	]
	queue_redraw()

func set_stock_data(prices: Array):
	"""Update chart with new stock prices (array of OHLC dicts)"""
	print("Chart received ", prices.size(), " candlesticks")
	if prices.size() > 0:
		print("First candle: ", prices[0])
	price_data = prices
	queue_redraw()

func _draw():
	if price_data.size() == 0:
		return
	
	var chart_area = get_size()
	var chart_width = chart_area.x - chart_margin - chart_margin_right 
	var chart_height = chart_area.y - (chart_margin * 2)
	
	# Find min and max prices for scaling (using high/low from OHLC)
	var min_price = INF
	var max_price = -INF
	
	for candle in price_data:
		if candle.has("high") and candle.has("low"):
			min_price = min(min_price, candle["low"])
			max_price = max(max_price, candle["high"])
	
	# Add some padding to the range
	var price_range = max_price - min_price
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
		var candle = price_data[i]
		var previous_candle = price_data[i - 1] if i > 0 else candle
		
		draw_candlestick(
			x_pos,
			chart_margin,
			chart_height,
			candle,
			previous_candle,
			min_price,
			max_price,
			actual_candle_width,
			i
		)
	
	# Draw border 
	# Top line
	draw_line(Vector2(chart_margin, chart_margin), Vector2(chart_margin + chart_width, chart_margin), color_grid, 2.0)
	# Right line
	draw_line(Vector2(chart_margin + chart_width, chart_margin), Vector2(chart_margin + chart_width, chart_margin + chart_height), color_grid, 2.0)
	# Bottom line
	draw_line(Vector2(chart_margin, chart_margin + chart_height), Vector2(chart_margin + chart_width, chart_margin + chart_height), color_grid, 2.0)

func draw_grid(x_offset, y_offset, width, height, min_val, max_val):
	"""Draw grid lines and price labels"""
	var num_lines = 5
	var step = height / num_lines
	
	# First pass: Draw all grid lines
	for i in range(num_lines + 1):
		var y = y_offset + (i * step)
		draw_line(
			Vector2(x_offset, y),
			Vector2(x_offset + width, y),
			color_grid,
			1.0
		)
	
	# Second pass: Draw all price labels
	for i in range(num_lines + 1):
		var y = y_offset + (i * step)
		var price_value = max_val - ((max_val - min_val) * i / num_lines)
		var label_text = "$%.2f" % price_value
		
		
		var label_size = ThemeDB.fallback_font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
		draw_rect(
			Rect2(x_offset - 38, y - 8, label_size.x + 6, label_size.y + 4),
			Color(0.1, 0.1, 0.15),  # Same as background
			true
		)
		
		# Draw price label
		draw_string(
			ThemeDB.fallback_font,
			Vector2(x_offset - 35, y + 5),
			label_text,
			HORIZONTAL_ALIGNMENT_RIGHT,
			-1,
			12,
			color_text
		)

func draw_candlestick(x_pos, y_offset, chart_height, candle, previous_candle, min_price, max_price, width, quarter_index):
	"""Draw a single candlestick with real OHLC data"""
	
	# Extract OHLC values
	var open_price = candle["open"]
	var high_price = candle["high"]
	var low_price = candle["low"]
	var close_price = candle["close"]
	
	# Determine color based on price change
	var candle_color = color_neutral
	if close_price > open_price:
		candle_color = color_up
	elif close_price < open_price:
		candle_color = color_down
	
	# Calculate positions
	var price_range = max_price - min_price
	var open_y = y_offset + chart_height - ((open_price - min_price) / price_range * chart_height)
	var close_y = y_offset + chart_height - ((close_price - min_price) / price_range * chart_height)
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
	
	# Draw week label (only every 3rd week to avoid clutter)
	if quarter_index % 3 == 0:
		var week_label = "W%d" % (quarter_index + 1)
		draw_string(
			ThemeDB.fallback_font,
			Vector2(center_x - 12, y_offset + chart_height + 20),
			week_label,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			10,
			color_text.darkened(0.3)
		)
	
	# Draw closing price label (only on every 2nd candle to reduce clutter)
	if quarter_index % 2 == 0 or width > 20:
		draw_string(
			ThemeDB.fallback_font,
			Vector2(center_x - 15, close_y - 10),
			"$%.0f" % close_price,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			9,
			candle_color
		)
