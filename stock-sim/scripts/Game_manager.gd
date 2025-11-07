extends Node2D

# Simple GDScript game manager with tutorials
var cash: float = 10000.0
var current_quarter: int = 0
var max_quarters: int = 4
var current_stock: String = "AAPL"  # Currently selected stock
var stocks_owned: Dictionary = {"AAPL": 0, "MSFT": 0, "TSLA": 0}
# Stock prices for each quarter with full OHLC data
# Format: {"ticker": [[Q1 candles], [Q2 candles], [Q3 candles], [Q4 candles]]}
# Each quarter contains multiple weekly candlesticks {open, high, low, close}
var stock_prices = {
	"AAPL": [
		# Quarter 1 - 12 weekly candlesticks
		[
			{"open": 224.62, "high": 228.66, "low": 221.50, "close": 225.12},
			{"open": 225.02, "high": 230.16, "low": 224.27, "close": 229.00},
			{"open": 228.88, "high": 235.69, "low": 225.71, "close": 234.93},
			{"open": 234.81, "high": 244.54, "low": 233.97, "close": 243.04},
			{"open": 242.91, "high": 250.80, "low": 241.75, "close": 247.96},
			{"open": 247.81, "high": 254.28, "low": 246.24, "close": 249.79},
			{"open": 248.04, "high": 260.10, "low": 245.69, "close": 255.59},
			{"open": 252.23, "high": 253.50, "low": 241.82, "close": 245.00},
			{"open": 242.98, "high": 245.55, "low": 229.72, "close": 233.28},
			{"open": 234.63, "high": 238.96, "low": 219.38, "close": 223.83},
			{"open": 224.74, "high": 240.19, "low": 221.41, "close": 239.36},
			{"open": 238.66, "high": 247.19, "low": 225.70, "close": 232.47},
		],
		# Quarter 2 - 12 weekly candlesticks
		[
			{"open": 231.28, "high": 236.96, "low": 227.20, "close": 236.87},
			{"open": 236.91, "high": 246.78, "low": 235.57, "close": 245.83},
			{"open": 245.95, "high": 250.00, "low": 237.06, "close": 237.30},
			{"open": 236.95, "high": 244.03, "low": 229.23, "close": 235.33},
			{"open": 235.10, "high": 241.37, "low": 208.42, "close": 209.68},
			{"open": 211.25, "high": 218.76, "low": 209.58, "close": 214.10},
			{"open": 211.56, "high": 225.02, "low": 211.28, "close": 223.85},
			{"open": 221.67, "high": 225.62, "low": 201.25, "close": 203.19},
			{"open": 193.89, "high": 200.61, "low": 169.21, "close": 190.42},
			{"open": 186.10, "high": 212.94, "low": 186.06, "close": 196.98},
			{"open": 193.26, "high": 209.75, "low": 189.81, "close": 209.28},
			{"open": 210.00, "high": 214.56, "low": 202.16, "close": 205.35},
		],
		# Quarter 3 - 12 weekly candlesticks
		[
			{"open": 203.10, "high": 204.10, "low": 193.25, "close": 198.53},
			{"open": 210.97, "high": 213.94, "low": 206.75, "close": 211.26},
			{"open": 207.91, "high": 209.48, "low": 193.46, "close": 195.27},
			{"open": 198.30, "high": 203.81, "low": 196.78, "close": 201.70},
			{"open": 201.35, "high": 206.24, "low": 200.02, "close": 201.45},
			{"open": 200.60, "high": 204.50, "low": 195.70, "close": 198.42},
			{"open": 197.20, "high": 203.44, "low": 195.07, "close": 200.30},
			{"open": 201.45, "high": 210.19, "low": 199.26, "close": 207.82},
			{"open": 208.91, "high": 216.23, "low": 207.22, "close": 211.14},
			{"open": 210.50, "high": 213.48, "low": 207.54, "close": 210.16},
			{"open": 210.57, "high": 215.78, "low": 209.59, "close": 214.15},
			{"open": 213.90, "high": 215.69, "low": 207.72, "close": 209.05},
		],
		# Quarter 4 - 14 weekly candlesticks
		[
			{"open": 208.49, "high": 215.38, "low": 201.50, "close": 213.25},
			{"open": 218.88, "high": 235.00, "low": 216.58, "close": 233.33},
			{"open": 234.06, "high": 235.12, "low": 225.77, "close": 226.01},
			{"open": 226.27, "high": 230.90, "low": 223.78, "close": 230.49},
			{"open": 230.82, "high": 239.90, "low": 226.97, "close": 239.78},
			{"open": 240.00, "high": 241.32, "low": 225.95, "close": 230.03},
			{"open": 229.22, "high": 241.22, "low": 229.02, "close": 237.88},
			{"open": 241.22, "high": 257.34, "low": 240.21, "close": 256.87},
			{"open": 254.09, "high": 258.79, "low": 253.01, "close": 257.13},
			{"open": 254.66, "high": 259.24, "low": 253.14, "close": 254.04},
			{"open": 254.94, "high": 256.38, "low": 244.00, "close": 247.45},
			{"open": 248.02, "high": 265.29, "low": 247.27, "close": 259.58},
			{"open": 261.19, "high": 274.14, "low": 259.18, "close": 271.40},
			{"open": 276.99, "high": 277.32, "low": 266.25, "close": 270.14},
		],
	],
	"MSFT": [
		# Placeholder data for Microsoft (using simplified weekly data)
		[
			{"open": 300.0, "high": 305.0, "low": 298.0, "close": 302.0},
			{"open": 302.0, "high": 308.0, "low": 300.0, "close": 305.0},
			{"open": 305.0, "high": 310.0, "low": 303.0, "close": 307.0},
		],
		[
			{"open": 307.0, "high": 310.0, "low": 285.0, "close": 290.0},
			{"open": 290.0, "high": 295.0, "low": 287.0, "close": 292.0},
			{"open": 292.0, "high": 298.0, "low": 290.0, "close": 295.0},
		],
		[
			{"open": 295.0, "high": 315.0, "low": 293.0, "close": 310.0},
			{"open": 310.0, "high": 318.0, "low": 308.0, "close": 315.0},
			{"open": 315.0, "high": 320.0, "low": 312.0, "close": 318.0},
		],
		[
			{"open": 318.0, "high": 328.0, "low": 315.0, "close": 320.0},
			{"open": 320.0, "high": 325.0, "low": 318.0, "close": 322.0},
			{"open": 322.0, "high": 330.0, "low": 320.0, "close": 325.0},
		],
	],
	"TSLA": [
		# Placeholder data for Tesla (using simplified weekly data)
		[
			{"open": 200.0, "high": 205.0, "low": 198.0, "close": 203.0},
			{"open": 203.0, "high": 208.0, "low": 201.0, "close": 206.0},
			{"open": 206.0, "high": 210.0, "low": 204.0, "close": 208.0},
		],
		[
			{"open": 208.0, "high": 225.0, "low": 207.0, "close": 220.0},
			{"open": 220.0, "high": 228.0, "low": 218.0, "close": 223.0},
			{"open": 223.0, "high": 230.0, "low": 221.0, "close": 227.0},
		],
		[
			{"open": 227.0, "high": 230.0, "low": 210.0, "close": 215.0},
			{"open": 215.0, "high": 220.0, "low": 212.0, "close": 217.0},
			{"open": 217.0, "high": 222.0, "low": 214.0, "close": 219.0},
		],
		[
			{"open": 219.0, "high": 245.0, "low": 217.0, "close": 240.0},
			{"open": 240.0, "high": 248.0, "low": 238.0, "close": 243.0},
			{"open": 243.0, "high": 250.0, "low": 241.0, "close": 247.0},
		],
	]
}
var stock_names: Dictionary = {
	"AAPL": "Apple Inc.",
	"MSFT": "Microsoft Corp.",
	"TSLA": "Tesla Inc."
}

