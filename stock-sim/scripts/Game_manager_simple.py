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
    """Minimal test version of game manager"""

    current_quarter: int = 0
    max_quarters: int = 4

    def _ready(self) -> None:
        """Initialize game - MINIMAL VERSION"""
        print("=" * 50)
        print("GAME MANAGER READY - MINIMAL VERSION")
        print("=" * 50)

        try:
            # Initialize portfolio
            self.portfolio = Portfolio(10000)
            print(f" Portfolio created: ${self.portfolio.cash}")

            # Initialize stocks
            self.stocks = {}
            self.stocks["AAPL"] = Stock(
                name="Apple Inc.",
                ticker="AAPL",
                price_history=[150.0, 160.0, 155.0, 170.0],
                news_history=["Q1 news", "Q2 news", "Q3 news", "Q4 news"],
                sentiment_history=[0.8, 0.9, 0.3, 0.95]
            )
            print(f" Stocks created: {list(self.stocks.keys())}")

            # Find the stock price label to use for feedback
            root = self.get_parent()
            if root:
                self.feedback_label = root.find_child("StockPrice", True, False)
                if self.feedback_label:
                    self.feedback_label.set_text("GAME READY! Click a button")

            print(" GAME INITIALIZED SUCCESSFULLY!")
            print("=" * 50)

        except Exception as e:
            print(f" ERROR: {e}")
            import traceback
            traceback.print_exc()

    def _process(self, delta: float) -> None:
        pass

    def buy_stock(self, ticker="AAPL", shares=1):
        """Buy stock - minimal version"""
        print(f"Buy button clicked: {ticker} x{shares}")
        if hasattr(self, 'feedback_label') and self.feedback_label:
            stock = self.stocks[ticker]
            price = stock.get_current_price()
            total = price * shares
            if self.portfolio.cash >= total:
                self.portfolio.cash -= total
                self.feedback_label.set_text(
                    f"BOUGHT {shares}x {ticker} @ ${price:.2f}\nCash left: ${self.portfolio.cash:.2f}")
            else:
                self.feedback_label.set_text(f"NOT ENOUGH CASH!\nNeed ${total:.2f}, have ${self.portfolio.cash:.2f}")

    def sell_stock(self, ticker="AAPL", shares=1):
        """Sell stock - minimal version"""
        print(f"Sell button clicked: {ticker} x{shares}")
        if hasattr(self, 'feedback_label') and self.feedback_label:
            self.feedback_label.set_text(f"SOLD {shares}x {ticker}\n(Sell not fully implemented yet)")

    def hold_stock(self):
        """Hold - minimal version"""
        print("Hold button clicked")
        if hasattr(self, 'feedback_label') and self.feedback_label:
            self.feedback_label.set_text(f"HOLD - Skipped to next quarter\nCash: ${self.portfolio.cash:.2f}")

    def advance_quarter(self):
        """Next quarter - minimal version"""
        self.current_quarter += 1
        print(f"Next Quarter button clicked - now Q{self.current_quarter}")
        if hasattr(self, 'feedback_label') and self.feedback_label:
            self.feedback_label.set_text(
                f"NEXT QUARTER\nNow in Quarter {self.current_quarter + 1}/{self.max_quarters}\nCash: ${self.portfolio.cash:.2f}")
