from Stock import Stock
from Portfolio import Portfolio

print("Creating a stock...")
apple = Stock(
    name="Apple Inc.",
    ticker="AAPL",
    price_history=[150, 160, 155, 170],
    news_history=["Strong sales", "Revenue up", "Minor dip", "Record quarter"],
    sentiment_history=["Positive", "Positive", "Neutral", "Very Positive"]
)

print(f"Stock: {apple.name} ({apple.ticker})")
print(f"Q1 Price: ${apple.get_current_price()}")
print(f"News: {apple.get_current_news()}")

print("\nAdvancing to Q2...")
apple.advance_quarter()
print(f"Q2 Price: ${apple.get_current_price()}")
print(f"Change: {apple.get_trend_symbol()} {apple.get_price_change_percent()}%")

print("\n" + "="*50)
print("Creating portfolio...")
portfolio = Portfolio(10000)
print(f"Starting cash: ${portfolio.cash}")

print("\nBuying 1 share of AAPL...")
if portfolio.buy_stock(apple, 1):
    print("✓ Success!")
    print(f"Cash: ${portfolio.cash}")
    print(f"Holdings: {portfolio.holdings}")
else:
    print("✗ Failed")

stocks_dict = {'AAPL': apple}
print(f"\nPortfolio value: ${portfolio.get_total_value(stocks_dict)}")

print("\n✅ All tests passed!")
