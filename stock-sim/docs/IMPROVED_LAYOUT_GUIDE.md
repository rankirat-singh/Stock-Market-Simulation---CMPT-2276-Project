# Improved Main Scene Layout Guide

Follow these steps in Godot to recreate the UI like the reference image:

## Step 1: Create the Top Bar (Quarter Display + Tutorial Button)

1. In `main_scene.tscn`, delete or hide the `TabContainer`
2. Add a new `PanelContainer` under `GameWindow` → Name: "TopBar"
   - Anchors: Top, Left, Right
   - Offset Top: 0, Bottom: 60
   - Add theme: StyleBoxFlat with dark blue background (#16213E)

3. Inside TopBar, add `HBoxContainer`
   - Add `Label` → Name: "QuarterLabel"
	 - Text: "Quarter 1 of 4"
	 - Font Size: 28
	 - Color: White
   - Add `Button` → Name: "LearnButton"
	 - Text: "📚 Learn"
	 - Connect pressed() → Game_manager.show_tutorial("welcome")

## Step 2: Create Main Content Area (HSplitContainer)

1. Add `HSplitContainer` under GameWindow → Name: "MainContent"
   - Anchors: Fill (expand to full screen below TopBar)
   - Offset Top: 65
   - Split Offset: 850 (left panel gets 70% width)

## Step 3: Left Panel - Stock Information

Inside left side of HSplitContainer:

1. Add `VBoxContainer` → Name: "LeftPanel"
   
2. Inside LeftPanel:
   - Add `PanelContainer` → Name: "StockInfoCard"
	 - Add `VBoxContainer` inside
	   - `Label` "StockName" → "NVIDIA Corporation" (Font 32, Bold)
	   - `Label` "StockTicker" → "NVDA" (Font 20, Gray)
	   - `HBoxContainer`:
		 - `Label` "CurrentPrice" → "$198.69" (Font 48, White)
		 - `Label` "PriceChange" → "-8.19 (-3.96%)" (Font 24, Red for down, Green for up)
	   - `Label` "Sentiment" → "Market Sentiment: 🟢 Strong (0.85)" (Font 18)
	   - `Label` "News" → "Strong Q1 earnings beat expectations" (Font 16, Word Wrap)
   
   - Add `PanelContainer` → Name: "ChartContainer"
	 - Min Size: (800, 400)
	 - Inside: Add Control node for custom drawing (candlestick chart)
	 - For now: Add Label "Candlestick Chart Coming Soon"

## Step 4: Right Panel - Portfolio & Actions

Inside right side of HSplitContainer:

1. Add `VBoxContainer` → Name: "RightPanel"
   - Add spacing: 10

2. Inside RightPanel:
   
   **Portfolio Card:**
   - Add `PanelContainer` → Name: "PortfolioCard"
	 - Add `VBoxContainer` inside:
	   - `Label` "💰 Your Portfolio" (Font 24, Bold)
	   - `Label` "CashLabel" → "Cash: $10,000.00" (Font 18)
	   - `Label` "HoldingsLabel" → "Holdings: $0.00" (Font 18)
	   - `HSeparator`
	   - `Label` "TotalLabel" → "Total: $10,000.00" (Font 22, Bold, Green)
   
   **Owned Stocks:**
   - Add `PanelContainer` → Name: "OwnedStocksCard"
	 - Add `VBoxContainer` → Name: "StocksList"
	   - `Label` "📊 Your Stocks" (Font 20, Bold)
	   - `Label` "StockHoldings" → "No stocks owned" (Font 16)
   
   **Action Buttons:**
   - Add `VBoxContainer` → Name: "ActionButtons", spacing: 15
	 - `Button` "BuyButton" → "🛒 Buy Stock" (Min Size: 200x50, Font 18)
	   - Connect: pressed() → Game_manager.buy_stock("AAPL")
	 - `Button` "SellButton" → "💸 Sell Stock" (Min Size: 200x50, Font 18)
	   - Connect: pressed() → Game_manager.sell_stock("AAPL")
	 - `Button` "HoldButton" → "✋ Hold" (Min Size: 200x50, Font 18)
	   - Connect: pressed() → Game_manager.hold_stock("AAPL")

## Step 5: Bottom Bar (Next Quarter Button)

1. Add `PanelContainer` under GameWindow → Name: "BottomBar"
   - Anchors: Bottom, Left, Right
   - Offset Top: -70, Bottom: 0

2. Inside BottomBar, add `HBoxContainer`:
   - Add `Button` → Name: "NextQuarterButton"
	 - Text: "⏭️ Next Quarter"
	 - Min Size: 200x50
	 - Font Size: 20
	 - Connect: pressed() → Game_manager.advance_quarter()
   - Add `Button` → Name: "ResetButton"
	 - Text: "🔄 Reset Game"
	 - Connect: pressed() → Game_manager.reset_game()

## Step 6: Add Tutorial Dialog

1. Instance the `tutorial_dialog.tscn` scene
2. Add as child of MainScene → Name: "TutorialDialog"
3. Keep it hidden by default

## Step 7: Color Scheme (Apply to PanelContainers)

```
Background: #1A1A2E (Dark Navy)
Panels: #16213E (Medium Navy)
Accent: #0F3460 (Blue)
Positive: #2ECC71 (Green)
Negative: #E74C3C (Red)
Text: #EAEAEA (Light Gray)
```

For each PanelContainer:
- Theme Override → Add StyleBoxFlat
- Set bg_color to panel color
- Border width: 2
- Border color: #3498DB

## Quick Implementation (Alternative: GDScript)

If you want to do this in code instead, create `ui_layout.gd`:

```gdscript
extends CanvasLayer

func _ready():
	create_improved_layout()

func create_improved_layout():
	# Clear existing UI
	for child in get_children():
		child.queue_free()
	
	# Create top bar
	var top_bar = PanelContainer.new()
	add_child(top_bar)
	# ... add components
```

But I recommend doing it in the Godot editor for easier visual adjustments!
