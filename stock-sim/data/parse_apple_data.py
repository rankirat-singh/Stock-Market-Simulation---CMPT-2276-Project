import csv
from datetime import datetime

csv_path = r"C:\Users\Rankirat\Downloads\HistoricalData_1762477049315.csv"

data = []
with open(csv_path, 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        
        date = datetime.strptime(row['Date'], '%m/%d/%Y')
        close = float(row['Close/Last'].replace('$', ''))
        open_price = float(row['Open'].replace('$', ''))
        high = float(row['High'].replace('$', ''))
        low = float(row['Low'].replace('$', ''))
        
        data.append({
            'date': date,
            'open': open_price,
            'high': high,
            'low': low,
            'close': close
        })


data.sort(key=lambda x: x['date'])


DAYS_PER_CANDLE = 5  # Weekly candlesticks
all_candles = []

i = 0
while i < len(data):
    # Get a chunk of days for this candle
    chunk = data[i:i+DAYS_PER_CANDLE]
    
    if chunk:
        candle = {
            'start_date': chunk[0]['date'],
            'end_date': chunk[-1]['date'],
            'open': chunk[0]['open'],
            'high': max(d['high'] for d in chunk),
            'low': min(d['low'] for d in chunk),
            'close': chunk[-1]['close']
        }
        all_candles.append(candle)
    
    i += DAYS_PER_CANDLE

print(f"Generated {len(all_candles)} weekly candlesticks from {len(data)} days of data\n")


candles_per_quarter = len(all_candles) // 4

quarters = []
for q in range(4):
    start_idx = q * candles_per_quarter
    end_idx = (q + 1) * candles_per_quarter if q < 3 else len(all_candles)
    quarter_candles = all_candles[start_idx:end_idx]
    
    quarters.append(quarter_candles)
    
    print(f"Quarter {q+1}: {len(quarter_candles)} candlesticks")
    print(f"  Period: {quarter_candles[0]['start_date'].strftime('%Y-%m-%d')} to {quarter_candles[-1]['end_date'].strftime('%Y-%m-%d')}")
    print(f"  Price range: ${quarter_candles[0]['open']:.2f} to ${quarter_candles[-1]['close']:.2f}")
    print()

# Generate GDScript format
print("\n=== FOR GODOT GAME_MANAGER.GD ===")
print('"AAPL": [')

for q_idx, quarter_candles in enumerate(quarters):
    print(f'  # Quarter {q_idx + 1}')
    print('  [')
    for candle in quarter_candles:
        print(f'    {{"open": {candle["open"]:.2f}, "high": {candle["high"]:.2f}, "low": {candle["low"]:.2f}, "close": {candle["close"]:.2f}}},')
    print('  ],')

print(']')

print(f"\n\nTotal candlesticks: {len(all_candles)}")
print(f"Candlesticks per quarter: ~{candles_per_quarter}")
