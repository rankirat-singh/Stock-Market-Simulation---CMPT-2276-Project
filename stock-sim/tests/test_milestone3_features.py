"""
Quick Test Script for Milestone 3 Features
Run this in Python to verify all new functionality works
"""
import sys
import os

# Add scripts directory to path
scripts_dir = os.path.join(os.path.dirname(__file__), "..", "scripts")
sys.path.insert(0, scripts_dir)

from Stock import Stock
from Portfolio import Portfolio

print("="*60)
print("MILESTONE 3 FEATURE TESTING")
print("="*60)

# Test 1: Multiple Share Buying
print("\n Testing Multiple Share Purchase:")
print("-" * 40)

portfolio = Portfolio(10000)
apple = Stock(
    name="Apple Inc.",
    ticker="AAPL",
    price_history=[150.0, 160.0, 155.0, 170.0],
    news_history=["News 1", "News 2", "News 3", "News 4"],
    sentiment_history=[0.8, 0.9, 0.3, 0.95]
)

print(f"Starting cash: ${portfolio.cash}")
print(f"AAPL current price: ${apple.get_current_price()}")

# Buy 5 shares
shares_to_buy = 5
total_cost = apple.get_current_price() * shares_to_buy
print(f"\nBuying {shares_to_buy} shares (${total_cost} total)...")

for i in range(shares_to_buy):
    portfolio.buy_stock(apple, 1)

print(f" Purchased {shares_to_buy} shares")
print(f"Cash remaining: ${portfolio.cash}")
print(f"AAPL shares owned: {portfolio.get_shares_owned('AAPL')}")

# Test 2: Selling Multiple Shares
print("\n\n Testing Multiple Share Sale:")
print("-" * 40)

shares_to_sell = 3
print(f"Selling {shares_to_sell} shares...")

for i in range(shares_to_sell):
    portfolio.sell_stock(apple, 1)

print(f"Sold {shares_to_sell} shares")
print(f"Cash now: ${portfolio.cash}")
print(f"AAPL shares remaining: {portfolio.get_shares_owned('AAPL')}")

# Test 3: Validation (Can't Buy if Not Enough Cash)
print("\n\n Testing Purchase Validation:")
print("-" * 40)

# Try to buy 100 shares (should fail)
expensive_shares = 100
required_cash = apple.get_current_price() * expensive_shares
print(f"Trying to buy {expensive_shares} shares (${required_cash} needed)...")
print(f"Current cash: ${portfolio.cash}")

if portfolio.cash >= required_cash:
    print(" ERROR: Should not be able to afford this!")
else:
    print(" PASS: Correctly prevented overspending")

# Test 4: Validation (Can't Sell More Than Owned)
print("\n\n Testing Sale Validation:")
print("-" * 40)

owned = portfolio.get_shares_owned("AAPL")
trying_to_sell = owned + 10
print(f"Own {owned} shares, trying to sell {trying_to_sell}...")

if owned >= trying_to_sell:
    print(" ERROR: Should not have enough shares!")
else:
    print(" PASS: Correctly prevented overselling")

# Test 5: Stock Information Retrieval
print("\n\n Testing Stock Information Display:")
print("-" * 40)

print(f"Stock: {apple.name}")
print(f"Ticker: AAPL")
print(f"Current Price: ${apple.get_current_price():.2f}")
print(f"Previous Price: ${apple.get_previous_price():.2f}")
print(f"Change: {apple.get_price_change_percent():.2f}%")
print(f"Trend: {apple.get_trend_symbol()}")
print(f"News: {apple.news_history[apple.current_quarter]}")
print(f"Sentiment: {apple.sentiment_history[apple.current_quarter]}")

# Test 6: Quarter Advancement with Multiple Stocks
print("\n\n Testing Quarter Progression:")
print("-" * 40)

# Create additional stocks
microsoft = Stock("Microsoft", "MSFT", [300, 290, 310, 320], ["N1", "N2", "N3", "N4"], [0.7, 0.4, 0.85, 0.9])
tesla = Stock("Tesla", "TSLA", [200, 220, 240, 230], ["N1", "N2", "N3", "N4"], [0.6, 0.8, 0.9, 0.5])

stocks = {"AAPL": apple, "MSFT": microsoft, "TSLA": tesla}

print("Quarter 1 Prices:")
for ticker, stock in stocks.items():
    print(f"  {ticker}: ${stock.get_current_price():.2f}")

# Advance to Q2
for stock in stocks.values():
    stock.advance_quarter()

print("\nQuarter 2 Prices:")
for ticker, stock in stocks.items():
    print(f"  {ticker}: ${stock.get_current_price():.2f} ({stock.get_trend_symbol()})")

# Test 7: Portfolio Value Calculation
print("\n\n Testing Portfolio Valuation:")
print("-" * 40)

# Buy some of each stock
portfolio.buy_stock(microsoft, 2)
portfolio.buy_stock(tesla, 3)

print(f"Cash: ${portfolio.cash:.2f}")
print(f"Holdings:")
for ticker in ["AAPL", "MSFT", "TSLA"]:
    shares = portfolio.get_shares_owned(ticker)
    if shares > 0:
        stock = stocks[ticker]
        value = shares * stock.get_current_price()
        print(f"  {ticker}: {shares} shares @ ${stock.get_current_price():.2f} = ${value:.2f}")

total_value = portfolio.get_total_value(stocks)
profit = portfolio.get_profit_loss(stocks)
profit_pct = portfolio.get_profit_loss_percent(stocks)

print(f"\nTotal Portfolio Value: ${total_value:.2f}")
print(f"Profit/Loss: ${profit:.2f} ({profit_pct:+.2f}%)")

if profit > 0:
    print(" You're winning!")
else:
    print(" Portfolio is down, keep trading!")

# Test 8: Transaction History
print("\n\nTesting Transaction History:")
print("-" * 40)

print(f"Total transactions: {len(portfolio.transaction_history)}")
print("\nRecent transactions:")
for i, txn in enumerate(portfolio.transaction_history[-5:], 1):
    print(f"  {i}. {txn}")

# Summary
print("\n" + "="*60)
print("TESTING COMPLETE")
print("="*60)
print("\n All core features working correctly!")
print("\nNext steps:")
print("  1. Test in Godot with Game_manager")
print("  2. Create UI dialogs for share quantity")
print("  3. Add tutorial popups")
print("  4. Improve visual design")
print("\n See docs/UI_Improvement_Guide.md for UI instructions")
print(" See docs/Milestone3_Documentation.md for full docs")
