class Stock:
    """Represent a single stock in the trading simulator
    
    Attributes:
        name (str): Full Company name
        ticker (str): Stock ticker symbol
        price_history (list): List of prices for each quarter
        news_history: List of news headlines for each quarter
        sentiment_history: List of sentiment indicators for each quarter
        current_quarter (int) Current quarter index
        """

    def __init__(self, name, ticker, price_history, news_history, sentiment_history):
        self.name = name
        self.ticker = ticker
        self.price_history = price_history
        self.news_history = news_history
        self.sentiment_history = sentiment_history
        self.current_quarter = 0

    def get_current_price(self):
        return self.price_history[self.current_quarter]

    def get_previous_price(self):
        if (self.current_quarter == 0):
            return self.price_history[0]
        else:
            return self.price_history[self.current_quarter - 1]

    def get_price_change_percent(self):
        previous = self.get_previous_price()
        current = self.get_current_price()

        if previous == 0:
            return 0.0

        change = ((current - previous) / previous) * 100
        return round(change, 2)

    def get_current_news(self):
        return self.news_history[self.current_quarter]

    def get_current_sentiment(self):
        return self.sentiment_history[self.current_quarter]

    def advance_quarter(self):
        if (self.current_quarter < len(self.price_history) - 1):
            self.current_quarter += 1
        else:
            return None

    def reset(self):
        self.current_quarter = 0

    def get_trend_symbol(self):
        change = self.get_price_change_percent()
        if change > 0:
            return "UP"
        elif change < 0:
            return "DOWN"
        else:
            return "FLAT"

    def get_sma(self, period=3):
        """Calculate Simple Moving Average for the given period"""
        if self.current_quarter + 1 < period:
            return None
        
        prices = self.price_history[:self.current_quarter+1]
        if len(prices) < period:
            return None
            
        recent_prices = prices[-period:]
        return sum(recent_prices) / period

    def get_volatility(self):
        """Calculate volatility (standard deviation) of prices seen so far"""
        prices = self.price_history[:self.current_quarter+1]
        if len(prices) < 2:
            return 0.0
            
        mean = sum(prices) / len(prices)
        variance = sum([((x - mean) ** 2) for x in prices]) / len(prices)
        return variance ** 0.5

    def get_rsi(self, period=14):
        """Calculate Relative Strength Index"""
        prices = self.price_history[:self.current_quarter+1]
        if len(prices) < period + 1:
            return 50.0 # Default neutral value if not enough data
            
        gains = []
        losses = []
        
        for i in range(1, len(prices)):
            change = prices[i] - prices[i-1]
            if change > 0:
                gains.append(change)
                losses.append(0)
            else:
                gains.append(0)
                losses.append(abs(change))
                
        # Simple average for the first step (simplified RSI)
        avg_gain = sum(gains[-period:]) / period
        avg_loss = sum(losses[-period:]) / period
        
        if avg_loss == 0:
            return 100.0
            
        rs = avg_gain / avg_loss
        rsi = 100 - (100 / (1 + rs))
        return rsi

    def get_volume(self):
        """Get trading volume for current quarter"""
        # Mock volume calculation based on price movement
        # In a real app, this would come from data
        price = self.get_current_price()
        change = abs(self.get_price_change_percent())
        base_volume = 1000000
        
        # Higher volume on higher volatility
        volume = base_volume * (1 + (change / 10))
        return int(volume)

    def __str__(self):
        """String represenation for degguging"""
        return f"{self.ticker}: ${self.get_current_price()} ({self.get_trend_symbol()} {self.get_price_change_percent()}%)"
