import requests
import json
import time
import os
from datetime import datetime

# CONFIGURATION
def get_api_key():
    # Try to get from environment variable
    api_key = os.environ.get("ALPHA_VANTAGE_API_KEY")
    if api_key:
        return api_key
        
    # Try to get from secrets.json
    try:
        secrets_path = os.path.join(os.path.dirname(__file__), "secrets.json")
        with open(secrets_path, "r") as f:
            secrets = json.load(f)
            return secrets.get("API_KEY")
    except:
        pass
        
    return "YOUR_API_KEY_HERE"

API_KEY = get_api_key()
TICKERS = ["AAPL", "MSFT", "TSLA", "GOOGL", "AMZN", "NVDA"]
WEEKS_TO_FETCH = 52 # 1 year of data

def fetch_weekly_data(ticker):
    url = f"https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol={ticker}&apikey={API_KEY}"
    try:
        response = requests.get(url)
        data = response.json()
        
        if "Weekly Time Series" not in data:
            print(f"Error fetching {ticker}: {data.get('Note', data.get('Error Message', 'Unknown Error'))}")
            return None
            
        time_series = data["Weekly Time Series"]
        candles = []
        
        # Convert to list and sort by date (oldest first)
        sorted_dates = sorted(time_series.keys())
        
        # Take the most recent WEEKS_TO_FETCH
        recent_dates = sorted_dates[-WEEKS_TO_FETCH:]
        
        for date_str in recent_dates:
            week_data = time_series[date_str]
            candles.append({
                "open": float(week_data["1. open"]),
                "high": float(week_data["2. high"]),
                "low": float(week_data["3. low"]),
                "close": float(week_data["4. close"])
            })
            
        return candles
    except Exception as e:
        print(f"Exception fetching {ticker}: {e}")
        return None

def generate_gdscript_data():
    print("var stock_prices = {")
    
    for i, ticker in enumerate(TICKERS):
        print(f'    "{ticker}": [')
        
        candles = fetch_weekly_data(ticker)
        if not candles:
            print(f"        # Failed to fetch data for {ticker}")
            print("        [], [], [], []") # Empty placeholders
            print("    ],")
            continue
            
        # Split into 4 quarters
        total_candles = len(candles)
        candles_per_quarter = total_candles // 4
        
        for q in range(4):
            start_idx = q * candles_per_quarter
            # For the last quarter, take all remaining
            end_idx = (q + 1) * candles_per_quarter if q < 3 else total_candles
            
            quarter_data = candles[start_idx:end_idx]
            
            print(f"        # Quarter {q + 1} ({len(quarter_data)} weeks)")
            print("        [")
            for candle in quarter_data:
                print(f'            {{"open": {candle["open"]:.2f}, "high": {candle["high"]:.2f}, "low": {candle["low"]:.2f}, "close": {candle["close"]:.2f}}},')
            print("        ],")
            
        print("    ],")
        
        # Rate limit handling (5 calls per minute for free tier)
        if i < len(TICKERS) - 1:
            # print(f"# Waiting 15 seconds to respect API rate limits...")
            time.sleep(15)
            
    print("}")

if __name__ == "__main__":
    print(f"Using API Key: {API_KEY}")
    generate_gdscript_data()
