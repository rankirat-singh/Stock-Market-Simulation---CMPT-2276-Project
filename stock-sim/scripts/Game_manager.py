from py4godot.methods import private
from py4godot.signals import signal, SignalArg
from py4godot.classes import gdclass
from py4godot.classes.core import Vector3
from py4godot.classes.Node import Node

import sys
import os

# Add scripts directory to Python path so we can import Stock and Portfolio
scripts_dir = os.path.dirname(os.path.abspath(__file__))
if scripts_dir not in sys.path:
	sys.path.insert(0, scripts_dir)

from Stock import Stock
from Portfolio import Portfolio

@gdclass
class Game_manager(Node):
	"""Main game controller for the stock trading simulator"""
	
	# Game state properties
	current_quarter: int = 0
	max_quarters: int = 4
	current_stock_ticker: str = "AAPL"
	
	def _ready(self) -> None:
		"""Initialize game when scene loads"""
		try:
			print("=== Game Manager _ready() starting ===")
			
			# Initialize portfolio with $10,000 starting cash
			self.portfolio = Portfolio(10000)
			print(f"✓ Portfolio initialized: ${self.portfolio.cash}")
			
			# Initialize stocks
			self.stocks = {}
			self._initialize_stocks()
			print(f"✓ Stocks initialized: {list(self.stocks.keys())}")
			
			# Initialize managers (optional - won't crash if missing)
			self.tutorial_manager = None
			self.ui_manager = None
			self.pending_action = None
			print("✓ Managers initialized")
			
			print(f"✓ Game initialized: Quarter {self.current_quarter + 1}/{self.max_quarters}")
			print(f"✓ Starting cash: ${self.portfolio.cash}")
			
			# Update UI with initial values
			self.call_deferred("_update_ui")
			self.call_deferred("_update_quarter_display")
			
			print("=== Game Manager _ready() complete ===")
			
		except Exception as e:
			print(f" ERROR in _ready(): {e}")
			import traceback
			traceback.print_exc()
	
	def _process(self, delta: float) -> None:
		pass  # Game is turn-based, no continuous updates needed
	
	@private
	def _initialize_stocks(self):
		"""Create the 3 stocks with 4 quarters of data each"""
		# Apple Inc.
		self.stocks["AAPL"] = Stock(
			name="Apple Inc.",
			ticker="AAPL",
			price_history=[150.0, 160.0, 155.0, 170.0],
			news_history=[
				"Strong Q1 earnings beat expectations",
				"New iPhone launch announced",
				"Market correction affects tech stocks",
				"Record holiday sales reported"
			],
			sentiment_history=[0.8, 0.9, 0.3, 0.95]
		)
		
		# Microsoft Corp.
		self.stocks["MSFT"] = Stock(
			name="Microsoft Corp.",
			ticker="MSFT",
			price_history=[300.0, 290.0, 310.0, 320.0],
			news_history=[
				"Cloud services show strong growth",
				"Minor setback in quarterly revenue",
				"AI breakthrough announced",
				"Major enterprise contracts signed"
			],
			sentiment_history=[0.7, 0.4, 0.85, 0.9]
		)
		
		# Tesla Inc.
		self.stocks["TSLA"] = Stock(
			name="Tesla Inc.",
			ticker="TSLA",
			price_history=[200.0, 220.0, 240.0, 230.0],
			news_history=[
				"Production capacity increased",
				"New factory expansion announced",
				"Becomes market leader in EV sales",
				"Increased competition in EV market"
			],
			sentiment_history=[0.6, 0.8, 0.9, 0.5]
		)
	
	# Public methods for UI to call
	def buy_stock(self, ticker: str = "AAPL", shares: int = 1) -> bool:
		"""Buy specified number of shares of the stock"""
		if ticker not in self.stocks:
			print(f"Error: Stock {ticker} not found")
			return False
		
		if shares <= 0:
			print(f"Error: Invalid share quantity {shares}")
			return False
		
		stock = self.stocks[ticker]
		total_cost = stock.get_current_price() * shares
		
		# Check if we can afford it
		if self.portfolio.cash < total_cost:
			print(f"Not enough cash to buy {shares} shares of {ticker} (need ${total_cost:.2f}, have ${self.portfolio.cash:.2f})")
			return False
		
		# Buy shares one at a time
		success_count = 0
		for i in range(shares):
			if self.portfolio.buy_stock(stock, 1):
				success_count += 1
			else:
				break
		
		if success_count > 0:
			print(f"Bought {success_count} share(s) of {ticker} at ${stock.get_current_price():.2f} each")
			self._update_ui()
		
		return success_count == shares
	
	def sell_stock(self, ticker: str = "AAPL", shares: int = 1) -> bool:
		"""Sell specified number of shares of the stock"""
		if ticker not in self.stocks:
			print(f"Error: Stock {ticker} not found")
			return False
		
		if shares <= 0:
			print(f"Error: Invalid share quantity {shares}")
			return False
		
		owned_shares = self.portfolio.get_shares_owned(ticker)
		if owned_shares < shares:
			print(f"You don't own enough shares of {ticker} (have {owned_shares}, trying to sell {shares})")
			return False
		
		stock = self.stocks[ticker]
		
		# Sell shares one at a time
		success_count = 0
		for i in range(shares):
			if self.portfolio.sell_stock(stock, 1):
				success_count += 1
			else:
				break
		
		if success_count > 0:
			print(f"Sold {success_count} share(s) of {ticker} at ${stock.get_current_price():.2f} each")
			self._update_ui()
		
		return success_count == shares
	
	def hold_stock(self, ticker: str = "AAPL"):
		"""Hold position (do nothing)"""
		print(f"Holding position on {ticker}")
		self._update_ui()
	
	def advance_quarter(self):
		"""Move to the next quarter"""
		if self.current_quarter < self.max_quarters - 1:
			self.current_quarter += 1
			for stock in self.stocks.values():
				stock.advance_quarter()
			print(f"Advanced to Quarter {self.current_quarter + 1}")
			self._update_ui()  # Update UI with new quarter prices
			self._update_quarter_display()  # Update quarter label
		else:
			print("Game Over!")
			self._show_end_game()
	
	def _update_quarter_display(self):
		"""Update the quarter indicator in UI"""
		root = self.get_parent()
		if not root:
			return
		
		try:
			quarter_label = root.find_child("QuarterLabel", True, False)
			if quarter_label:
				quarter_label.set_text(f"Quarter {self.current_quarter + 1} of {self.max_quarters}")
				print(f"✅ Updated quarter display: Q{self.current_quarter + 1}/{self.max_quarters}")
			else:
				print("⚠️ QuarterLabel not found in scene")
		except Exception as e:
			print(f"Error updating quarter display: {e}")
	
	def _show_end_game(self):
		"""Show end game results"""
		total_value = self.portfolio.get_total_value(self.stocks)
		profit = self.portfolio.get_profit_loss(self.stocks)
		profit_pct = self.portfolio.get_profit_loss_percent(self.stocks)
		
		print("\n" + "="*60)
		print("GAME OVER!")
		print("="*60)
		print(f"Final Portfolio Value: ${total_value:.2f}")
		print(f"Profit/Loss: ${profit:.2f} ({profit_pct:+.2f}%)")
		if profit > 0:
			print("🎉 Congratulations! You made a profit!")
		else:
			print("📉 Better luck next time!")
		print("="*60)
	
	def is_game_over(self) -> bool:
		"""Check if all quarters are complete"""
		return self.current_quarter >= self.max_quarters - 1
	
	def get_portfolio_value(self) -> float:
		"""Get total portfolio value (cash + stocks)"""
		return self.portfolio.get_total_value(self.stocks)
	
	def get_profit_loss(self) -> float:
		"""Get profit/loss amount"""
		return self.portfolio.get_profit_loss(self.stocks)
	
	def get_profit_loss_percent(self) -> float:
		"""Get profit/loss percentage"""
		return self.portfolio.get_profit_loss_percent(self.stocks)
	
	def did_win(self) -> bool:
		"""Check if player made a profit"""
		return self.get_profit_loss() > 0
	
	def reset_game(self):
		"""Reset game to initial state"""
		self.current_quarter = 0
		self.portfolio.reset()
		for stock in self.stocks.values():
			stock.reset()
		if self.tutorial_manager:
			self.tutorial_manager.reset_tutorials()
		print("Game reset!")
		self._update_ui()
	
	def show_welcome_tutorial(self):
		"""Show welcome tutorial on game start"""
		if self.tutorial_manager:
			self.tutorial_manager.show_tutorial("welcome")
	
	def show_tutorial(self, tutorial_key: str):
		"""Show a specific tutorial"""
		if self.tutorial_manager:
			self.tutorial_manager.show_tutorial(tutorial_key)
		else:
			print(f"Tutorial '{tutorial_key}' requested but TutorialManager not found")
	
	def get_stock_info(self, ticker: str) -> dict:
		"""Get all information about a stock for display"""
		if ticker not in self.stocks:
			return {}
		
		stock = self.stocks[ticker]
		return {
			"name": stock.name,
			"ticker": ticker,
			"current_price": stock.get_current_price(),
			"previous_price": stock.get_previous_price(),
			"price_change": stock.get_price_change_percent(),
			"trend": stock.get_trend_symbol(),
			"news": stock.news_history[stock.current_quarter] if stock.current_quarter < len(stock.news_history) else "",
			"sentiment": stock.sentiment_history[stock.current_quarter] if stock.current_quarter < len(stock.sentiment_history) else 0.5,
			"owned_shares": self.portfolio.get_shares_owned(ticker)
		}
	
	def update_chart_for_stock(self, ticker: str = "AAPL"):
		"""Update the UI to show a specific stock"""
		if ticker in self.stocks:
			self.current_stock_ticker = ticker
			self._update_ui()
			print(f" Switched view to {ticker}")
		else:
			print(f" Stock {ticker} not found")
	
	
	@private
	def _update_ui(self):
		"""Update all UI elements with current game state"""
		try:
			print("=== _update_ui() starting ===")
			
			# Find UI nodes in the scene
			root = self.get_parent()
			if not root:
				print("⚠ No parent node found")
				return
			
			current_stock = self.stocks[self.current_stock_ticker]
			
			# Update candlestick chart if it exists
			try:
				chart = root.find_child("CandlestickChart", True, False)
				if chart and chart.has_method("set_stock_data"):
					chart.call("set_stock_data", current_stock.price_history)
					print(f"✅ Updated candlestick chart for {self.current_stock_ticker}")
			except Exception as e:
				print(f"⚠ Chart update failed: {e}")
			
			# Update Stock View
			try:
				stock_view = root.find_child("Stock View", True, False)
				if stock_view:
					# Update Name and Code
					name_label = stock_view.find_child("StockName", True, False)
					if name_label:
						name_label.set_text(current_stock.name)
						
					code_label = stock_view.find_child("StockCode", True, False)
					if code_label:
						code_label.set_text(current_stock.ticker)

					# Update Price
					stock_price_label = stock_view.find_child("StockPrice", True, False)
					if stock_price_label:
						current_price = current_stock.get_current_price()
						stock_price_label.set_text(f"{current_price:.2f}USD")
						
					# Update Data Panel
					sma_label = stock_view.find_child("Value_SMA", True, False)
					if sma_label:
						sma = current_stock.get_sma(3)
						text = f"${sma:.2f}" if sma else "N/A"
						sma_label.set_text(text)
						
					vol_label = stock_view.find_child("Value_Vol", True, False)
					if vol_label:
						vol = current_stock.get_volatility()
						vol_label.set_text(f"{vol:.2f}")
						
					sent_label = stock_view.find_child("Value_Sent", True, False)
					if sent_label:
						sent = current_stock.get_current_sentiment()
						sent_label.set_text(f"{sent:.2f}")
						
					print(f"✓ Updated Stock View for {self.current_stock_ticker}")
			except Exception as e:
				print(f"⚠ Error updating Stock View: {e}")
			
<<<<<<< HEAD
			print("=== _update_ui() co
=======
			print("=== _u