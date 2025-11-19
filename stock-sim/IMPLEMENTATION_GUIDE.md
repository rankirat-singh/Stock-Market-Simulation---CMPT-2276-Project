# Stock Trading Simulator - Implementation Guide

This document explains how we built the stock trading simulator. I'll walk you through what each part does and how everything fits together.

## What We've Built So Far

### The Stock Class (Stock.py)

This class is basically how we represent each company in the game. Think of it like a container that holds all the info about one stock.

**What it keeps track of:**
- The company's name and ticker symbol (like "Apple Inc." and "AAPL")
- How the price changes over 4 quarters - we store all 4 prices in a list
- News headlines for each quarter (so players know what's happening)
- Sentiment scores (helps players decide if it's a good time to buy/sell)
- Which quarter we're currently in

**What can one do with it:**
- Check the current price for whatever quarter we're in
- Look at the previous quarter's price to compare
- Calculate how much the price went up or down (as a percentage)
- Get the news and sentiment for the current quarter
- Move forward to the next quarter
- Reset everything back to Quarter 1
- Get a little arrow (↑ ↓ or →) showing if the price went up, down, or stayed flat

### The Portfolio Class (Portfolio.py)

This handles all the player's money and stocks they own. It's like their brokerage account.

**What it tracks:**
- How much cash the player has right now
- Their starting amount (we give them $10,000 to start)
- Which stocks they own and how many shares (stored as something like `{'AAPL': 2, 'MSFT': 1}`)
- A history of every trade they've made

**What you can do with it:**
- Buy stocks (but only if you have enough money!)
- Sell stocks (but only if you actually own them)
- Check how many shares you own of any stock
- Calculate your total net worth (cash plus the value of all your stocks)
- See if you're making money or losing money
- Check if you can afford something before buying
- Reset everything back to the starting state

## How to Test It

I made a test script called `simple_test.py` that checks if everything's working. Just run:

```bash
python simple_test.py
```

If it's working see something like:

```
Creating a stock...
Stock: Apple Inc. (AAPL)
Q1 Price: $150
News: Strong sales

Advancing to Q2...
Q2 Price: $160
Change: ↑ 6.67%

==================================================
Creating portfolio...
Starting cash: $10000

Buying 1 share of AAPL...
✓ Success!
Cash: $9840
Holdings: {'AAPL': 1}

Portfolio value: $10000

 All tests passed!
```

## How the Game Actually Works

Here's the basic flow I had in mind:

1. **Starting Out:** 
   - It's Quarter 1
   - You've got $10,000 in cash
   - You don't own any stocks yet

2. **Each Quarter (repeats 4 times):**
   - The game shows you 3 different stocks with their current prices
   - You pick ONE action: Buy a stock, Sell a stock, or Hold (do nothing)
   - Once you decide, we move to the next quarter
   - You can see how prices changed and what your portfolio is worth now

3. **The End (after Quarter 4):**
   - We calculate what your whole portfolio is worth
   - If it's more than $10,000, you win!
   - If it's $10,000 or less, you lose



## The Stock Data We're Using

I set up data for 3 stocks. The prices are designed to make the game interesting - some go up, some go down, there's a bit of risk involved.

**Apple (AAPL):**
- Prices across quarters: $150 → $160 → $155 → $170
- News: "Strong iPhone sales" → "Services revenue up" → "Minor dip" → "Record quarter"
- Overall sentiment: Mostly positive, one neutral quarter

**Microsoft (MSFT):**
- Prices: $300 → $290 → $310 → $320
- News: "Cloud growth slows" → "AI investments" → "Azure revenue up" → "Strong finish"
- Sentiment: Starts shaky but gets better

**Tesla (TSLA):**
- Prices: $200 → $220 → $240 → $230
- News: "Production delays" → "New factory opens" → "Record deliveries" → "Competition concerns"
- Sentiment: Pretty volatile - goes from negative to very positive and back to neutral

## What's Working (Checklist)

Just to keep track of what we've tested and confirmed:

- [x] Stock prices update correctly each quarter
- [x] Moving between quarters works properly
- [x] Price change calculations are accurate
- [x] Buying stocks works (and checks if you have enough money)
- [x] Selling stocks works (and checks if you own enough shares)
- [x] Portfolio value calculations are correct
- [x] Profit/loss tracking works
- [x] All the tests pass

---
