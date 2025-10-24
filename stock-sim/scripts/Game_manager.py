
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
	
	def _ready(self) -> None:
		"""Initialize game when scene loads"""
		# Initialize portfolio with $10,000 starting cash
		self.portfolio = Portfolio(10000)
		
		# Initialize stocks
		self.stocks = {}
		self._initialize_stocks()
		
		print(f"Game initialized: Quarter {self.current_quarter + 1}/{self.max_quarters}")
		print(f"Starting cash: ${self.portfolio.cash}")
		
		# Update UI with initial values
		self.call_deferred("_update_ui")
	
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
	def buy_stock(self, ticker: str = "AAPL") -> bool:
		"""Buy 1 share of the specified stock"""
		if ticker not in self.stocks:
			print(f"Error: Stock {ticker} not found")
			return False
		
		stock = self.stocks[ticker]
		success = self.portfolio.buy_stock(stock, 1)
		
		if success:
			print(f"Bought 1 share of {ticker} at ${stock.get_current_price()}")
			self._update_ui()
		else:
			print(f"Not enough cash to buy {ticker}")
		
		return success
	
	def sell_stock(self, ticker: str = "AAPL") -> bool:
		"""Sell 1 share of the specified stock"""
		if ticker not in self.stocks:
			print(f"Error: Stock {ticker} not found")
			return False
		
		stock = self.stocks[ticker]
		success = self.portfolio.sell_stock(stock, 1)
		
		if success:
			print(f"Sold 1 share of {ticker} at ${stock.get_current_price()}")
			self._update_ui()
		else:
			print(f"You don't own any shares of {ticker}")
		
		return success
	
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
		else:
			print("Game Over!")
			# add end game logic here later
	
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
		print("Game reset!")
		self._update_ui()
	
	@private
	def _update_ui(self):
		"""Update all UI elements with current game state"""
		# Find UI nodes in the scene
		root = self.get_parent()
		if not root:
			return
		
		# Update Stock View - Stock Price Display
		try:
			stock_view = root.find_child("Stock View", True, False)
			if stock_view:
				print(f"Found Stock View!")
				stock_price_label = stock_view.find_child("StockPrice", True, False)
				if stock_price_label:
					apple_stock = self.stocks["AAPL"]
					current_price = apple_stock.get_current_price()
					stock_price_label.set_text(f"{current_price:.2f}USD")
					print(f" Updated price to: ${current_price:.2f}")
				else:
					print(" Could not find StockPrice label!")
			else:
				print(" Could not find Stock View!")
		except Exception as e:
			print(f"Error updating Stock View: {e}")
		
		# Update Portfolio View
		try:
			portfolio_view = root.find_child("Portfolio View", True, False)
			if portfolio_view:
				# Update cash holdings
				cash_value = portfolio_view.find_child("CashHoldingsValue", True, False)
				if cash_value:
					cash_value.set_text(f"{self.portfolio.cash:.2f} USD")
				
				# Update stock holdings
				stock_value = portfolio_view.find_child("StockHoldingsValue", True, False)
				if stock_value:
					holdings_text = ""
					for ticker in ["AAPL", "MSFT", "TSLA"]:
						shares = self.portfolio.get_shares_owned(ticker)
						if shares > 0:
							stock = self.stocks[ticker]
							value = shares * stock.get_current_price()
							holdings_text += f"{ticker}: {shares} shares ({value:.2f} USD)\n"
					
					if holdings_text == "":
						holdings_text = "No stocks owned"
					stock_value.set_text(holdings_text.strip())
				
				# Update total portfolio value
				portfolio_value_label = portfolio_view.find_child("PortfolioValue", True, False)
				if portfolio_value_label:
					total_value = self.portfolio.get_total_value(self.stocks)
					portfolio_value_label.set_text(f"{total_value:.2f} USD")
		except Exception as e:
			print(f"Error updating Portfolio View: {e}")
		
		print(f"UI Updated - Cash: ${self.portfolio.cash:.2f}, Portfolio Value: ${self.portfolio.get_total_value(self.stocks):.2f}")


	def sell_stock(self):
		pass
