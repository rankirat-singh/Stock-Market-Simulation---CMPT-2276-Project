class Portfolio:
    """Represent the Player's portfolio (cash + stock holdings).
    
    Attributes:
        cash (float): Available cash for trading
        holdings (dict): Dictionary Mapping ticker symbols to number of shares
        transaction_history (list): List of all transactions """
    
    def __init__(self, starting_cash = 10000):
        self.cash = starting_cash
        self.starting_cash = starting_cash
        self.holdings = {}
        self.transaction_history = []
    
    def buy_stock(self, stock, shares =1):
        cost = stock.get_current_price()*shares

        if self.cash >= cost:
            self.cash -= cost

            if stock.ticker in self.holdings:
                self.holdings[stock.ticker] += shares
            else:
                self.holdings[stock.ticker] = shares
            
            transaction = {'type' : 'BUY',
                           'ticker' : stock.ticker,
                           'shares' : shares,
                           'price': stock.get_current_price(),
                           'total':cost
                        }
            
            self.transaction_history.append(transaction)
            return True
        else:
            return False
        

    def sell_stock(self, stock, shares = 1):
        if stock.ticker in self.holdings and self.holdings[stock.ticker] >= shares:
            revenue = stock.get_current_price()*shares
            self.cash += revenue

            self.holdings[stock.ticker] -= shares
            
            if self.holdings[stock.ticker] ==0:
                del self.holdings[stock.ticker]
            
            transaction = {
                'type': 'SELL',
                'ticker': stock.ticker,
                'shares': shares,
                'price': stock.get_current_price(),
                'total': revenue
            }

            self.transaction_history.append(transaction)

            return True
        else:
            return False

    def get_shares_owned(self, ticker):
        return self.holdings.get(ticker, 0)
    
    def get_total_value(self, stocks_dict):
        total = self.cash

        for ticker, shares in self.holdings.items():
            if ticker in stocks_dict:
                stock = stocks_dict[ticker]
                total += stock.get_current_price()*shares

        return round(total, 2)
            
    def get_profit_loss(self, stocks_dict):
        current_value = self.get_total_value(stocks_dict)
        return round(current_value - self.starting_cash, 2)

    def get_profit_loss_percent(self, stocks_dict):
        profit_loss = self.get_profit_loss(stocks_dict)
        percent = (profit_loss/self.starting_cash)*100
        return round(percent, 2)
    
    def can_afford(self, stock, shares = 1):
        cost = stock.get_current_price()*shares
        return self.cash >= cost
    
    def reset(self):
        self.cash = self.starting_cash
        self.holdings = {}
        self.transaction_history = []
    
    def __str__(self):
        return f"Cash; ${self.cash:.2f}, Holdings: {self.holdings}"
    

