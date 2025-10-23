class Stock:
    """Represent a single stock in the trading simulator
    
    Attributes:
        name (str): Full Company name
        ticker (str): Stock ticker symbol
        price_history (list): List of prices for each quarter
        news_history: List of news headlines for each quarter
        sentiment_history: List of sentiment indicators for each quarter
        current_quater (int) Current quarter index
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
            return self.price_history[self.current_quarter-1]

    def get_price_change_percent(self):
        previous = self.get_previous_price()
        current = self.get_current_price()

        if previous == 0:
            return 0.0
        
        change = ((current - previous)/previous)*100
        return round(change, 2)
    
    def get_current_news(self):
        return self.news_history[self.current_quarter]
    
    def get_current_sentiment(self):
        return self.sentiment_history[self.current_quarter]
    
    def advance_quarter(self):
        if (self.current_quarter < len(self.price_history)-1):
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
    
    def __str__(self):
        """String represenation for degguging"""
        return f"{self.ticker}: ${self.get_current_price()} ({self.get_trend_symbol()} {self.get_price_change_percent()}%)"

    
    
    