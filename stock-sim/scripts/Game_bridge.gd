extends Node2D

# This GDScript bridges to Python Game_manager
var python_manager

func _ready():
	# Try to load Python script
	var script_path = "res://scripts/Game_manager_test.py"
	if ResourceLoader.exists(script_path):
		var PythonScript = load(script_path)
		if PythonScript:
			python_manager = PythonScript.new()
			add_child(python_manager)
			print("✅ Python Game_manager loaded!")
		else:
			print("❌ Failed to load Python script")
	else:
		print("❌ Python script not found at: ", script_path)
	
	# Fallback - show something on screen
	var label = find_child("StockPrice", true, false)
	if label:
		label.set_text("Bridge Active - Click Buy!")

# Forward button calls to Python
func buy_stock(ticker="AAPL", shares=1):
	print("Buy button clicked")
	if python_manager and python_manager.has_method("buy_stock"):
		python_manager.buy_stock(ticker, shares)
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("Python manager not loaded!")

func sell_stock(ticker="AAPL", shares=1):
	print("Sell button clicked")
	if python_manager and python_manager.has_method("sell_stock"):
		python_manager.sell_stock(ticker, shares)

func hold_stock():
	print("Hold button clicked")
	if python_manager and python_manager.has_method("hold_stock"):
		python_manager.hold_stock()

func advance_quarter():
	print("Next Quarter button clicked")
	if python_manager and python_manager.has_method("advance_quarter"):
		python_manager.advance_quarter()
