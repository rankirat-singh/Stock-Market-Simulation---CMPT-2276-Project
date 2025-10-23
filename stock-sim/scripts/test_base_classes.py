from Stock import Stock
from Portfolio import Portfolio

def test_stock_class():
    print("-"*60)
    print("TESTING STOCK CLASS")
    print("-"*60)

    apple = Stock(
        name = "Apple Inc.",
        ticker="AAPL",
        price_history=[150, 160, 155, 170],
        news_history=[
            "Strong iPhone sales",
            "Services revenue up",
            "Minor dip",
            "Record quarter"
        ],
        sentiment_history= ["Positive", "Positive", "Neutral", "Very Positve"] 
    )

    print(f"\n Stock Created: {apple.name} ({apple.ticker})")
    print(f"\tQuarter 1 price: ${apple.get_current_price()}")
    print(f"\tNews: {apple.get_current_news()}")
    print(f"\tSentiment: {apple.get_current_sentiment()}")

    print(f"\n Advancing to Quarter 2...")
    apple.advance_quarter()
    print(f"\tCurrent Price: ${apple.get_current_price()}")
    print(f"\tPrevious Price: ${apple.get_previous_price()}")
    print(f"\tChange: {apple.get_trend_symbol()} {apple.get_price_change_percent()}%")
    print(f"\tNews: {apple.get_current_news()}")

    
    print(f"\n Advancing to Quarter 3...")
    apple.advance_quarter()
    print(f"\tCurrent Price: ${apple.get_current_price()}")
    print(f"\tPrevious Price: ${apple.get_previous_price()}")
    print(f"\tChange: {apple.get_trend_symbol()} {apple.get_price_change_percent()}%")
    print(f"\tNews: {apple.get_current_news()}")

    
    print(f"\n Advancing to Quarter 4...")
    apple.advance_quarter()
    print(f"\tCurrent Price: ${apple.get_current_price()}")
    print(f"\tPrevious Price: ${apple.get_previous_price()}")
    print(f"\tChange: {apple.get_trend_symbol()} {apple.get_price_change_percent()}%")
    print(f"\tNews: {apple.get_current_news()}")


    print("\n\tResetting stock to Quarter 1...")
    apple.reset()
    print(f"\tCurrent Price: ${apple.get_current_price()}")

    print("\n\tStock class test complete!\n")


