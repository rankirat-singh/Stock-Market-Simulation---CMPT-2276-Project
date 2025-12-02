# Quick Fix for Buttons + Stock Selector

## Problem: Buttons Not Working
The buy/sell/hold/next quarter buttons stopped working because the scene changed. Let's fix them!

## Fix 1: Reconnect All Buttons (5 minutes)

### In Godot:

1. **Open `main_scene.tscn`**

2. **Find the Buy Button:**
   - Click on "BuyButton" in the scene tree
   - Go to "Node" tab (top right)
   - Find "Signals" section → "pressed()"
   - If it shows "connected", right-click → Disconnect
   - Now double-click "pressed()" signal
   - Connect to: MainScene (root node with Game_manager script)
   - Method in receiver: type **`buy_stock`**
   - Click "Connect"

3. **Find the Sell Button:**
   - Same process as Buy button
   - Connect to: `sell_stock`

4. **Find the Hold Button:**
   - Same process
   - Connect to: `hold_stock`

5. **Find the NextQuarterButton:**
   - Same process
   - Connect to: `advance_quarter`

### Test:
- Press F5
- Click Buy → Console should show "Bought 1 share(s) of AAPL..."
- Click Sell → Should work if you own shares
- Click Next Quarter → Should show "Advanced to Quarter 2"

---

## Fix 2: Portfolio Not Showing

The portfolio values should update automatically. If you don't see them:

1. Make sure you have these label nodes in "Portfolio View":
   - `CashHoldingsValue`
   - `StockHoldingsValue`
   - `PortfolioValue`

2. If they're missing or named differently, the `_update_ui()` won't find them.

3. Quick test:
   - Run the game
   - Check console for: "UI Updated - Cash: $XXXX, Portfolio Value: $XXXX"
   - If you see this, the backend is working
   - If you don't see it in the UI, it's a node naming issue

---

## Add Stock Selector Buttons (10 minutes)

Now let's add buttons to switch between AAPL, MSFT, and TSLA charts!

### Step 1: Add Button Container

1. In scene tree, find "Stock View" or wherever you want the buttons
2. Right-click → Add Child Node → `HBoxContainer`
3. Name it: "StockSelectorButtons"
4. Position it above or below the chart

### Step 2: Add Three Buttons

Inside `StockSelectorButtons`, add:

1. **Button 1:**
   - Name: "AppleButton"
   - Text: "📈 AAPL"
   - Signal: pressed() → MainScene → `update_chart_for_stock` → Arguments: "AAPL"

2. **Button 2:**
   - Name: "MicrosoftButton"
   - Text: "📈 MSFT"
   - Signal: pressed() → MainScene → `update_chart_for_stock` → Arguments: "MSFT"

3. **Button 3:**
   - Name: "TeslaButton"
   - Text: "📈 TSLA"
   - Signal: pressed() → MainScene → `update_chart_for_stock` → Arguments: "TSLA"

### Step 3: Connect Signals with Arguments

For each button:

1. Select the button
2. Go to "Node" tab → Signals
3. Double-click "pressed()"
4. Connect to: MainScene
5. Method: `update_chart_for_stock`
6. **IMPORTANT:** At the bottom of the connect dialog:
   - Click "Advanced"
   - In "Extra Call Arguments" section
   - Add a String argument with the ticker ("AAPL", "MSFT", or "TSLA")
7. Click "Connect"

### Step 4: Test

- Run the game
- Click "📈 AAPL" → Chart shows Apple stock
- Click "📈 MSFT" → Chart shows Microsoft stock
- Click "📈 TSLA" → Chart shows Tesla stock
- Console should show: "📊 Updated chart to show MSFT"

---

## Alternative: GDScript Buttons (Simpler)

If connecting with arguments is confusing, create 3 small scripts:

**apple_button.gd:**
```gdscript
extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	get_node("/root/MainScene").update_chart_for_stock("AAPL")
```

**microsoft_button.gd:**
```gdscript
extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	get_node("/root/MainScene").update_chart_for_stock("MSFT")
```

**tesla_button.gd:**
```gdscript
extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	get_node("/root/MainScene").update_chart_for_stock("TSLA")
```

Attach each script to its button!

---

## Quick Test Checklist

After setup, verify:

- [ ] Buy button works (console shows purchase, cash decreases)
- [ ] Sell button works (if you own shares)
- [ ] Hold button works (console shows "Holding position")
- [ ] Next Quarter button advances game
- [ ] Portfolio View shows cash, holdings, total value
- [ ] Stock selector buttons exist
- [ ] Clicking AAPL button updates chart
- [ ] Clicking MSFT button updates chart  
- [ ] Clicking TSLA button updates chart
- [ ] Console shows "📊 Updated chart to show [TICKER]"

---

## Common Issues:

**Issue:** "Button does nothing"
- **Fix:** Make sure signal is connected in inspector

**Issue:** "Error: NoneType object has no attribute 'call'"
- **Fix:** Chart node isn't named "CandlestickChart" or doesn't exist

**Issue:** "Portfolio shows 0.00 for everything"
- **Fix:** Buttons aren't connected, so buy/sell never happens

**Issue:** "update_chart_for_stock not found"
- **Fix:** Make sure you saved Game_manager.py and Godot reloaded it

---

Need help? Check the console output - it will tell you exactly what's wrong!
