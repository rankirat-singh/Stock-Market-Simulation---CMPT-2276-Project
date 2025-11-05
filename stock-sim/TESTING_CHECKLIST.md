# Godot Testing Checklist for Milestone 3 Features

## How to Test in Godot

### Step 1: Open the Project
1. Open Godot Engine
2. Import/Open: `c:\Users\Rankirat\Douglas\CMPT 2276\Project\stock-sim`
3. Open `Scenes/main_scene.tscn`

---

## Test 1: Buy Multiple Shares via Console

### What to test:
Check if the new `shares` parameter works in buy_stock()

### Steps:
1. Run the game (F5)
2. Open Godot console (Output tab at bottom)
3. Look for initialization message:
   ```
   Game initialized: Quarter 1/4
   Starting cash: $10000
   ```

### Expected behavior:
- Game starts without errors
- Game_manager initializes TutorialManager and UIManager
- Portfolio starts with $10,000

### ✅ Pass if:
- No error messages in console
- You see "Game initialized"
- You see "Tutorial Manager initialized"
- You see "UI Manager initialized"

---

## Test 2: Verify Buy/Sell Buttons Work

### What to test:
Existing Buy/Sell buttons should still work (buying 1 share at a time for now)

### Steps:
1. Click "Buy" button
2. Check console output
3. Check Portfolio View - cash should decrease
4. Click "Sell" button (if you own shares)
5. Check console output

### Expected console output:
```
Bought 1 share of AAPL at $150.0
UI Updated - Cash: $9850.00, Portfolio Value: $10000.00
```

### ✅ Pass if:
- Buy button decreases cash by stock price
- Sell button increases cash
- Portfolio View updates
- Console shows "Bought X shares" messages
- No error messages

---

## Test 3: Test Multiple Share Purchase (Console Command)

### What to test:
Buy multiple shares at once using the new parameter

### Steps:
1. Run the game
2. In Godot, go to Debugger → Remote (while game is running)
3. Or use this Python test script approach:
   - Stop the game
   - Add a test button to the scene that calls:
     ```gdscript
     $GameManager.buy_stock("AAPL", 5)
     ```

### Alternative: Modify Buy button temporarily
1. Open `main_scene.tscn`
2. Select "BuyButton" node
3. Look at the signal connection to `buy_stock()`
4. Temporarily change it to call with parameter:
   - In inspector, disconnect signal
   - Reconnect with: `buy_stock("AAPL", 5)`

### Expected behavior:
- Buys 5 shares at once
- Cash decreases by (price × 5)
- Console shows: "Bought 5 share(s) of AAPL at $150.00 each"

### ✅ Pass if:
- Multiple shares purchased
- Correct cash deduction
- Portfolio View shows correct holdings

---

## Test 4: Test Tutorial System

### What to test:
Educational tutorials display correctly

### Steps:
1. Run the game
2. Check console for welcome tutorial:
   ```
   ==========================================
   TUTORIAL: Welcome to Stock Trading Simulator!
   ==========================================
   ```

### Expected console output:
Should see formatted tutorial with:
- Title
- Content explaining the game
- Tips for playing

### ✅ Pass if:
- Welcome tutorial appears on game start
- Text is readable and formatted
- No error messages

---

## Test 5: Test Stock Info Retrieval

### What to test:
The new `get_stock_info()` method works

### Steps:
1. Add a test button or modify existing button
2. Call: `var info = $GameManager.get_stock_info("AAPL")`
3. Print the info: `print(info)`

### Expected output:
```
{
  "name": "Apple Inc.",
  "ticker": "AAPL",
  "current_price": 150.0,
  "previous_price": 150.0,
  "price_change": 0.0,
  "trend": "FLAT",
  "news": "Strong Q1 earnings beat expectations",
  "sentiment": 0.8,
  "owned_shares": 0
}
```

### ✅ Pass if:
- Returns dictionary with all fields
- Values are correct
- No errors

---

## Test 6: Test Quarter Advancement

### What to test:
Advancing quarters updates all stocks

### Steps:
1. Run the game
2. Note current AAPL price ($150)
3. Click "Next Quarter" button (if it exists) OR
4. Call `$GameManager.advance_quarter()` from code
5. Check console for price updates

### Expected behavior:
- Current quarter increments (Q1 → Q2)
- All stock prices change:
  - AAPL: $150 → $160
  - MSFT: $300 → $290
  - TSLA: $200 → $220
- UI updates with new prices

### ✅ Pass if:
- Prices change correctly
- Console shows "Advanced to Quarter 2"
- UI refreshes
- Can advance through all 4 quarters

---

## Test 7: Test Validation (Can't Overspend)

### What to test:
Can't buy more shares than you can afford