# Tutorial data
var tutorials: Dictionary = {
	"welcome": {
		"title": "Welcome to Stock Trading Simulator!",
		"content": "You start with $10,000 cash and have 4 quarters to grow your portfolio.\n\nYour goal: Make smart trades to maximize your profit!\n\n• Buy stocks when prices are low\n• Sell when prices are high\n• Use Hold to skip a quarter\n• Watch the candlestick chart for trends"
	},
	"sma": {
		"title": "Understanding Market Trends",
		"content": "The Simple Moving Average (SMA) helps identify trends:\n\n• Green candlesticks = Price went UP\n• Red candlesticks = Price went DOWN\n• Tall candles = Big price changes\n• Small candles = Stable prices\n\nLook for patterns to predict future moves!"
	},
	"sentiment": {
		"title": "Market Sentiment Analysis",
		"content": "Market sentiment affects stock prices:\n\n• High Sentiment (0.7-1.0) = Bullish (prices likely to rise)\n• Medium Sentiment (0.4-0.6) = Neutral\n• Low Sentiment (0.0-0.3) = Bearish (prices likely to fall)\n\nCheck the news to gauge sentiment!"
	},
	"diversification": {
		"title": "Portfolio Diversification",
		"content": "Don't put all your eggs in one basket!\n\n• Spread investments across multiple stocks\n• Reduces risk if one stock crashes\n• Balances high-risk and stable stocks\n\nYou have AAPL, MSFT, and TSLA available."
	},
	"quarter_strategy": {
		"title": "Quarter-by-Quarter Strategy",
		"content": "Plan your moves across 4 quarters:\n\n• Q1: Research and buy promising stocks\n• Q2-Q3: Monitor trends, adjust holdings\n• Q4: Sell for maximum profit\n\nUse the Hold button if you want to wait!"
	}
}

