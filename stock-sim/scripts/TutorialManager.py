"""
Tutorial Manager - Handles educational popups teaching stock trading concepts
"""

from py4godot.methods import private
from py4godot.classes import gdclass
from py4godot.classes.Node import Node

import sys
import os
scripts_dir = os.path.dirname(os.path.abspath(__file__))
if scripts_dir not in sys.path:
    sys.path.insert(0, scripts_dir)


@gdclass
class TutorialManager(Node):
	"""Manages tutorial popups that teach stock trading concepts"""
	
	def _init(self):
		self.tutorials_shown = {}
		self.tutorials = self._initialize_tutorials()
	
	def _ready(self):
		print("Tutorial Manager initialized")
	
	@private
	def _initialize_tutorials(self):
		"""Define all tutorial content"""
		return {
			"welcome": {
				"title": "Welcome to Stock Trading Simulator!",
				"content": """You start with $10,000 to invest over 4 quarters.

Your goal: Make a profit by buying low and selling high!

Key Tips:
• Watch price trends across quarters
• Diversify your portfolio
• Don't invest everything at once"""
			},
			"sma": {
				"title": " Simple Moving Average (SMA)",
				"content": """SMA helps identify trends by averaging prices over time.

How it works:
• Calculates average of recent prices
• Smooths out short-term fluctuations
• Shows overall price direction

When price > SMA: Upward trend (Consider buying)
When price < SMA: Downward trend (Consider selling)"""
			},
			"sentiment": {
				"title": " Market Sentiment Analysis",
				"content": """Sentiment shows investor confidence (0.0 to 1.0).

High Sentiment (0.7-1.0):
• Positive news
• Strong confidence
• Likely price increase

Low Sentiment (0.0-0.3):
• Negative news
• Weak confidence
• Possible price drop

Use sentiment + price trends for better decisions!"""
			},
			"diversification": {
				"title": " Portfolio Diversification",
				"content": """Don't put all your money in one stock!

Why diversify:
• Reduces risk
• One loss won't ruin you
• Balances gains and losses

Strategy:
• Invest in 2-3 different stocks
• Mix stable and growth stocks
• Keep some cash for opportunities"""
			},
			"quarter_strategy": {
				"title": " Quarter-by-Quarter Strategy",
				"content": """Plan your moves across all 4 quarters:

Quarter 1-2:
• Research and buy promising stocks
• Start building your portfolio

Quarter 3:
• Monitor performance
• Adjust positions if needed

Quarter 4:
• Time to secure profits
• Sell winners before game ends"""
			}
		}
	
	def show_tutorial(self, tutorial_key: str):
		"""Show a specific tutorial popup"""
		if tutorial_key not in self.tutorials:
			print(f"Tutorial '{tutorial_key}' not found")
			return False
		
		if tutorial_key in self.tutorials_shown:
			print(f"Tutorial '{tutorial_key}' already shown")
			return False
		
		self.tutorials_shown[tutorial_key] = True
		tutorial = self.tutorials[tutorial_key]
		
		print(f"\n{'='*60}")
		print(f"TUTORIAL: {tutorial['title']}")
		print(f"{'='*60}")
		print(tutorial['content'])
		print(f"{'='*60}\n")
		
		return True
	
	def get_tutorial_content(self, tutorial_key: str):
		"""Get tutorial content for display"""
		if tutorial_key in self.tutorials:
			return self.tutorials[tutorial_key]
		return None
	
	def reset_tutorials(self):
		"""Reset all shown tutorials"""
		self.tutorials_shown = {}
