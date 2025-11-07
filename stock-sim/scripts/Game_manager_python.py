
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
	"""Main game controller with built-in tutorials"""
	
	current_quarter: int = 0
	max_quarters: int = 4
	
	def _ready(self) -> None:
		"""Initialize game"""
		print("=" * 60)
		print("PYTHON Game_manager _ready() START")
		print("=" * 60)
		
		try:
			# Initialize portfolio with $10,000
			self.portfolio = Portfolio(10000)
			print(f"✅ Portfolio created: ${self.portfolio.cash}")
			
			# Initialize stocks
			self.stocks = {}
			self._initialize_stocks()
			print(f"✅ Stocks initialized: {list(self.stocks.keys())}")
			
			# Find label for feedback
			root = self.get_parent()
			print(f"✅ Root node: {root.get_name() if root else 'None'}")
			
			if root:
				self.label = root.find_child("StockPrice", True, False)
				if self.label:
					self.label.set_text(f"Ready! Cash: ${self.portfolio.cash:.2f}")
					print("✅ Label found and updated")
				else:
					print("⚠️ StockPrice label not found")
			
			print("✅ _ready() complete - calling show_tutorial")
			# Show welcome tutorial
			self.call_deferred("show_tutorial", "welcome")
			
		except Exception as e:
			print(f"❌ ERROR in _ready(): {e}")
			import traceback
			traceback.print_exc()
	
	def _process(self, delta: float) -> None:
		pass
	
	def _initialize_stocks(self):
		"""Create the 3 stocks"""
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
		
		self.stocks["TSLA"] = Stock(
			name="Tesla Inc.",
			ticker="TSLA",
			price_history=[200.0, 220.0, 210.0, 240.0],
			news_history=[
				"Production capacity increased",
				"New factory expansion announced",
				"Becomes market leader in EV sales",
				"Increased competition in EV market"
			],
			sentiment_history=[0.6, 0.8, 0.9, 0.5]
		)
	
	def buy_stock(self, ticker="AAPL", shares=1):
		"""Buy stock"""
		print(f"🔔 buy_stock called: {ticker} x{shares}")
		
		if not hasattr(self, 'label') or not self.label:
			print("⚠️ No label available")
			return
		
		stock = self.stocks[ticker]
		total_cost = stock.get_current_price() * shares
		
		if self.portfolio.cash >= total_cost:
			# Buy using portfolio method
			success = True
			for i in range(shares):
				if not self.portfolio.buy_stock(stock, 1):
					success = False
					break
			
			if success:
				owned = self.portfolio.get_shares_owned(ticker)
				self.label.set_text(f"BOUGHT {shares}x {ticker}\n${stock.get_current_price():.2f} each\nCash: ${self.portfolio.cash:.2f}\nOwned: {owned}")
				print(f"✅ Bought {shares}x {ticker}")
		else:
			self.label.set_text(f"NOT ENOUGH CASH\nNeed ${total_cost:.2f}\nHave ${self.portfolio.cash:.2f}")
			print(f"❌ Not enough cash")
	
	def sell_stock(self, ticker="AAPL", shares=1):
		"""Sell stock"""
		if not hasattr(self, 'label') or not self.label:
			return
		
		owned = self.portfolio.get_shares_owned(ticker)
		if owned >= shares:
			stock = self.stocks[ticker]
			success = True
			for i in range(shares):
				if not self.portfolio.sell_stock(stock, 1):
					success = False
					break
			
			if success:
				owned_now = self.portfolio.get_shares_owned(ticker)
				self.label.set_text(f"SOLD {shares}x {ticker}\n${stock.get_current_price():.2f} each\nCash: ${self.portfolio.cash:.2f}\nOwned: {owned_now}")
		else:
			self.label.set_text(f"DON'T OWN ENOUGH\nHave {owned}\nNeed {shares}")
	
	def hold_stock(self):
		"""Hold position"""
		if hasattr(self, 'label') and self.label:
			self.label.set_text(f"HOLD - Skipped\nCash: ${self.portfolio.cash:.2f}")
	
	def advance_quarter(self):
		"""Next quarter"""
		if self.current_quarter < self.max_quarters - 1:
			self.current_quarter += 1
			for stock in self.stocks.values():
				stock.advance_quarter()
			
			# Show strategy tutorial on Q2
			if self.current_quarter == 1:
				self.call_deferred("show_tutorial", "quarter_strategy")
			
			if hasattr(self, 'label') and self.label:
				apple_price = self.stocks["AAPL"].get_current_price()
				self.label.set_text(f"QUARTER {self.current_quarter + 1}/{self.max_quarters}\nAAPL: ${apple_price:.2f}\nCash: ${self.portfolio.cash:.2f}")
		else:
			# Game over
			total_value = self.portfolio.get_total_value(self.stocks)
			profit = total_value - 10000.0
			if hasattr(self, 'label') and self.label:
				self.label.set_text(f"GAME OVER!\nFinal: ${total_value:.2f}\nProfit: ${profit:.2f}")
	
	def show_tutorial(self, tutorial_key: str):
		"""Show tutorial dialog using Godot's AcceptDialog"""
		print(f"🔔 show_tutorial called: {tutorial_key}")
		
		tutorials = {
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
		
		if tutorial_key in tutorials:
			try:
				tut = tutorials[tutorial_key]
				print(f"Creating dialog: {tut['title']}")
				
				# Try to import and create AcceptDialog
				from py4godot.classes.Window.AcceptDialog import AcceptDialog
				dialog = AcceptDialog()
				dialog.set_title(tut["title"])
				dialog.set_text(tut["content"])
				dialog.set_ok_button_text("Got it!")
				self.add_child(dialog)
				dialog.popup_centered()
				print("✅ Dialog shown")
			except Exception as e:
				print(f"❌ Dialog error: {e}")
				import traceback
				traceback.print_exc()
	
	def show_tutorial_menu(self):
		"""Show menu of all tutorials"""
		print("🔔 show_tutorial_menu called")
		
		try:
			from py4godot.classes.Window.AcceptDialog import AcceptDialog
			menu = AcceptDialog()
			menu.set_title("📚 Tutorials")
			menu_text = "Choose a topic to learn about:\n\n"
			menu_text += "1. Welcome - Game basics\n"
			menu_text += "2. Market Trends - Understanding charts\n"
			menu_text += "3. Sentiment Analysis - News & feelings\n"
			menu_text += "4. Diversification - Spread your risk\n"
			menu_text += "5. Quarter Strategy - Plan your moves\n\n"
			menu_text += "Click buttons below to view tutorials!"
			menu.set_text(menu_text)
			menu.set_ok_button_text("Close")
			
			# Add buttons for each tutorial
			menu.add_button("Welcome", False, "welcome")
			menu.add_button("Trends", False, "sma")
			menu.add_button("Sentiment", False, "sentiment")
			menu.add_button("Diversify", False, "diversification")
			menu.add_button("Strategy", False, "quarter_strategy")
			
			# Connect custom action signal
			menu.connect("custom_action", self.show_tutorial)
			
			self.add_child(menu)
			menu.popup_centered()
			print("✅ Tutorial menu shown")
		except Exception as e:
			print(f"❌ Tutorial menu error: {e}")
			import traceback
			traceback.print_exc()
