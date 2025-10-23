# Base Classes for Stock Trading Simulator

## Files Created

### Stock.py
Represents a single stock with:
- Price history for 4 quarters
- News headlines for each quarter
- Sentiment indicators
- Methods to get current price, calculate price changes, advance quarters

### Portfolio.py
Manages the player's money and stocks:
- Tracks cash and stock holdings
- Buy/sell stock methods (returns True/False for success)
- Calculate total portfolio value
- Calculate profit/loss

## How to Use

```python
from Stock import Stock
from Portfolio import Portfolio

# Create a stock
apple = Stock(
    name="Apple Inc.",
    ticker="AAPL",
    price_history=[150, 160, 155, 170],
    news_history=["News1", "News2", "News3", "News4"],
    sentiment_history=["Positive", "Positive", "Neutral", "Very Positive"]
)

# Create a portfolio with $10,000
portfolio = Portfolio(starting_cash=10000)

# Buy a stock
if portfolio.buy_stock(apple, 1):
    print("Bought 1 share!")
    
# Advance to next quarter
apple.advance_quarter()

# Sell a stock
if portfolio.sell_stock(apple, 1):
    print("Sold 1 share!")

# Check portfolio value
stocks_dict = {'AAPL': apple}
total_value = portfolio.get_total_value(stocks_dict)
```

## Test the classes

Run: `python test_base_classes.py`

This will test all the functionality and show you a full game simulation.
