# UI Improvement Guide - Milestone 3

## Quick Reference for Making the UI Look Professional

### Goal
Transform the current basic UI into a polished interface matching the Yahoo Finance style reference image.

---

## 1. Share Quantity Input Dialog

### What to Create:
A popup dialog that asks "How many shares?" when buying or selling.

### Steps in Godot:

1. **Create New Scene:**
   - Scene → New Scene
   - Add `AcceptDialog` as root
   - Name it: `ShareQuantityDialog`

2. **Add Input Control:**
   - Add child `VBoxContainer` to AcceptDialog
   - Add `Label` → Set text: "How many shares?"
   - Add `SpinBox` → Name: "ShareQuantity"
     - Min Value: 1
     - Max Value: 999
     - Step: 1
     - Value: 1

3. **Add to Main Scene:**
   - In main_scene.tscn, instance ShareQuantityDialog
   - Keep it hidden by default
   - Position: Center of screen

4. **Connect to Game_manager:**
   ```python
   # In Game_manager.py
   def _ready(self):
       # ... existing code ...
       self.quantity_dialog = self.get_node("ShareQuantityDialog")
   
   def on_buy_button_pressed(self, ticker):
       # Show dialog
       self.quantity_dialog.popup_centered()
       # Store which action (buy) and which ticker
       self.pending_action = ("buy", ticker)
   
   def on_quantity_confirmed(self):
       # Get value from SpinBox
       spinbox = self.quantity_dialog.get_node("VBoxContainer/ShareQuantity")
       quantity = int(spinbox.value)
       
       # Execute pending action
       if self.pending_action[0] == "buy":
           self.buy_stock(self.pending_action[1], quantity)
       elif self.pending_action[0] == "sell":
           self.sell_stock(self.pending_action[1], quantity)
   ```

---

## 2. Tutorial Popup Dialog

### What to Create:
Educational popups with rich text formatting.

### Steps in Godot:

1. **Create New Scene:**
   - Scene → New Scene
   - Add `AcceptDialog` as root
   - Name it: `TutorialDialog`
   - Set title: "Stock Trading Tutorial"

2. **Add Content Area:**
   - Add child `VBoxContainer`
   - Add `RichTextLabel` → Name: "TutorialContent"
     - Enable BBCode: On
     - Custom Minimum Size: (500, 400)
     - Fit Content Height: On

3. **Styling:**
   - AcceptDialog → Theme Overrides:
     - Panel: Create new StyleBoxFlat
     - Background Color: #2C3E50 (dark blue)
     - Border Width: 2
     - Border Color: #3498DB (light blue)

4. **Connect to TutorialManager:**
   ```python
   # In UIManager.py
   def show_tutorial_dialog(self, tutorial_key: str):
       tutorial = self.tutorial_manager.get_tutorial_content(tutorial_key)
       if tutorial:
           dialog = self.get_node("TutorialDialog")
           dialog.title = tutorial["title"]
           
           content_label = dialog.get_node("VBoxContainer/TutorialContent")
           content_label.text = tutorial["content"]
           
           dialog.popup_centered()
   ```

---

## 3. Professional Layout Redesign

### Layout Structure (Yahoo Finance Style):

```
MainScene (Node2D)
└── GameWindow (CanvasLayer)
    ├── TopBar (Panel)
    │   ├── StockSelector (OptionButton) [AAPL, MSFT, TSLA]
    │   ├── QuarterLabel (Label) "Q1 of 4"
    │   └── TutorialButton (Button) "📚 Learn"
    │
    ├── MainContent (HSplitContainer)
    │   ├── LeftPanel (VBoxContainer) [60% width]
    │   │   ├── StockInfoCard (PanelContainer)
    │   │   │   ├── StockName (Label) "Apple Inc."
    │   │   │   ├── StockTicker (Label) "AAPL"
    │   │   │   ├── CurrentPrice (Label) "$150.00"
    │   │   │   ├── PriceChange (Label) "+6.7% ↑" (green if up, red if down)
    │   │   │   └── Sentiment (Label) "Sentiment: 🟢 Strong (0.85)"
    │   │   │
    │   │   ├── ChartContainer (PanelContainer)
    │   │   │   └── CandlestickChart (Custom drawing)
    │   │   │
    │   │   └── NewsPanel (PanelContainer)
    │   │       └── NewsLabel (Label) "Strong Q1 earnings..."
    │   │
    │   └── RightPanel (VBoxContainer) [40% width]
    │       ├── PortfolioCard (PanelContainer)
    │       │   ├── Title (Label) "💰 Your Portfolio"
    │       │   ├── Cash (Label) "Cash: $10,000"
    │       │   ├── Holdings (Label) "Holdings: $0"
    │       │   └── Total (Label) "Total: $10,000"
    │       │
    │       ├── OwnedStocks (PanelContainer)
    │       │   └── StocksList (VBoxContainer)
    │       │       └── [AAPL: 5 shares @ $750]
    │       │
    │       └── ActionButtons (VBoxContainer)
    │           ├── BuyButton (Button) "🛒 Buy Stock"
    │           ├── SellButton (Button) "💸 Sell Stock"
    │           └── HoldButton (Button) "✋ Hold"
    │
    └── BottomBar (Panel)
        ├── NextQuarterButton (Button) "⏭️ Next Quarter"
        └── ResetButton (Button) "🔄 Reset Game"
```