### Steps:
1. Run the game (start with $10,000)
2. Try to buy 100 shares of AAPL (would cost $15,000)
3. Use button or call: `$GameManager.buy_stock("AAPL", 100)`

### Expected behavior:
- Purchase fails
- Console shows: "Not enough cash to buy 100 shares of AAPL"
- Cash remains unchanged
- No shares added

### ✅ Pass if:
- Purchase correctly blocked
- Error message displayed
- Game state unchanged

---

## Test 8: Test Validation (Can't Oversell)

### What to test:
Can't sell more shares than you own

### Steps:
1. Run the game
2. Without buying any shares, try to sell
3. Call: `$GameManager.sell_stock("AAPL", 5)`

### Expected behavior:
- Sale fails
- Console shows: "You don't own enough shares"
- Cash unchanged
- Holdings unchanged

### ✅ Pass if:
- Sale correctly blocked
- Error message displayed
- Game state unchanged

---

## Common Issues & Solutions

### Issue: "TutorialManager not found"
**Solution:** Check that TutorialManager.py has no syntax errors

### Issue: "UIManager not found"
**Solution:** Check that UIManager.py has no syntax errors

### Issue: Buy button does nothing
**Solution:** 
1. Check signal connections in scene
2. Verify Game_manager.py has no errors
3. Check console for error messages

### Issue: UI doesn't update after purchase
**Solution:**
1. Check node names in scene tree match what _update_ui() expects
2. Look for "❌ Could not find..." messages in console
3. Verify labels exist: "CashHoldingsValue", "StockHoldingsValue", "PortfolioValue"

---

## Quick Test Script (Add to Game_manager for Testing)

Add this method to Game_manager.py for quick testing:

```python
def test_new_features(self):
    """Quick test of Milestone 3 features"""
    print("\n" + "="*50)
    print("TESTING MILESTONE 3 FEATURES")
    print("="*50)
    
    # Test 1: Buy multiple shares
    print("\n1. Buying 5 shares of AAPL...")
    result = self.buy_stock("AAPL", 5)
    print(f"   Result: {result}")
    
    # Test 2: Show tutorial
    print("\n2. Showing SMA tutorial...")
    self.show_tutorial("sma")
    
    # Test 3: Get stock info
    print("\n3. Getting AAPL info...")
    info = self.get_stock_info("AAPL")
    print(f"   Info: {info}")
    
    # Test 4: Advance quarter
    print("\n4. Advancing to next quarter...")
    self.advance_quarter()
    
    print("\n" + "="*50)
    print("TESTING COMPLETE")
    print("="*50)
```

Then call it from _ready():
```python
def _ready(self):
    # ... existing code ...
    self.call_deferred("test_new_features")
```

---

## Final Checklist

Before pushing to GitHub, verify:

- [ ] Game starts without errors
- [ ] Buy button works (at least 1 share)
- [ ] Sell button works (when owning shares)
- [ ] Portfolio View updates correctly
- [ ] Can buy multiple shares (tested via code)
- [ ] Can't overspend (validation works)
- [ ] Can't oversell (validation works)
- [ ] Tutorials display in console
- [ ] Quarter advancement works
- [ ] All 3 stocks initialized (AAPL, MSFT, TSLA)

---

## What's Next (After Testing)

Once basic functionality is confirmed:

1. **Create Share Quantity Dialog**
   - See: `docs/UI_Improvement_Guide.md` Section 1
   - Add SpinBox for user input
   - Connect to Buy/Sell buttons

2. **Create Tutorial Popups**
   - See: `docs/UI_Improvement_Guide.md` Section 2
   - Add AcceptDialog with RichTextLabel
   - Add "Learn" button

3. **Improve UI Layout**
   - See: `docs/UI_Improvement_Guide.md` Section 3
   - Redesign to match reference image
   - Add proper styling and colors

---

## Testing Notes

**Date:** November 5, 2025
**Tested by:** _______________
**Godot Version:** 4.5
**Python Version:** 3.12.4

### Test Results:

Test 1 - Basic Initialization: ⬜ Pass ⬜ Fail
Test 2 - Buy/Sell Buttons: ⬜ Pass ⬜ Fail
Test 3 - Multiple Shares: ⬜ Pass ⬜ Fail
Test 4 - Tutorials: ⬜ Pass ⬜ Fail
Test 5 - Stock Info: ⬜ Pass ⬜ Fail
Test 6 - Quarter Advance: ⬜ Pass ⬜ Fail
Test 7 - Overspend Block: ⬜ Pass ⬜ Fail
Test 8 - Oversell Block: ⬜ Pass ⬜ Fail

### Notes:
_______________________________________________________
_______________________________________________________
_______________________________________________________
