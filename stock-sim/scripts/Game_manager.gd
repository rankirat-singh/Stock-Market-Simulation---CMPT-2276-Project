extends Node2D

# Simple GDScript game manager with tutorials
var cash: float = 10000.0
var current_quarter: int = 0
var max_quarters: int = 4
var current_stock: String = "AAPL"  # Currently selected stock
var stocks_owned: Dictionary = {"AAPL": 0, "MSFT": 0, "TSLA": 0}
var stock_prices: Dictionary = {
	"AAPL": [150.0, 160.0, 155.0, 170.0],
	"MSFT": [300.0, 290.0, 310.0, 320.0],
	"TSLA": [200.0, 220.0, 210.0, 240.0]
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
	create_tutorial_dialog()
	update_display()
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
	
	# Update chart if it exists
	var chart = find_child("CandlestickChart", true, false)
	if chart and chart.has_method("set_stock_data"):
		chart.call("set_stock_data", stock_prices[ticker])

func update_display():
	var label = find_child("StockPrice", true, false)
	if label:
		var current_price = stock_prices[current_stock][current_quarter]
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
				var value = stocks_owned[ticker] * stock_prices[ticker][current_quarter]
				holdings_text += "%s: %d shares ($%.2f)\n" % [ticker, stocks_owned[ticker], value]
		if holdings_text == "":
			holdings_text = "No stocks owned"
		stock_value_label.set_text(holdings_text.strip_edges())
	
	var portfolio_value_label = find_child("PortfolioValue", true, false)
	if portfolio_value_label:
		var total_value = cash
		for ticker in ["AAPL", "MSFT", "TSLA"]:
			total_value += stocks_owned[ticker] * stock_prices[ticker][current_quarter]
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
	dialog.dialog_text = "How many shares?\n\nCurrent price: $%.2f\nYou own: %d shares\nCash: $%.2f" % [stock_prices[ticker][current_quarter], stocks_owned[ticker], cash]
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
	var current_price = stock_prices[ticker][current_quarter]
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
		var current_price = stock_prices[ticker][current_quarter]
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
				total_value += stocks_owned[ticker] * stock_prices[ticker][current_quarter]
			var profit = total_value - 10000.0
			label.set_text("GAME OVER!\nFinal Value: $%.2f\nProfit: $%.2f" % [total_value, profit])