var tutorial_dialog: AcceptDialog = null

func _ready():
	print("=== GDScript Game Manager Ready ===")
	print("Starting cash: $", cash)
	print("AAPL Q1 has ", stock_prices["AAPL"][0].size(), " candlesticks")
	print("First candle: ", stock_prices["AAPL"][0][0])
	create_tutorial_dialog()
	update_display()
	
	# Initialize chart with current quarter's data
	var chart = find_child("CandlestickChart", true, false)
	if chart and chart.has_method("set_stock_data"):
		print("Loading initial chart data for ", current_stock, " Q", current_quarter + 1)
		var quarter_data = stock_prices[current_stock][current_quarter]
		print("Passing ", quarter_data.size(), " candles to chart")
		chart.call("set_stock_data", quarter_data)
	else:
		print("ERROR: Chart not found or doesn't have set_stock_data method!")
	
	# Show welcome tutorial after a short delay
	call_deferred("show_tutorial", "welcome")

func create_tutorial_dialog():
	"""Create a popup dialog for tutorials"""
	tutorial_dialog = AcceptDialog.new()
	tutorial_dialog.title = "Tutorial"
	tutorial_dialog.dialog_text = ""
	tutorial_dialog.ok_button_text = "Got it!"
	tutorial_dialog.set_flag(Window.FLAG_RESIZE_DISABLED, false)
	tutorial_dialog.size = Vector2(600, 400)
	add_child(tutorial_dialog)

func show_tutorial(tutorial_key: String):
	"""Show a tutorial popup"""
	if tutorial_key in tutorials and tutorial_dialog:
		var tut = tutorials[tutorial_key]
		tutorial_dialog.title = tut["title"]
		tutorial_dialog.dialog_text = tut["content"]
		tutorial_dialog.popup_centered()
		print("Showing tutorial: ", tutorial_key)

