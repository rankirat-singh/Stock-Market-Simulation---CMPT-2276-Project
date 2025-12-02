import os
import sys
import unittest



CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(CURRENT_DIR)          # stock-sim/
SCRIPTS_DIR = os.path.join(PROJECT_ROOT, "scripts")  # stock-sim/scripts

if SCRIPTS_DIR not in sys.path:
    sys.path.insert(0, SCRIPTS_DIR)

from Stock import Stock
from Portfolio import Portfolio


class TestStock(unittest.TestCase):
    def setUp(self):
        # Simple, realistic price history over 4 quarters
        self.prices = [100.0, 110.0, 105.0, 120.0]
        self.news = [
            "Strong Q1 earnings",
            "New product launch",
            "Market correction",
            "Record holiday sales",
        ]
        self.sentiment = [0.8, 0.9, 0.3, 0.95]

        self.stock = Stock(
            name="Test Corp.",
            ticker="TST",
            price_history=self.prices,
            news_history=self.news,
            sentiment_history=self.sentiment,
        )

    def test_stock_string_representation(self):
        s = str(self.stock)
        self.assertIn("TST", s)
        self.assertIn("$", s)

    def test_initial_state(self):
        """Stock starts at quarter 0 with correct price and neutral change."""
        self.assertEqual(self.stock.current_quarter, 0)
        self.assertEqual(self.stock.get_current_price(), 100.0)
        self.assertEqual(self.stock.get_previous_price(), 100.0)  # special-case first quarter
        self.assertEqual(self.stock.get_price_change_percent(), 0.0)
        self.assertEqual(self.stock.get_trend_symbol(), "FLAT")

        # Not enough data for SMA/volatility/RSI yet
        self.assertIsNone(self.stock.get_sma(period=3))
        self.assertEqual(self.stock.get_volatility(), 0.0)
        self.assertEqual(self.stock.get_rsi(), 50.0)  # default neutral

    def test_advance_quarter_updates_price_and_trend(self):
        """Advancing quarter moves through price history and changes trend."""
        # Move to Q2 (index 1)
        self.stock.advance_quarter()
        self.assertEqual(self.stock.current_quarter, 1)
        self.assertEqual(self.stock.get_current_price(), 110.0)
        self.assertEqual(self.stock.get_previous_price(), 100.0)
        self.assertEqual(self.stock.get_price_change_percent(), 10.0)
        self.assertEqual(self.stock.get_trend_symbol(), "UP")

        # Move to Q3 (index 2) -> price went down
        self.stock.advance_quarter()
        self.assertEqual(self.stock.current_quarter, 2)
        self.assertEqual(self.stock.get_current_price(), 105.0)
        self.assertEqual(self.stock.get_trend_symbol(), "DOWN")

    def test_cannot_advance_past_last_quarter(self):
        """advance_quarter should stop at the last quarter."""
        # Advance 10 times – more than enough to hit the end
        for _ in range(10):
            self.stock.advance_quarter()

        # We should be stuck at the last valid index
        self.assertEqual(self.stock.current_quarter, len(self.prices) - 1)
        self.assertEqual(self.stock.get_current_price(), 120.0)

    def test_reset_sets_back_to_first_quarter(self):
        """reset() should return the stock to quarter 0."""
        self.stock.advance_quarter()
        self.stock.advance_quarter()
        self.assertNotEqual(self.stock.current_quarter, 0)

        self.stock.reset()
        self.assertEqual(self.stock.current_quarter, 0)
        self.assertEqual(self.stock.get_current_price(), 100.0)

    def test_sma_volatility_rsi_after_enough_data(self):
        """SMA, volatility and RSI should be meaningful once there is enough data."""
        # Move to last quarter so all prices are included
        for _ in range(3):
            self.stock.advance_quarter()

        # SMA(3) over [110, 105, 120]
        sma = self.stock.get_sma(period=3)
        expected_sma = (110.0 + 105.0 + 120.0) / 3.0
        self.assertAlmostEqual(sma, expected_sma, places=3)

        # Volatility (std dev) over all 4 prices
        vol = self.stock.get_volatility()
        # Precomputed using same formula as in Stock.get_volatility
        expected_vol = 7.39509972887452
        self.assertAlmostEqual(vol, expected_vol, places=3)

        # RSI should be between 0 and 100 and not default 50 anymore
        rsi = self.stock.get_rsi(period=3)
        self.assertIsInstance(rsi, float)
        self.assertGreaterEqual(rsi, 0.0)
        self.assertLessEqual(rsi, 100.0)
        self.assertNotEqual(rsi, 50.0)

    def test_volume_increases_with_price_change(self):
        """Higher price change should result in higher volume."""
        # Low-volatility stock
        low_vol_stock = Stock(
            name="LowVol",
            ticker="LOW",
            price_history=[100.0, 101.0, 102.0, 103.0],
            news_history=self.news,
            sentiment_history=self.sentiment,
        )
        # High-volatility stock
        high_vol_stock = Stock(
            name="HighVol",
            ticker="HIGH",
            price_history=[100.0, 150.0, 50.0, 200.0],
            news_history=self.news,
            sentiment_history=self.sentiment,
        )

        # Move both to last quarter
        for _ in range(3):
            low_vol_stock.advance_quarter()
            high_vol_stock.advance_quarter()

        low_volume = low_vol_stock.get_volume()
        high_volume = high_vol_stock.get_volume()

        self.assertIsInstance(low_volume, int)
        self.assertIsInstance(high_volume, int)
        self.assertGreater(high_volume, low_volume)

    def test_news_and_sentiment_move_with_quarter(self):
        """News and sentiment should align with the current quarter."""
        # Q1
        self.assertEqual(self.stock.get_current_news(), self.news[0])
        self.assertEqual(self.stock.get_current_sentiment(), self.sentiment[0])

        # Q2
        self.stock.advance_quarter()
        self.assertEqual(self.stock.get_current_news(), self.news[1])
        self.assertEqual(self.stock.get_current_sentiment(), self.sentiment[1])

        # Q3
        self.stock.advance_quarter()
        self.assertEqual(self.stock.get_current_news(), self.news[2])
        self.assertEqual(self.stock.get_current_sentiment(), self.sentiment[2])