### Color Scheme (Professional):

```gdscript
# Colors that look professional:
var background = Color("#1A1A2E")      # Dark navy
var panel_bg = Color("#16213E")        # Slightly lighter navy
var accent = Color("#0F3460")          # Medium blue
var positive = Color("#2ECC71")        # Green (price up)
var negative = Color("#E74C3C")        # Red (price down)
var text_primary = Color("#EAEAEA")    # Light gray
var text_secondary = Color("#B0B0B0")  # Medium gray
var highlight = Color("#3498DB")       # Bright blue
```

---

## 4. Improved Candlestick Chart

### Better Visualization:

Instead of simple Line2D, create proper candlesticks:

```python
# In Game_manager or new ChartDrawer.gd script:
func draw_candlestick(price_open, price_close, price_high, price_low, x_pos):
    var color = Color.GREEN if price_close >= price_open else Color.RED
    var candle_width = 20
    
    # Draw wick (high to low)
    draw_line(
        Vector2(x_pos, price_high),
        Vector2(x_pos, price_low),
        color,
        2.0
    )
    
    # Draw body (open to close)
    var body_rect = Rect2(
        x_pos - candle_width/2,
        min(price_open, price_close),
        candle_width,
        abs(price_close - price_open)
    )
    draw_rect(body_rect, color, true)
```

### Display All 4 Quarters:

```python
# Loop through price_history:
for i in range(4):
    var x = 100 + (i * 150)  # Space quarters evenly
    var price = stock.price_history[i]
    var prev_price = stock.price_history[i-1] if i > 0 else price
    
    draw_candlestick(prev_price, price, price + 5, price - 5, x)
    
    # Draw quarter label
    draw_string(font, Vector2(x - 10, 300), "Q" + str(i+1))
```

---

## 5. Quick Wins for Polish

### A. Add Icons to Buttons
```gdscript
# Use Unicode emojis or icon fonts:
$BuyButton.text = " Buy"
$SellButton.text = " Sell"
$HoldButton.text = " Hold"
$NextQuarterButton.text = " Next Quarter"
```

### B. Color-Code Price Changes
```python
def update_price_display(self, stock):
    change_percent = stock.get_price_change_percent()
    trend = stock.get_trend_symbol()
    
    if trend == "UP":
        color = Color(0.18, 0.8, 0.44)  # Green
        symbol = "▲"
    elif trend == "DOWN":
        color = Color(0.91, 0.3, 0.24)  # Red
        symbol = "▼"
    else:
        color = Color(0.7, 0.7, 0.7)    # Gray
        symbol = "■"
    
    price_label.add_theme_color_override("font_color", color)
    change_label.text = f"{change_percent:+.2f}% {symbol}"
```

### C. Smooth Transitions
```gdscript
# Animate value changes:
var tween = create_tween()
tween.tween_property($PortfolioValue, "text", new_value, 0.3)
```

### D. Hover Effects
```gdscript
# On Button nodes:
func _on_button_mouse_entered():
    modulate = Color(1.2, 1.2, 1.2)  # Brighten

func _on_button_mouse_exited():
    modulate = Color(1, 1, 1)  # Normal
```

---

## 6. Testing Checklist

Before considering UI complete, test:

- [ ] Can select different stocks (AAPL, MSFT, TSLA)
- [ ] Share quantity dialog appears when clicking Buy/Sell
- [ ] Can input 1-999 shares
- [ ] Tutorial button shows educational content
- [ ] Candlestick chart displays all 4 quarters
- [ ] Colors change based on price movement (green up, red down)
- [ ] Portfolio values update after trades
- [ ] Next Quarter button advances the game
- [ ] Reset button restarts game
- [ ] All text is readable (good contrast)
- [ ] Layout works at different window sizes

---

## 7. Priority Order

If time is limited, do these in order:

1. **Add Share Quantity Dialog** (30 mins) - Biggest gameplay improvement
2. **Fix Color Scheme** (30 mins) - Professional look instantly
3. **Add Button Icons** (15 mins) - Visual polish
4. **Create Stock Selector** (45 mins) - Show all 3 stocks
5. **Tutorial Popups** (1 hour) - Educational value
6. **Improve Candlestick Chart** (1.5 hours) - Professional visualization
7. **Add Animations** (1 hour) - Polish and juice

---

## Example: Quick Color Update

```gdscript
# In main_scene.tscn, select each Panel node and apply:

# Main Background
var style = StyleBoxFlat.new()
style.bg_color = Color("#1A1A2E")
$GameWindow.add_theme_stylebox_override("panel", style)

# Portfolio Panel
var portfolio_style = StyleBoxFlat.new()
portfolio_style.bg_color = Color("#16213E")
portfolio_style.border_width_all = 2
portfolio_style.border_color = Color("#3498DB")
$PortfolioView.add_theme_stylebox_override("panel", portfolio_style)

# Buy Button
$BuyButton.add_theme_color_override("font_color", Color("#2ECC71"))

# Sell Button
$SellButton.add_theme_color_override("font_color", Color("#E74C3C"))
```

---

## Resources

- **Godot UI Docs:** https://docs.godotengine.org/en/stable/tutorials/ui/
- **Color Palette Generator:** https://coolors.co/
- **Icon Resources:** Use Unicode emojis or search "free game icons"
- **UI Inspiration:** Yahoo Finance, Robinhood, Trading View

---