func show_tutorial_menu():
	"""Show menu to select which tutorial to view"""
	var menu_dialog = AcceptDialog.new()
	menu_dialog.title = " Tutorials"
	var menu_text = "Choose a topic to learn about:\n\n"
	menu_text += "1. Welcome - Game basics\n"
	menu_text += "2. Market Trends - Understanding charts\n"
	menu_text += "3. Sentiment Analysis - News & feelings\n"
	menu_text += "4. Diversification - Spread your risk\n"
	menu_text += "5. Quarter Strategy - Plan your moves\n\n"
	menu_text += "Click buttons below to view tutorials!"
	
	menu_dialog.dialog_text = menu_text
	menu_dialog.ok_button_text = "Close"
	menu_dialog.size = Vector2(500, 400)
	
	# Add custom buttons for each tutorial
	menu_dialog.add_button("Welcome", false, "welcome")
	menu_dialog.add_button("Trends", false, "sma")
	menu_dialog.add_button("Sentiment", false, "sentiment")
	menu_dialog.add_button("Diversify", false, "diversification")
	menu_dialog.add_button("Strategy", false, "quarter_strategy")
	
	menu_dialog.custom_action.connect(func(action): show_tutorial(action))
	
	add_child(menu_dialog)
	menu_dialog.popup_centered()
	# Clean up after closing
	menu_dialog.confirmed.connect(func(): menu_dialog.queue_free())
	menu_dialog.canceled.connect(func(): menu_dialog.queue_free())

func select_stock(ticker: String):
	"""Switch to viewing a different stock"""
	current_stock = ticker
	print("Selected stock: ", ticker)
	
	# Update stock name labels
	var stock_name_label = find_child("StockName", true, false)
	if stock_name_label:
		stock_name_label.set_text(stock_names[ticker])
	
	var stock_code_label = find_child("StockCode", true, false)
	if stock_code_label:
		stock_code_label.set_text(ticker)
	
	update_display()
	
	# Update chart if it exists - pass current quarter's candlesticks
	var chart = find_child("CandlestickChart", true, false)
	if chart and chart.has_method("set_stock_data"):
		chart.call("set_stock_data", stock_prices[ticker][current_quarter])

func update_display():
	var label = find_child("StockPrice", true, false)
	if label:
		# Get the last candlestick's close price from current quarter
		var quarter_candles = stock_prices[current_stock][current_quarter]
		var current_price = quarter_candles[-1]["close"]
		label.set_text("Cash: $%.2f\nPrice: $%.2f | Owned: %d\nQ%d/%d" % [cash, current_price, stocks_owned[current_stock], current_quarter + 1, max_quarters])
	
	# Update Portfolio View
	update_portfolio_view()

func update_portfolio_view():
	"""Update the Portfolio View tab with current holdings"""
	var cash_value_label = find_child("CashHoldingsValue", true, false)
	if cash_value_label:
		cash_value_label.set_text("$%.2f" % cash)
	
	var stock_value_label = find_child("StockHoldingsValue", true, false)
	if stock_value_label:
		var holdings_text = ""
		for ticker in ["AAPL", "MSFT", "TSLA"]:
			if stocks_owned[ticker] > 0:
				var quarter_candles = stock_prices[ticker][current_quarter]
				var current_price = quarter_candles[-1]["close"]
				var value = stocks_owned[ticker] * current_price
				holdings_text += "%s: %d shares ($%.2f)\n" % [ticker, stocks_owned[ticker], value]
		if holdings_text == "":
			holdings_text = "No stocks owned"
		stock_value_label.set_text(holdings_text.strip_edges())
	
	var portfolio_value_label = find_child("PortfolioValue", true, false)
	if portfolio_value_label:
		var total_value = cash
		for ticker in ["AAPL", "MSFT", "TSLA"]:
			var quarter_candles = stock_prices[ticker][current_quarter]
			var current_price = quarter_candles[-1]["close"]
			total_value += stocks_owned[ticker] * current_price
		var profit = total_value - 10000.0
		portfolio_value_label.set_text("$%.2f\n(Profit: $%.2f)" % [total_value, profit])