def test_portfolio_class():
    print("-"*60)
    print("TESTING PORTFOLIO CLASS")
    print("-"*60)

    portfolio = Portfolio(starting_cash=10000)
    print(f"\n\tPortfolio Created:")
    print(f"\tStarting Cash: ${portfolio.cash}")
    print(f"\tHoldings: {portfolio.holdings}") 


    apple = Stock("Apple Inc.", "AAPL", [150, 160, 155, 170], 
                  ["News1", "News2", "News3", "News4"],
                  ["Pos", "Pos", "Neu", "Pos"])
    
    microsoft = Stock("Microsoft", "MSFT", [300, 290, 310, 320],
                      ["News1", "News2", "News3", "News4"],
                      ["Neu", "Neg", "Pos", "Pos"])
    
    stocks_dict = {'AAPL': apple, 'MSFT': microsoft}


    print("\nTesting BUY:")
    print(f"\t Attempting to buy 1 share of AAPL at ${apple.get_current_price()}")
    
    
    if portfolio.buy_stock(apple, 1):
        print(f"\t Purchase Successful!")
        print(f"\tCash remaining: ${portfolio.cash}")
        print(f"\t Holdinds: {portfolio.holdings}")
        print(f"\t Portfolio Value: ${portfolio.get_total_value(stocks_dict)}")
    else:
        print(f" Purchase Failed (insufficient funds)")
    
    print(F"\n\tAttempting to buy 1 share of MSFT at ${microsoft.get_current_price()}")
    
    if portfolio.buy_stock(microsoft, 1):
        print(f"\t Purchase successful!")
        print(f"\t Cash remaining: ${portfolio.cash}")
        print(f"\t Holdings: {portfolio.holdings}")
        print(f"\tPortfolio value: ${portfolio.get_total_value(stocks_dict)}")
    else:
        print(f"\t Purchase Failed (insufficient funds)")

    print("\nTESTING SELLING: ")
    print(f"\t Attempting to sell 1 share of AAPL at ${apple.get_current_price()}")

    if portfolio.sell_stock(apple, 1):
        print(f"\t Sale Successful!")
        print(f" Cash: ${portfolio.cash}")
        print(f"\tHoldings: {portfolio.holdings}")
        print(f"\t Portfolio value: ${portfolio.get_total_value(stocks_dict)}")
    else:
        print(f"\tSale failed (insufficient shares)")
    
    print(f"\nCan afford another MSFT share? {portfolio.can_afford(microsoft,1)}")
    print(f"\t (Would cost ${microsoft.get_current_price()}, have ${portfolio.cash})")

    print("\n  Advancing to Quarter 2 (prices change)...")
    apple.advance_quarter()
    microsoft.advance_quarter()
    print(f"\t AAPL: ${apple.get_previous_price()} -> ${apple.get_current_price()}")
    print(f"\t MSFT: ${microsoft.get_previous_price()} -> ${microsoft.get_current_price()}")
    print(f"\t Portfolio value: ${portfolio.get_total_value(stocks_dict)}")
    print(f"\t Profit/Loss: ${portfolio.get_profit_loss(stocks_dict)} ({portfolio.get_profit_loss_percent(stocks_dict)}%)")

    print("\n TESTING SELL:")
    print(f"\tAttempting to sell 1 share of AAPL at ${apple.get_current_price()}")

    if portfolio.sell_stock(apple,1):
        print(f"\t Sale Successful!")
        print(f"\tCash: ${portfolio.cash}")
        print(f"\tHoldings: {portfolio.holdings}")
        print(f"\t Profit/Loss: ${portfolio.get_profit_loss(stocks_dict)}, ({portfolio.get_profit_loss_percent(stocks_dict)}%)")

    
    print("\n TESTING SELL:")
    print(f"\tAttempting to sell 1 share of AAPL at ${apple.get_current_price()}")
    
    if portfolio.sell_stock(apple, 1):
        print(f"\t✓ Sale successful!")
        print(f"\tCash: ${portfolio.cash}")
        print(f"\tHoldings: {portfolio.holdings}")
        print(f"\tPortfolio value: ${portfolio.get_total_value(stocks_dict)}")
    else:
        print(f"\tSale failed (insufficient shares)")

    
    print(f"\n   Attempting to sell AAPL again (don't own any)...")
    if portfolio.sell_stock(apple, 1):
        print(f"    Sale successful!")
    else:
        print(f"   Sale failed (don't own any shares) - This is correct!")
    

    print(f"\n📜 Transaction History:")
    for i, transaction in enumerate(portfolio.transaction_history, 1):
        print(f"   {i}. {transaction['type']} {transaction['shares']} {transaction['ticker']} @ ${transaction['price']}")
    

    print("\n Resetting portfolio...")
    portfolio.reset()
    print(f"   Cash: ${portfolio.cash}")
    print(f"   Holdings: {portfolio.holdings}")
    print(f"   Transactions: {len(portfolio.transaction_history)}")
    
    print("\n Portfolio class test complete!\n")

