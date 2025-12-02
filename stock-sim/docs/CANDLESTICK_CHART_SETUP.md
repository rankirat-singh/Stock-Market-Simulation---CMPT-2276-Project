# How to Add Dynamic Candlestick Chart

## Step 1: Remove Old Static Chart (1 minute)

1. Open `Scenes/main_scene.tscn` in Godot
2. Find the `GraphContainer` node (inside Stock View)
3. Delete all the old Line2D nodes (Q1Candle, Q1Wick, Q2Candle, etc.)
4. Delete the static Label showing Y-axis values

## Step 2: Add New Dynamic Chart (2 minutes)

1. Select the `GraphContainer` node
2. Right-click → Add Child Node → Search for "Control"
3. Name it exactly: **`CandlestickChart`** (capital C and C)
4. In Inspector:
   - Layout → Custom Minimum Size: X=800, Y=400
   - Anchors: Full Rect (expand to fill container)

## Step 3: Attach the Chart Script

1. With `CandlestickChart` node selected
2. In Inspector → Script section
3. Click the scroll icon → "Load"
4. Navigate to `scripts/candlestick_chart.gd`
5. Select it and click "Open"

## Step 4: Test It!

1. Press F5 to run the game
2. You should now see a REAL candlestick chart!
3. The chart shows:
   - Q1: $150 (starting price)
   - Q2: $160 (green candle - price up)
   - Q3: $155 (red candle - price down)
   - Q4: $170 (green candle - price up)
4. Click "Next Quarter" → Chart doesn't change (it shows ALL quarters at once)
5. Buy/Sell stocks → Chart stays the same (it's showing price history, not affected by your trades)

## What You'll See:

```
     $170 ┼─────────────────┐
          │              ┌──┴──┐ Q4 (Green, tallest)
     $160 ┼──────┐       │     │
          │   ┌──┴──┐    │     │
     $155 ┼───│  │  ├──┐ │     │
          │   │  │  │  └─┤     │
     $150 ┼┐  │  │  │    │     │
          └┴──┴──┴──┴────┴─────┴─
           Q1  Q2  Q3     Q4
```

## Features:

✅ **Dynamic Data**: Reads from `stock.price_history` array  
✅ **Color-Coded**: Green for price increases, Red for decreases  
✅ **Proper Scaling**: Y-axis automatically adjusts to price range  
✅ **Grid Lines**: Shows price levels  
✅ **Labels**: Quarter labels (Q1-Q4) and price labels on each candle  
✅ **Wicks**: Shows high/low range (simulated)  

## Advanced: Show Different Stocks

To switch between AAPL, MSFT, TSLA charts, you can add a stock selector:

```gdscript
# In Game_manager.py, add a method:
def update_chart_for_stock(self, ticker: str):
    root = self.get_parent()
    chart = root.find_child("CandlestickChart", True, False)
    if chart and ticker in self.stocks:
        stock = self.stocks[ticker]
        chart.call("set_stock_data", stock.price_history)
```

Then create buttons that call:
- `game_manager.update_chart_for_stock("AAPL")`
- `game_manager.update_chart_for_stock("MSFT")`
- `game_manager.update_chart_for_stock("TSLA")`

## Customization:

In `candlestick_chart.gd`, you can modify:

**Colors:**
```gdscript
var color_up = Color(0.18, 0.8, 0.44)    # Change green color
var color_down = Color(0.91, 0.3, 0.24)  # Change red color
```

**Size:**
```gdscript
var candle_width = 60     # Make candles wider/narrower
var candle_spacing = 30   # Space between candles
var chart_margin = 40     # Margin around chart
```

**Style:**
- Line 94-98: Wick drawing (change thickness)
- Line 101-109: Body drawing (change fill/border)

---

That's it! You now have a professional, data-driven candlestick chart! 📊📈

The chart automatically updates when you call `_update_ui()`, so whenever you buy/sell or advance quarters, the chart refreshes with current data.