func buy_stock(ticker="", shares=1):
	if ticker == "":
		ticker = current_stock
	
	# Show quantity dialog
	show_quantity_dialog("buy", ticker)

func sell_stock(ticker="", shares=1):
	if ticker == "":
		ticker = current_stock
	
	# Show quantity dialog
	show_quantity_dialog("sell", ticker)

func show_quantity_dialog(action: String, ticker: String):
	"""Show dialog to input number of shares"""
	var dialog = ConfirmationDialog.new()
	dialog.title = action.capitalize() + " " + ticker
	var quarter_candles = stock_prices[ticker][current_quarter]
	var current_price = quarter_candles[-1]["close"]
	dialog.dialog_text = "How many shares?\n\nCurrent price: $%.2f\nYou own: %d shares\nCash: $%.2f" % [current_price, stocks_owned[ticker], cash]
	dialog.ok_button_text = action.capitalize()
	dialog.cancel_button_text = "Cancel"
	
	# Add SpinBox for quantity input
	var vbox = VBoxContainer.new()
	var label = Label.new()
	label.text = "Quantity:"
	var spinbox = SpinBox.new()
	spinbox.min_value = 1
	spinbox.max_value = 999
	spinbox.value = 1
	spinbox.step = 1
	spinbox.allow_greater = false
	spinbox.allow_lesser = false
	
	vbox.add_child(label)
	vbox.add_child(spinbox)
	dialog.add_child(vbox)
	
	# Connect confirmation
	dialog.confirmed.connect(func():
		var quantity = int(spinbox.value)
		if action == "buy":
			execute_buy(ticker, quantity)
		else:
			execute_sell(ticker, quantity)
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	
	add_child(dialog)
	dialog.popup_centered()

func execute_buy(ticker: String, shares: int):
	"""Actually execute the buy"""
	print("Buy clicked: ", ticker, " x", shares)
	var quarter_candles = stock_prices[ticker][current_quarter]
	var current_price = quarter_candles[-1]["close"]
	var total_cost = current_price * shares
	
	if cash >= total_cost:
		cash -= total_cost
		stocks_owned[ticker] += shares
		update_display()
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("NOT ENOUGH CASH!\nNeed: $%.2f\nHave: $%.2f" % [total_cost, cash])

func execute_sell(ticker: String, shares: int):
	"""Actually execute the sell"""
	print("Sell clicked: ", ticker, " x", shares)
	if stocks_owned[ticker] >= shares:
		var quarter_candles = stock_prices[ticker][current_quarter]
		var current_price = quarter_candles[-1]["close"]
		var total_value = current_price * shares
		cash += total_value
		stocks_owned[ticker] -= shares
		update_display()
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("DON'T OWN ENOUGH!\nHave: %d shares\nNeed: %d" % [stocks_owned[ticker], shares])

func hold_stock():
	print("Hold clicked")
	var label = find_child("StockPrice", true, false)
	if label:
		label.set_text("HOLD - Skipped action\nCash: $%.2f" % cash)

func advance_quarter():
	print("Next Quarter clicked")
	if current_quarter < max_quarters - 1:
		current_quarter += 1
		update_display()
		
		# Update chart with new quarter's candlesticks
		var chart = find_child("CandlestickChart", true, false)
		if chart and chart.has_method("set_stock_data"):
			chart.call("set_stock_data", stock_prices[current_stock][current_quarter])
		
		# Show strategy tutorial on Q2
		if current_quarter == 1:
			call_deferred("show_tutorial", "quarter_strategy")
		
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("QUARTER %d/%d\nCash: $%.2f" % [current_quarter + 1, max_quarters, cash])
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			var total_value = cash
			for ticker in stocks_owned:
				var quarter_candles = stock_prices[ticker][current_quarter]
				var current_price = quarter_candles[-1]["close"]
				total_value += stocks_owned[ticker] * current_price
			var profit = total_value - 10000.0
			label.set_text("GAME OVER!\nFinal Value: $%.2f\nProfit: $%.2f" % [total_value, profit])