def test_integration():
    """Test Stock and Portfolio working together"""
    print("=" * 60)
    print("INTEGRATION TEST: FULL GAME SIMULATION")
    print("=" * 60)
    
    # Create 3 stocks for 4 quarters
    stocks = {
        'AAPL': Stock("Apple Inc.", "AAPL", [150, 160, 155, 170],
                      ["iPhone sales", "Services up", "Dip", "Record"],
                      ["Pos", "Pos", "Neu", "V.Pos"]),
        'MSFT': Stock("Microsoft", "MSFT", [300, 290, 310, 320],
                      ["Cloud slow", "AI invest", "Azure up", "Strong"],
                      ["Neu", "Neg", "Pos", "Pos"]),
        'TSLA': Stock("Tesla", "TSLA", [200, 220, 240, 230],
                      ["Delays", "Factory", "Deliveries", "Competition"],
                      ["Neg", "Pos", "V.Pos", "Neu"])
    }
    
    portfolio = Portfolio(10000)
    
    print("\n Starting Game Simulation...")
    print(f"Starting Portfolio: ${portfolio.cash}\n")
    
    # Quarter 1: Buy AAPL
    print("--- QUARTER 1 ---")
    print("Available Stocks:")
    for ticker, stock in stocks.items():
        print(f"  {ticker}: ${stock.get_current_price()} - {stock.get_current_sentiment()}")
    
    print("\n Player Decision: BUY 1 AAPL")
    portfolio.buy_stock(stocks['AAPL'], 1)
    print(f"Cash: ${portfolio.cash}, Holdings: {portfolio.holdings}")
    print(f"Portfolio Value: ${portfolio.get_total_value(stocks)}")
    
    
    for stock in stocks.values():
        stock.advance_quarter()
    
    
    print("\n--- QUARTER 2 ---")
    print("Price Changes:")
    for ticker, stock in stocks.items():
        print(f"  {ticker}: ${stock.get_previous_price()} → ${stock.get_current_price()} ({stock.get_trend_symbol()}{stock.get_price_change_percent()}%)")
    
    print("\n  Player Decision: HOLD")
    print(f"Portfolio Value: ${portfolio.get_total_value(stocks)}")
    print(f"P/L: ${portfolio.get_profit_loss(stocks)} ({portfolio.get_profit_loss_percent(stocks)}%)")
    
    
    for stock in stocks.values():
        stock.advance_quarter()
    
    # Quarter 3: Buy TSLA
    print("\n--- QUARTER 3 ---")
    print("Price Changes:")
    for ticker, stock in stocks.items():
        print(f"  {ticker}: ${stock.get_previous_price()} → ${stock.get_current_price()} ({stock.get_trend_symbol()}{stock.get_price_change_percent()}%)")
    
    print("\n Player Decision: BUY 1 TSLA")
    portfolio.buy_stock(stocks['TSLA'], 1)
    print(f"Cash: ${portfolio.cash}, Holdings: {portfolio.holdings}")
    print(f"Portfolio Value: ${portfolio.get_total_value(stocks)}")
    

    for stock in stocks.values():
        stock.advance_quarter()
    
    print("\n--- QUARTER 4 (FINAL) ---")
    print("Price Changes:")
    for ticker, stock in stocks.items():
        print(f"  {ticker}: ${stock.get_previous_price()} → ${stock.get_current_price()} ({stock.get_trend_symbol()}{stock.get_price_change_percent()}%)")
    
    print("\n Player Decision: SELL AAPL")
    portfolio.sell_stock(stocks['AAPL'], 1)
    print(f"Cash: ${portfolio.cash}, Holdings: {portfolio.holdings}")
    
    # Final Results
    final_value = portfolio.get_total_value(stocks)
    profit_loss = portfolio.get_profit_loss(stocks)
    profit_loss_percent = portfolio.get_profit_loss_percent(stocks)
    
    print("\n" + "=" * 60)
    print(" GAME OVER - FINAL RESULTS")
    print("=" * 60)
    print(f"Starting Value:  ${portfolio.starting_cash}")
    print(f"Final Value:     ${final_value}")
    print(f"Profit/Loss:     ${profit_loss} ({profit_loss_percent}%)")
    
    if final_value > portfolio.starting_cash:
        print("Result:           YOU WON! Beat the market!")
    else:
        print("Result:           YOU LOST. Try again!")
    
    print("\n✅ Integration test complete!\n")


if __name__ == "__main__":
    print("\n" + "TESTING BASE CLASSES FOR STOCK TRADING SIMULATOR" + "\n")
    
    # Run all tests
    test_stock_class()
    test_portfolio_class()
    test_integration()
    
    print("=" * 60)
    print("ALL TESTS COMPLETED SUCCESSFULLY! ✅")
    print("=" * 60)
   