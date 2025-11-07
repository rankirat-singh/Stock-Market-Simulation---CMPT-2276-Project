
from py4godot.classes import gdclass
from py4godot.classes.Node import Node

import sys
import os

# Add scripts directory to Python path
scripts_dir = os.path.dirname(os.path.abspath(__file__))
if scripts_dir not in sys.path:
	sys.path.insert(0, scripts_dir)

from Stock import Stock
from Portfolio import Portfolio

@gdclass
class Game_manager(Node):
	"""Minimal test version"""
	
	current_quarter: int = 0
	max_quarters: int = 4
	
	def _ready(self) -> None:
		"""Initialize"""
		self.portfolio = Portfolio(10000)
		self.stocks = {}
		self.stocks["AAPL"] = Stock(
			name="Apple Inc.",
			ticker="AAPL",
			price_history=[150.0, 160.0, 155.0, 170.0],
			news_history=["Q1", "Q2", "Q3", "Q4"],
			sentiment_history=[0.8, 0.9, 0.3, 0.95]
		)
		
		# Find label for feedback
		root = self.get_parent()
		if root:
			self.label = root.find_child("StockPrice", True, False)
			if self.label:
				self.label.set_text(f"READY! Cash: ${self.portfolio.cash:.2f}")
	
	def _process(self, delta: float) -> None:
		pass
	
	def buy_stock(self, ticker="AAPL", shares=1):
		if not hasattr(self, 'label') or not self.label:
			return
		stock = self.stocks[ticker]
		price = stock.get_current_price()
		total = price * shares
		if self.portfolio.cash >= total:
			self.portfolio.cash -= total
			self.label.set_text(f"BOUGHT {shares}x {ticker}\n${price:.2f} each\nCash: ${self.portfolio.cash:.2f}")
		else:
			self.label.set_text(f"NOT ENOUGH CASH\nNeed ${total:.2f}\nHave ${self.portfolio.cash:.2f}")
	
	def sell_stock(self, ticker="AAPL", shares=1):
		if hasattr(self, 'label') and self.label:
			self.label.set_text(f"SELL clicked\n(not implemented)")
	
	def hold_stock(self):
		if hasattr(self, 'label') and self.label:
			self.label.set_text(f"HOLD clicked\nCash: ${self.portfolio.cash:.2f}")
	
	def advance_quarter(self):
		self.current_quarter += 1
		if hasattr(self, 'label') and self.label:
			self.label.set_text(f"NEXT QUARTER\nQ{self.current_quarter + 1}/{self.max_quarters}\nCash: ${self.portfolio.cash:.2f}")