class TestPortfolio(unittest.TestCase):
    def setUp(self):
        self.portfolio = Portfolio(starting_cash=10000.0)

        # Simple stock objects for testing
        prices_a = [100.0, 110.0, 120.0, 130.0]
        prices_b = [50.0, 60.0, 55.0, 70.0]

        dummy_news = ["n1", "n2", "n3", "n4"]
        dummy_sent = [0.5, 0.5, 0.5, 0.5]

        self.stock_a = Stock("Stock A", "AAA", prices_a, dummy_news, dummy_sent)
        self.stock_b = Stock("Stock B", "BBB", prices_b, dummy_news, dummy_sent)

        self.stocks_dict = {
            "AAA": self.stock_a,
            "BBB": self.stock_b,
        }

    def test_buy_stock_reduces_cash_and_increases_holdings(self):
        """Buying stock should reduce cash and increase holdings."""
        success = self.portfolio.buy_stock(self.stock_a, shares=10)
        self.assertTrue(success)

        expected_cost = 100.0 * 10
        self.assertAlmostEqual(self.portfolio.cash, 10000.0 - expected_cost, places=2)
        self.assertEqual(self.portfolio.get_shares_owned("AAA"), 10)
        self.assertEqual(len(self.portfolio.transaction_history), 1)
        self.assertEqual(self.portfolio.transaction_history[0]["type"], "BUY")

    def test_buy_stock_fails_when_not_enough_cash(self):
        """Cannot buy more stock than cash allows."""
        # Force very low cash
        self.portfolio.cash = 50.0
        success = self.portfolio.buy_stock(self.stock_a, shares=1)  # needs 100
        self.assertFalse(success)
        self.assertEqual(self.portfolio.get_shares_owned("AAA"), 0)
        self.assertEqual(len(self.portfolio.transaction_history), 0)

    def test_sell_stock_increases_cash_and_reduces_holdings(self):
        """Selling stock should increase cash and reduce holdings, removing ticker at 0."""
        # First buy some shares
        self.portfolio.buy_stock(self.stock_a, shares=5)
        cash_after_buy = self.portfolio.cash

        # Then sell 3
        success = self.portfolio.sell_stock(self.stock_a, shares=3)
        self.assertTrue(success)

        # Cash should go up by 3 * current price (still 100.0 at Q1)
        self.assertAlmostEqual(
            self.portfolio.cash,
            cash_after_buy + 3 * 100.0,
            places=2,
        )

        self.assertEqual(self.portfolio.get_shares_owned("AAA"), 2)
        self.assertEqual(len(self.portfolio.transaction_history), 2)
        self.assertEqual(self.portfolio.transaction_history[-1]["type"], "SELL")

        # Sell remaining 2 -> holdings should remove ticker
        success = self.portfolio.sell_stock(self.stock_a, shares=2)
        self.assertTrue(success)
        self.assertEqual(self.portfolio.get_shares_owned("AAA"), 0)
        self.assertNotIn("AAA", self.portfolio.holdings)

    def test_sell_stock_fails_if_not_enough_shares(self):
        """Cannot sell more shares than owned."""
        self.portfolio.buy_stock(self.stock_a, shares=1)
        success = self.portfolio.sell_stock(self.stock_a, shares=5)
        self.assertFalse(success)
        # Holdings unchanged at 1
        self.assertEqual(self.portfolio.get_shares_owned("AAA"), 1)

    def test_get_total_value_and_profit_loss(self):
        """Total value = cash + value of holdings at current prices."""
        # Buy 10 AAA at 100 -> spend 1000
        self.portfolio.buy_stock(self.stock_a, shares=10)  # cost = 1000
        # Buy 20 BBB at 50 -> spend 1000
        self.portfolio.buy_stock(self.stock_b, shares=20)  # cost = 1000
        # Spent 2000, remaining cash = 8000

        # Advance quarters to change prices
        for _ in range(2):  # move to Q3 (index 2)
            self.stock_a.advance_quarter()
            self.stock_b.advance_quarter()

        # Prices at Q3:
        # AAA -> 120.0, BBB -> 55.0
        expected_value = (
            self.portfolio.cash
            + 10 * self.stock_a.get_current_price()
            + 20 * self.stock_b.get_current_price()
        )
        total_value = self.portfolio.get_total_value(self.stocks_dict)
        self.assertAlmostEqual(total_value, expected_value, places=2)

        profit_loss = self.portfolio.get_profit_loss(self.stocks_dict)
        expected_pl = round(total_value - self.portfolio.starting_cash, 2)
        self.assertAlmostEqual(profit_loss, expected_pl, places=2)

        profit_loss_percent = self.portfolio.get_profit_loss_percent(self.stocks_dict)
        expected_pl_percent = round((expected_pl / self.portfolio.starting_cash) * 100, 2)
        self.assertAlmostEqual(profit_loss_percent, expected_pl_percent, places=2)

    def test_can_afford(self):
        """can_afford should match buy_stock cost logic."""
        self.assertTrue(self.portfolio.can_afford(self.stock_a, shares=50))  # 5000 <= 10000
        self.assertFalse(self.portfolio.can_afford(self.stock_a, shares=200))  # 20000 > 10000

    def test_reset_clears_portfolio(self):
        """reset() returns portfolio to initial state."""
        self.portfolio.buy_stock(self.stock_a, shares=5)
        self.portfolio.buy_stock(self.stock_b, shares=5)
        self.assertGreater(len(self.portfolio.holdings), 0)
        self.assertGreater(len(self.portfolio.transaction_history), 0)

        self.portfolio.reset()
        self.assertEqual(self.portfolio.cash, self.portfolio.starting_cash)
        self.assertEqual(self.portfolio.holdings, {})
        self.assertEqual(self.portfolio.transaction_history, [])

    def test_string_representation(self):
        """__str__ should include cash and holdings info."""
        self.portfolio.buy_stock(self.stock_a, shares=1)
        s = str(self.portfolio)
        self.assertIn("Cash", s)
        self.assertIn("AAA", s)

if __name__ == "__main__":
    result = unittest.main(exit=False)
    if result.result.wasSuccessful():
        print("\n✅✅✅ All tests passed! (Final feature tests)")