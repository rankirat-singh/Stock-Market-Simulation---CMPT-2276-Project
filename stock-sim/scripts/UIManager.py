"""
UI Manager - Handles all UI updates and dialog prompts
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
class UIManager(Node):
	"""Manages UI updates, dialogs, and user interactions"""
	
	def _init(self):
		self.game_manager = None
		self.tutorial_manager = None
	
	def _ready(self):
		print("UI Manager initialized")
	
	def set_game_manager(self, gm):
		"""Set reference to game manager"""
		self.game_manager = gm
	
	def set_tutorial_manager(self, tm):
		"""Set reference to tutorial manager"""
		self.tutorial_manager = tm
	
	def prompt_share_quantity(self, action: str, ticker: str, max_shares: int = 999):
		"""
		Prompt user for number of shares to buy/sell
		Returns the quantity entered by user
		"""
		# This will be connected to a proper dialog in Godot
		# For now, return 1 as default
		print(f"Prompting for {action} quantity for {ticker}")
		return 1
	
	def show_tutorial_dialog(self, tutorial_key: str):
		"""Display tutorial popup dialog"""
		if not self.tutorial_manager:
			return
		
		tutorial = self.tutorial_manager.get_tutorial_content(tutorial_key)
		if tutorial:
			print(f"\n📚 Showing tutorial: {tutorial['title']}")
			self.tutorial_manager.show_tutorial(tutorial_key)
	
	def update_stock_display(self, stock, ticker: str, parent_node):
		"""Update stock information display"""
		try:
			# Update stock name
			name_label = parent_node.find_child("StockName", True, False)
			if name_label:
				name_label.set_text(stock.name)
			
			# Update ticker
			code_label = parent_node.find_child("StockCode", True, False)
			if code_label:
				code_label.set_text(ticker)
			
			# Update current price
			price_label = parent_node.find_child("StockPrice", True, False)
			if price_label:
				current_price = stock.get_current_price()
				price_label.set_text(f"{current_price:.2f}USD")
			
			print(f"✅ Updated display for {ticker}")
		except Exception as e:
			print(f"Error updating stock display: {e}")
	
	def show_confirmation_dialog(self, title: str, message: str):
		"""Show a confirmation dialog"""
		print(f"📢 {title}: {message}")
