extends Node2D

# Simple GDScript game manager with tutorials
var cash: float = 10000.0
var current_quarter: int = 0
var max_quarters: int = 4
var stocks_owned: Dictionary = {"AAPL": 0, "MSFT": 0, "TSLA": 0}
var stock_prices: Dictionary = {
	"AAPL": [150.0, 160.0, 155.0, 170.0],
	"MSFT": [300.0, 290.0, 310.0, 320.0],
	"TSLA": [200.0, 220.0, 210.0, 240.0]
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

func update_display():
	var label = find_child("StockPrice", true, false)
	if label:
		var current_price = stock_prices["AAPL"][current_quarter]
		label.set_text("Cash: $%.2f\nAAPL: $%.2f\nQ%d/%d" % [cash, current_price, current_quarter + 1, max_quarters])

func buy_stock(ticker="AAPL", shares=1):
	print("Buy clicked: ", ticker)
	var current_price = stock_prices[ticker][current_quarter]
	var total_cost = current_price * shares
	
	if cash >= total_cost:
		cash -= total_cost
		stocks_owned[ticker] += shares
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("BOUGHT %dx %s @ $%.2f\nCash: $%.2f\nOwned: %d shares" % [shares, ticker, current_price, cash, stocks_owned[ticker]])
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("NOT ENOUGH CASH!\nNeed: $%.2f\nHave: $%.2f" % [total_cost, cash])

func sell_stock(ticker="AAPL", shares=1):
	print("Sell clicked: ", ticker)
	if stocks_owned[ticker] >= shares:
		var current_price = stock_prices[ticker][current_quarter]
		var total_value = current_price * shares
		cash += total_value
		stocks_owned[ticker] -= shares
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("SOLD %dx %s @ $%.2f\nCash: $%.2f\nOwned: %d shares" % [shares, ticker, current_price, cash, stocks_owned[ticker]])
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

