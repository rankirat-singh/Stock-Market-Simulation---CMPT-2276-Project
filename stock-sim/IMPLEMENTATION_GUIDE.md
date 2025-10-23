# Stock Trading Simulator - Base Classes Documentation

## Completed Components

### 1. Stock.py
**Purpose:** Represents a single stock in the trading simulator

**Key Attributes:**
- `name` - Company name (e.g., "Apple Inc.")
- `ticker` - Stock symbol (e.g., "AAPL")
- `price_history` - List of 4 prices [Q1, Q2, Q3, Q4]
- `news_history` - List of 4 news headlines
- `sentiment_history` - List of 4 sentiment indicators
- `current_quarter` - Tracks which quarter we're in (0-3)

**Key Methods:**
- `get_current_price()` - Returns price for current quarter
- `get_previous_price()` - Returns price from last quarter
- `get_price_change_percent()` - Calculates % change from previous quarter
- `get_current_news()` - Returns news for current quarter
- `get_current_sentiment()` - Returns sentiment for current quarter
- `advance_quarter()` - Moves to next quarter
- `reset()` - Resets to quarter 0
- `get_trend_symbol()` - Returns ↑ ↓ or → based on price change

### 2. Portfolio.py
**Purpose:** Manages player's cash and stock holdings

**Key Attributes:**
- `cash` - Current available cash
- `starting_cash` - Initial cash amount ($10,000)
- `holdings` - Dictionary of stocks owned: `{'AAPL': 2, 'MSFT': 1}`
- `transaction_history` - List of all buy/sell transactions

**Key Methods:**
- `buy_stock(stock, shares=1)` - Buy shares if you have enough cash (returns True/False)
- `sell_stock(stock, shares=1)` - Sell shares if you own them (returns True/False)
- `get_shares_owned(ticker)` - Check how many shares you own of a stock
- `get_total_value(stocks_dict)` - Calculate total portfolio worth (cash + holdings)
- `get_profit_loss(stocks_dict)` - Calculate profit or loss in dollars
- `get_profit_loss_percent(stocks_dict)` - Calculate profit or loss as percentage
- `can_afford(stock, shares=1)` - Check if you can afford to buy
- `reset()` - Reset to starting state

## Testing

Run `simple_test.py` to verify everything works:

```bash
python simple_test.py
```

Expected output:
```
Creating a stock...
Stock: Apple Inc. (AAPL)
Q1 Price: $150
News: Strong sales

Advancing to Q2...
Q2 Price: $160
Change: ↑ 6.67%

==================================================
Creating portfolio...
Starting cash: $10000

Buying 1 share of AAPL...
✓ Success!
Cash: $9840
Holdings: {'AAPL': 1}

Portfolio value: $10000

✅ All tests passed!
```

## Game Flow

1. **Start:** Quarter 1, $10,000 cash, no stocks
2. **Each Quarter:**
   - Show 3 stocks with current prices
   - Player chooses: Buy/Sell/Hold ONE stock
   - Advance to next quarter
   - Show results (price changes, portfolio value)
3. **End (Quarter 4):**
   - Calculate final portfolio value
   - Win if value > $10,000
   - Lose if value ≤ $10,000

## Sample Stock Data

Here's the recommended data for your 3 stocks:

**AAPL (Apple):**
- Prices: [150, 160, 155, 170]
- News: ["Strong iPhone sales", "Services revenue up", "Minor dip", "Record quarter"]
- Sentiment: ["Positive", "Positive", "Neutral", "Very Positive"]

**MSFT (Microsoft):**
- Prices: [300, 290, 310, 320]
- News: ["Cloud growth slows", "AI investments", "Azure revenue up", "Strong finish"]
- Sentiment: ["Neutral", "Negative", "Positive", "Positive"]

**TSLA (Tesla):**
- Prices: [200, 220, 240, 230]
- News: ["Production delays", "New factory opens", "Record deliveries", "Competition concerns"]
- Sentiment: ["Negative", "Positive", "Very Positive", "Neutral"]

## ✅ Verification Checklist

- [x] Stock class tracks prices correctly
- [x] Stock advances through quarters
- [x] Stock calculates price changes
- [x] Portfolio handles buying (with cash validation)
- [x] Portfolio handles selling (with ownership validation)
- [x] Portfolio calculates total value correctly
- [x] Portfolio tracks profit/loss
- [x] All tests pass



---

**Status:** Base classes complete and tested ✅  

