extends Node2D

# Simple GDScript game manager with tutorials
var cash: float = 10000.0
var current_quarter: int = 0
var max_quarters: int = 4
var current_stock: String = "AAPL"  # Currently selected stock
var stocks_owned: Dictionary = {"AAPL": 0, "MSFT": 0, "TSLA": 0, "GOOGL": 0, "AMZN": 0, "NVDA": 0}
var buy_price: Dictionary = {"AAPL": 0.0, "MSFT": 0.0, "TSLA": 0.0, "GOOGL": 0.0, "AMZN": 0.0, "NVDA": 0.0}
var total_spent: Dictionary = {"AAPL": 0.0, "MSFT": 0.0, "TSLA": 0.0, "GOOGL": 0.0, "AMZN": 0.0, "NVDA": 0.0}
var stock_sentiment = {
	"AAPL": [0.8, 0.9, 0.3, 0.95],
	"MSFT": [0.7, 0.4, 0.85, 0.9],
	"TSLA": [0.6, 0.8, 0.9, 0.5],
	"GOOGL": [0.75, 0.8, 0.6, 0.85],
	"AMZN": [0.65, 0.7, 0.8, 0.9],
	"NVDA": [0.9, 0.95, 0.85, 0.98]
}
# Stock prices for each quarter with full OHLC data
# Format: {"ticker": [[Q1 candles], [Q2 candles], [Q3 candles], [Q4 candles]]}
# Each quarter contains multiple weekly candlesticks {open, high, low, close}
var stock_prices = {
	"AAPL": [
		# Quarter 1 (13 weeks)
		[
			{"open": 237.27, "high": 244.63, "low": 237.16, "close": 242.84},
			{"open": 241.83, "high": 250.80, "low": 241.75, "close": 248.13},
			{"open": 247.99, "high": 255.00, "low": 245.69, "close": 254.49},
			{"open": 254.77, "high": 260.10, "low": 253.06, "close": 255.59},
			{"open": 252.23, "high": 253.50, "low": 241.82, "close": 243.36},
			{"open": 244.31, "high": 247.33, "low": 233.00, "close": 236.85},
			{"open": 233.53, "high": 238.96, "low": 228.03, "close": 229.98},
			{"open": 224.00, "high": 227.03, "low": 219.38, "close": 222.78},
			{"open": 224.02, "high": 247.19, "low": 223.98, "close": 236.00},
			{"open": 229.99, "high": 234.00, "low": 225.70, "close": 227.63},
			{"open": 229.57, "high": 245.55, "low": 227.20, "close": 244.60},
			{"open": 244.15, "high": 248.69, "low": 241.84, "close": 245.55},
			{"open": 244.93, "high": 250.00, "low": 230.20, "close": 241.84},
		],
		# Quarter 2 (13 weeks)
		[
			{"open": 241.79, "high": 244.03, "low": 229.23, "close": 239.07},
			{"open": 235.54, "high": 236.16, "low": 208.42, "close": 213.49},
			{"open": 213.31, "high": 218.84, "low": 209.97, "close": 218.27},
			{"open": 221.00, "high": 225.02, "low": 217.68, "close": 217.90},
			{"open": 217.00, "high": 225.62, "low": 187.34, "close": 188.38},
			{"open": 177.20, "high": 200.61, "low": 169.21, "close": 198.15},
			{"open": 211.44, "high": 212.94, "low": 192.37, "close": 196.98},
			{"open": 193.26, "high": 209.75, "low": 189.81, "close": 209.28},
			{"open": 210.00, "high": 214.56, "low": 202.16, "close": 205.35},
			{"open": 203.10, "high": 204.10, "low": 193.25, "close": 198.53},
			{"open": 210.97, "high": 213.94, "low": 206.75, "close": 211.26},
			{"open": 207.91, "high": 209.48, "low": 193.46, "close": 195.27},
			{"open": 198.30, "high": 203.81, "low": 196.78, "close": 200.85},
		],
		# Quarter 3 (13 weeks)
		[
			{"open": 200.28, "high": 206.24, "low": 200.12, "close": 203.92},
			{"open": 204.39, "high": 206.00, "low": 195.70, "close": 196.45},
			{"open": 197.30, "high": 201.70, "low": 195.07, "close": 201.00},
			{"open": 201.62, "high": 203.67, "low": 198.96, "close": 201.08},
			{"open": 202.01, "high": 214.65, "low": 199.26, "close": 213.55},
			{"open": 212.68, "high": 216.23, "low": 207.22, "close": 211.16},
			{"open": 209.93, "high": 212.40, "low": 207.54, "close": 211.18},
			{"open": 212.10, "high": 215.78, "low": 211.63, "close": 213.88},
			{"open": 214.03, "high": 214.84, "low": 201.50, "close": 202.38},
			{"open": 204.50, "high": 231.00, "low": 201.68, "close": 229.35},
			{"open": 227.92, "high": 235.12, "low": 224.76, "close": 231.59},
			{"open": 231.70, "high": 233.12, "low": 223.78, "close": 227.76},
			{"open": 226.48, "high": 233.41, "low": 224.69, "close": 232.14},
		],
		# Quarter 4 (13 weeks)
		[
			{"open": 229.25, "high": 241.32, "low": 226.97, "close": 239.69},
			{"open": 239.30, "high": 240.15, "low": 225.95, "close": 234.07},
			{"open": 237.00, "high": 246.30, "low": 235.03, "close": 245.50},
			{"open": 248.30, "high": 257.60, "low": 248.12, "close": 255.46},
			{"open": 254.56, "high": 259.24, "low": 253.01, "close": 258.02},
			{"open": 257.99, "high": 259.07, "low": 244.00, "close": 245.27},
			{"open": 249.38, "high": 253.38, "low": 244.70, "close": 252.29},
			{"open": 255.88, "high": 265.29, "low": 255.43, "close": 262.82},
			{"open": 264.88, "high": 277.32, "low": 264.65, "close": 270.37},
			{"open": 270.42, "high": 273.40, "low": 266.25, "close": 268.47},
			{"open": 268.96, "high": 276.70, "low": 267.45, "close": 272.41},
			{"open": 268.81, "high": 275.43, "low": 265.32, "close": 271.49},
			{"open": 270.90, "high": 280.38, "low": 270.90, "close": 278.85},
		],
	],
	"MSFT": [
		# Quarter 1 (13 weeks)
		[
			{"open": 421.57, "high": 446.10, "low": 421.31, "close": 443.57},
			{"open": 442.60, "high": 456.16, "low": 440.50, "close": 447.27},
			{"open": 447.27, "high": 455.29, "low": 428.63, "close": 436.60},
			{"open": 436.74, "high": 440.94, "low": 426.35, "close": 430.53},
			{"open": 426.06, "high": 427.55, "low": 414.85, "close": 423.35},
			{"open": 428.00, "high": 434.32, "low": 415.02, "close": 418.95},
			{"open": 415.24, "high": 434.48, "low": 410.72, "close": 429.03},
			{"open": 430.20, "high": 447.27, "low": 425.60, "close": 444.06},
			{"open": 424.01, "high": 448.38, "low": 413.16, "close": 415.06},
			{"open": 411.60, "high": 418.65, "low": 408.10, "close": 409.75},
			{"open": 413.71, "high": 415.46, "low": 404.37, "close": 408.43},
			{"open": 408.00, "high": 419.31, "low": 406.50, "close": 408.21},
			{"open": 408.51, "high": 409.37, "low": 386.57, "close": 396.99},
		],
		# Quarter 2 (13 weeks)
		[
			{"open": 398.82, "high": 402.15, "low": 381.00, "close": 393.31},
			{"open": 385.84, "high": 390.23, "low": 376.91, "close": 388.56},
			{"open": 386.70, "high": 392.70, "low": 381.10, "close": 391.26},
			{"open": 395.40, "high": 396.36, "low": 376.93, "close": 378.80},
			{"open": 372.54, "high": 385.08, "low": 359.48, "close": 359.84},
			{"open": 350.88, "high": 393.23, "low": 344.79, "close": 388.45},
			{"open": 393.22, "high": 394.65, "low": 366.89, "close": 367.78},
			{"open": 362.81, "high": 392.16, "low": 355.67, "close": 391.85},
			{"open": 391.95, "high": 439.44, "low": 384.44, "close": 435.28},
			{"open": 432.87, "high": 443.67, "low": 431.11, "close": 438.73},
			{"open": 445.94, "high": 456.19, "low": 439.78, "close": 454.27},
			{"open": 450.88, "high": 460.25, "low": 448.91, "close": 450.18},
			{"open": 456.48, "high": 462.52, "low": 455.31, "close": 460.36},
		],
		# Quarter 3 (13 weeks)
		[
			{"open": 457.14, "high": 473.33, "low": 456.89, "close": 470.38},
			{"open": 469.70, "high": 480.42, "low": 466.96, "close": 474.96},
			{"open": 475.21, "high": 483.46, "low": 474.08, "close": 477.40},
			{"open": 478.21, "high": 499.30, "low": 472.51, "close": 495.94},
			{"open": 497.04, "high": 500.76, "low": 488.70, "close": 498.84},
			{"open": 497.38, "high": 506.78, "low": 494.11, "close": 503.32},
			{"open": 501.51, "high": 514.64, "low": 501.03, "close": 510.05},
			{"open": 506.70, "high": 518.29, "low": 500.70, "close": 513.71},
			{"open": 514.08, "high": 555.45, "low": 509.44, "close": 524.11},
			{"open": 528.27, "high": 538.25, "low": 517.55, "close": 522.04},
			{"open": 522.30, "high": 532.70, "low": 519.08, "close": 520.17},
			{"open": 521.59, "high": 522.82, "low": 502.41, "close": 507.23},
			{"open": 506.63, "high": 511.09, "low": 498.51, "close": 506.69},
		],
		# Quarter 4 (13 weeks)
		[
			{"open": 500.46, "high": 511.97, "low": 492.37, "close": 495.00},
			{"open": 498.11, "high": 512.55, "low": 495.03, "close": 509.90},
			{"open": 508.79, "high": 519.30, "low": 505.93, "close": 517.93},
			{"open": 515.59, "high": 517.74, "low": 505.04, "close": 511.46},
			{"open": 511.50, "high": 521.60, "low": 508.88, "close": 517.35},
			{"open": 518.61, "high": 531.03, "low": 509.63, "close": 510.96},
			{"open": 516.41, "high": 517.19, "low": 506.00, "close": 513.58},
			{"open": 514.61, "high": 525.35, "low": 513.04, "close": 523.61},
			{"open": 531.78, "high": 553.72, "low": 515.10, "close": 517.81},
			{"open": 519.80, "high": 524.96, "low": 493.25, "close": 496.82},
			{"open": 500.04, "high": 513.50, "low": 497.44, "close": 510.18},
			{"open": 508.45, "high": 512.12, "low": 468.27, "close": 472.12},
			{"open": 475.00, "high": 492.63, "low": 464.89, "close": 492.01},
		],
	],
	"TSLA": [
		# Quarter 1 (13 weeks)
		[
			{"open": 352.38, "high": 389.49, "low": 348.20, "close": 389.22},
			{"open": 397.61, "high": 436.30, "low": 378.01, "close": 436.23},
			{"open": 441.09, "high": 488.54, "low": 417.64, "close": 421.06},
			{"open": 431.00, "high": 465.33, "low": 415.41, "close": 431.66},
			{"open": 419.40, "high": 427.93, "low": 373.04, "close": 410.44},
			{"open": 423.20, "high": 426.43, "low": 377.29, "close": 394.74},
			{"open": 383.21, "high": 439.74, "low": 380.07, "close": 426.50},
			{"open": 432.64, "high": 433.20, "low": 405.78, "close": 406.58},
			{"open": 394.80, "high": 419.99, "low": 384.41, "close": 404.60},
			{"open": 386.68, "high": 394.00, "low": 360.34, "close": 361.62},
			{"open": 356.21, "high": 362.70, "low": 325.10, "close": 355.84},
			{"open": 355.01, "high": 367.34, "low": 334.42, "close": 337.80},
			{"open": 338.14, "high": 342.40, "low": 273.60, "close": 292.98},
		],
		# Quarter 2 (13 weeks)
		[
			{"open": 300.34, "high": 303.94, "low": 250.73, "close": 262.67},
			{"open": 252.54, "high": 253.37, "low": 217.02, "close": 249.98},
			{"open": 245.06, "high": 249.52, "low": 222.28, "close": 248.71},
			{"open": 258.07, "high": 291.85, "low": 256.33, "close": 263.55},
			{"open": 249.31, "high": 284.99, "low": 236.00, "close": 239.43},
			{"open": 223.78, "high": 274.69, "low": 214.25, "close": 252.31},
			{"open": 258.36, "high": 261.80, "low": 233.89, "close": 241.37},
			{"open": 230.26, "high": 286.85, "low": 222.79, "close": 284.95},
			{"open": 288.98, "high": 294.86, "low": 270.78, "close": 287.21},
			{"open": 284.57, "high": 307.04, "low": 271.00, "close": 298.26},
			{"open": 321.99, "high": 351.62, "low": 311.50, "close": 349.98},
			{"open": 336.30, "high": 354.99, "low": 331.39, "close": 339.34},
			{"open": 347.35, "high": 367.71, "low": 345.29, "close": 346.46},
		],
		# Quarter 3 (13 weeks)
		[
			{"open": 343.50, "high": 355.40, "low": 273.21, "close": 295.14},
			{"open": 285.95, "high": 335.50, "low": 281.85, "close": 325.31},
			{"open": 331.29, "high": 332.36, "low": 314.74, "close": 322.16},
			{"open": 327.54, "high": 357.54, "low": 317.50, "close": 323.63},
			{"open": 319.90, "high": 325.58, "low": 293.21, "close": 315.35},
			{"open": 291.37, "high": 314.09, "low": 288.77, "close": 313.51},
			{"open": 317.73, "high": 330.90, "low": 310.50, "close": 329.65},
			{"open": 334.40, "high": 338.00, "low": 300.41, "close": 316.06},
			{"open": 318.45, "high": 330.49, "low": 297.82, "close": 302.63},
			{"open": 309.08, "high": 335.15, "low": 303.00, "close": 329.65},
			{"open": 335.00, "high": 348.98, "low": 327.02, "close": 330.56},
			{"open": 329.62, "high": 340.55, "low": 314.60, "close": 340.01},
			{"open": 338.90, "high": 355.39, "low": 331.70, "close": 333.87},
		],
		# Quarter 4 (13 weeks)
		[
			{"open": 328.23, "high": 355.87, "low": 325.60, "close": 350.84},
			{"open": 354.64, "high": 396.69, "low": 343.82, "close": 395.94},
			{"open": 423.13, "high": 432.22, "low": 402.43, "close": 426.07},
			{"open": 431.11, "high": 444.98, "low": 419.08, "close": 440.40},
			{"open": 444.35, "high": 470.75, "low": 416.57, "close": 429.83},
			{"open": 440.75, "high": 453.55, "low": 411.45, "close": 413.49},
			{"open": 423.53, "high": 441.46, "low": 417.86, "close": 439.31},
			{"open": 443.87, "high": 451.68, "low": 413.90, "close": 433.72},
			{"open": 439.98, "high": 467.00, "low": 438.69, "close": 456.56},
			{"open": 455.99, "high": 474.07, "low": 421.88, "close": 429.52},
			{"open": 439.60, "high": 449.67, "low": 382.78, "close": 404.35},
			{"open": 398.74, "high": 428.94, "low": 383.76, "close": 391.09},
			{"open": 402.17, "high": 432.93, "low": 401.09, "close": 430.17},
		],
	],
	"GOOGL": [
		# Quarter 1 (13 weeks)
		[
			{"open": 168.76, "high": 176.06, "low": 168.57, "close": 174.71},
			{"open": 173.96, "high": 195.61, "low": 173.65, "close": 189.82},
			{"open": 192.87, "high": 201.42, "low": 185.22, "close": 191.41},
			{"open": 192.62, "high": 196.75, "low": 190.15, "close": 192.76},
			{"open": 189.80, "high": 193.21, "low": 187.50, "close": 191.79},
			{"open": 193.98, "high": 201.00, "low": 190.31, "close": 192.04},
			{"open": 190.07, "high": 197.23, "low": 187.36, "close": 196.00},
			{"open": 199.07, "high": 202.29, "low": 195.20, "close": 200.21},
			{"open": 192.41, "high": 205.48, "low": 190.68, "close": 204.02},
			{"open": 200.69, "high": 207.05, "low": 183.24, "close": 185.34},
			{"open": 187.35, "high": 188.20, "low": 181.83, "close": 185.23},
			{"open": 185.60, "high": 185.96, "low": 179.08, "close": 179.66},
			{"open": 181.99, "high": 183.12, "low": 166.77, "close": 170.28},
		],
		# Quarter 2 (13 weeks)
		[
			{"open": 171.93, "high": 174.97, "low": 165.80, "close": 173.86},
			{"open": 168.26, "high": 168.46, "low": 161.37, "close": 165.49},
			{"open": 165.03, "high": 166.30, "low": 156.72, "close": 163.99},
			{"open": 167.06, "high": 170.63, "low": 153.63, "close": 154.33},
			{"open": 153.11, "high": 158.41, "low": 145.38, "close": 145.60},
			{"open": 141.55, "high": 159.55, "low": 140.53, "close": 157.14},
			{"open": 160.00, "high": 161.72, "low": 148.50, "close": 151.16},
			{"open": 148.88, "high": 166.10, "low": 146.10, "close": 161.96},
			{"open": 162.43, "high": 164.97, "low": 155.40, "close": 164.03},
			{"open": 163.00, "high": 165.39, "low": 147.84, "close": 152.75},
			{"open": 157.49, "high": 169.35, "low": 156.16, "close": 166.19},
			{"open": 164.51, "high": 176.77, "low": 162.90, "close": 168.47},
			{"open": 170.16, "high": 175.26, "low": 167.44, "close": 171.74},
		],
		# Quarter 3 (13 weeks)
		[
			{"open": 167.84, "high": 174.50, "low": 165.28, "close": 173.68},
			{"open": 174.54, "high": 181.10, "low": 172.38, "close": 174.67},
			{"open": 174.73, "high": 177.36, "low": 165.46, "close": 166.64},
			{"open": 166.27, "high": 178.68, "low": 162.00, "close": 178.53},
			{"open": 180.78, "high": 181.23, "low": 173.53, "close": 179.53},
			{"open": 179.06, "high": 181.43, "low": 172.77, "close": 180.19},
			{"open": 181.01, "high": 186.42, "low": 179.68, "close": 185.06},
			{"open": 186.25, "high": 197.95, "low": 186.15, "close": 193.18},
			{"open": 193.65, "high": 197.60, "low": 187.82, "close": 189.13},
			{"open": 190.29, "high": 202.61, "low": 190.12, "close": 201.42},
			{"open": 200.94, "high": 206.44, "low": 197.51, "close": 203.90},
			{"open": 204.20, "high": 208.54, "low": 196.59, "close": 206.09},
			{"open": 206.43, "high": 214.65, "low": 205.28, "close": 212.91},
		],
		# Quarter 4 (13 weeks)
		[
			{"open": 208.44, "high": 235.76, "low": 206.19, "close": 235.00},
			{"open": 235.47, "high": 242.25, "low": 233.23, "close": 240.80},
			{"open": 244.66, "high": 256.00, "low": 244.66, "close": 254.72},
			{"open": 254.43, "high": 255.78, "low": 240.74, "close": 246.54},
			{"open": 247.85, "high": 251.15, "low": 238.61, "close": 245.35},
			{"open": 244.78, "high": 251.32, "low": 235.84, "close": 236.57},
			{"open": 240.21, "high": 256.96, "low": 239.71, "close": 253.30},
			{"open": 254.69, "high": 261.68, "low": 244.15, "close": 259.92},
			{"open": 264.81, "high": 291.59, "low": 264.28, "close": 281.19},
			{"open": 282.18, "high": 288.35, "low": 275.19, "close": 278.83},
			{"open": 284.42, "high": 292.00, "low": 270.70, "close": 276.41},
			{"open": 285.77, "high": 306.42, "low": 278.20, "close": 299.66},
			{"open": 311.13, "high": 328.83, "low": 309.60, "close": 320.18},
		],
	],
	"AMZN": [
		# Quarter 1 (13 weeks)
		[
			{"open": 209.96, "high": 227.15, "low": 209.51, "close": 227.03},
			{"open": 227.21, "high": 231.20, "low": 224.20, "close": 227.46},
			{"open": 230.23, "high": 233.00, "low": 218.73, "close": 224.92},
			{"open": 225.01, "high": 229.14, "low": 220.90, "close": 223.75},
			{"open": 220.06, "high": 225.36, "low": 218.19, "close": 224.19},
			{"open": 226.78, "high": 228.84, "low": 216.50, "close": 218.94},
			{"open": 218.06, "high": 226.51, "low": 216.20, "close": 225.94},
			{"open": 228.90, "high": 236.40, "low": 226.94, "close": 234.85},
			{"open": 226.21, "high": 241.77, "low": 225.86, "close": 237.68},
			{"open": 234.06, "high": 242.52, "low": 228.06, "close": 229.15},
			{"open": 230.54, "high": 233.92, "low": 227.23, "close": 228.68},
			{"open": 228.82, "high": 229.30, "low": 214.74, "close": 216.58},
			{"open": 217.45, "high": 219.97, "low": 204.16, "close": 212.28},
		],
		# Quarter 2 (13 weeks)
		[
			{"open": 213.35, "high": 214.01, "low": 192.53, "close": 199.25},
			{"open": 195.60, "high": 201.52, "low": 190.85, "close": 197.95},
			{"open": 198.77, "high": 199.32, "low": 189.38, "close": 196.21},
			{"open": 200.00, "high": 206.21, "low": 191.88, "close": 192.72},
			{"open": 188.19, "high": 198.34, "low": 166.00, "close": 171.00},
			{"open": 162.00, "high": 192.65, "low": 161.38, "close": 184.87},
			{"open": 186.84, "high": 187.44, "low": 171.41, "close": 172.61},
			{"open": 169.60, "high": 189.94, "low": 165.28, "close": 188.99},
			{"open": 190.10, "high": 192.88, "low": 178.85, "close": 189.98},
			{"open": 186.51, "high": 194.69, "low": 183.85, "close": 193.06},
			{"open": 210.71, "high": 214.84, "low": 202.67, "close": 205.59},
			{"open": 201.65, "high": 206.62, "low": 197.85, "close": 200.99},
			{"open": 203.09, "high": 208.81, "low": 201.69, "close": 205.01},
		],
		# Quarter 3 (13 weeks)
		[
			{"open": 204.98, "high": 213.87, "low": 202.68, "close": 213.57},
			{"open": 214.75, "high": 218.40, "low": 209.62, "close": 212.10},
			{"open": 212.31, "high": 217.96, "low": 208.27, "close": 209.69},
			{"open": 209.79, "high": 223.30, "low": 207.31, "close": 223.30},
			{"open": 223.52, "high": 224.01, "low": 217.93, "close": 223.41},
			{"open": 223.00, "high": 226.68, "low": 218.43, "close": 225.02},
			{"open": 225.07, "high": 227.27, "low": 222.18, "close": 226.13},
			{"open": 225.84, "high": 236.00, "low": 225.65, "close": 231.44},
			{"open": 233.35, "high": 236.53, "low": 212.80, "close": 214.75},
			{"open": 217.40, "high": 226.22, "low": 211.42, "close": 222.69},
			{"open": 221.78, "high": 234.08, "low": 219.05, "close": 231.03},
			{"open": 230.22, "high": 231.91, "low": 220.50, "close": 228.84},
			{"open": 227.35, "high": 232.71, "low": 226.02, "close": 229.00},
		],
		# Quarter 4 (13 weeks)
		[
			{"open": 223.52, "high": 236.00, "low": 221.83, "close": 232.33},
			{"open": 234.94, "high": 238.85, "low": 226.29, "close": 228.15},
			{"open": 230.62, "high": 235.90, "low": 228.71, "close": 231.48},
			{"open": 230.56, "high": 230.56, "low": 216.47, "close": 219.78},
			{"open": 220.08, "high": 224.20, "low": 216.61, "close": 219.51},
			{"open": 221.00, "high": 228.25, "low": 216.00, "close": 216.37},
			{"open": 217.70, "high": 220.68, "low": 211.03, "close": 213.04},
			{"open": 213.88, "high": 225.40, "low": 213.59, "close": 224.21},
			{"open": 227.66, "high": 250.50, "low": 222.75, "close": 244.22},
			{"open": 255.36, "high": 258.60, "low": 238.49, "close": 244.41},
			{"open": 248.34, "high": 251.75, "low": 232.89, "close": 234.69},
			{"open": 233.25, "high": 234.60, "low": 215.18, "close": 220.69},
			{"open": 222.56, "high": 233.28, "low": 222.27, "close": 233.22},
		],
	],
	"NVDA": [
		# Quarter 1 (13 weeks)
		[
			{"open": 138.83, "high": 146.54, "low": 137.82, "close": 142.44},
			{"open": 138.97, "high": 141.82, "low": 132.54, "close": 134.25},
			{"open": 134.18, "high": 136.70, "low": 126.86, "close": 134.70},
			{"open": 136.28, "high": 141.90, "low": 134.71, "close": 137.01},
			{"open": 134.83, "high": 144.90, "low": 133.83, "close": 144.47},
			{"open": 148.59, "high": 153.13, "low": 134.22, "close": 135.91},
			{"open": 129.99, "high": 138.75, "low": 129.51, "close": 137.71},
			{"open": 139.16, "high": 148.97, "low": 137.09, "close": 142.62},
			{"open": 124.80, "high": 129.00, "low": 116.25, "close": 120.07},
			{"open": 114.75, "high": 130.37, "low": 113.01, "close": 129.84},
			{"open": 130.09, "high": 139.25, "low": 129.08, "close": 138.85},
			{"open": 141.27, "high": 143.44, "low": 134.03, "close": 134.43},
			{"open": 136.56, "high": 138.59, "low": 116.40, "close": 124.92},
		],
		# Quarter 2 (13 weeks)
		[
			{"open": 123.51, "high": 123.70, "low": 107.56, "close": 112.69},
			{"open": 109.90, "high": 121.88, "low": 104.77, "close": 121.67},
			{"open": 122.74, "high": 122.89, "low": 114.54, "close": 117.70},
			{"open": 119.88, "high": 122.22, "low": 109.07, "close": 109.67},
			{"open": 105.13, "high": 111.98, "low": 92.11, "close": 94.31},
			{"open": 87.46, "high": 115.10, "low": 86.62, "close": 110.93},
			{"open": 114.11, "high": 114.29, "low": 100.05, "close": 101.49},
			{"open": 98.77, "high": 111.92, "low": 95.04, "close": 111.01},
			{"open": 109.69, "high": 115.40, "low": 104.08, "close": 114.50},
			{"open": 112.91, "high": 118.68, "low": 110.82, "close": 116.65},
			{"open": 121.97, "high": 136.35, "low": 120.28, "close": 135.40},
			{"open": 132.39, "high": 137.40, "low": 129.16, "close": 131.29},
			{"open": 134.15, "high": 143.49, "low": 132.92, "close": 135.13},
		],
		# Quarter 3 (13 weeks)
		[
			{"open": 135.49, "high": 144.00, "low": 135.40, "close": 141.72},
			{"open": 143.19, "high": 145.00, "low": 140.85, "close": 141.97},
			{"open": 143.34, "high": 146.20, "low": 142.65, "close": 143.85},
			{"open": 142.50, "high": 158.71, "low": 142.03, "close": 157.75},
			{"open": 158.40, "high": 160.98, "low": 151.49, "close": 159.34},
			{"open": 158.20, "high": 167.89, "low": 157.34, "close": 164.92},
			{"open": 165.37, "high": 174.25, "low": 162.02, "close": 172.41},
			{"open": 172.75, "high": 174.72, "low": 164.58, "close": 173.50},
			{"open": 174.02, "high": 183.30, "low": 170.89, "close": 173.72},
			{"open": 175.16, "high": 183.88, "low": 174.52, "close": 182.70},
			{"open": 182.05, "high": 184.48, "low": 178.04, "close": 180.45},
			{"open": 180.60, "high": 182.94, "low": 168.80, "close": 177.99},
			{"open": 178.35, "high": 184.47, "low": 173.15, "close": 174.18},
		],
		# Quarter 4 (13 weeks)
		[
			{"open": 170.00, "high": 172.41, "low": 164.07, "close": 167.02},
			{"open": 167.55, "high": 180.28, "low": 166.74, "close": 177.82},
			{"open": 175.67, "high": 178.85, "low": 168.41, "close": 176.67},
			{"open": 175.30, "high": 184.55, "low": 173.12, "close": 178.19},
			{"open": 180.43, "high": 191.05, "low": 180.32, "close": 187.62},
			{"open": 185.50, "high": 195.62, "low": 182.05, "close": 183.16},
			{"open": 187.97, "high": 190.11, "low": 177.29, "close": 183.22},
			{"open": 183.13, "high": 187.47, "low": 176.76, "close": 186.26},
			{"open": 189.99, "high": 212.19, "low": 188.43, "close": 202.49},
			{"open": 208.08, "high": 211.34, "low": 178.91, "close": 188.15},
			{"open": 195.11, "high": 199.94, "low": 180.58, "close": 190.17},
			{"open": 185.97, "high": 196.00, "low": 172.93, "close": 178.88},
			{"open": 179.49, "high": 183.50, "low": 169.55, "close": 177.00},
		],
	],
}
var stock_names: Dictionary = {
	"AAPL": "Apple Inc.",
	"MSFT": "Microsoft Corp.",
	"TSLA": "Tesla Inc.",
	"GOOGL": "Alphabet Inc.",
	"AMZN": "Amazon.com Inc.",
	"NVDA": "NVIDIA Corp."
}

var stock_details: Dictionary = {
	"AAPL": {
		"sector": "Technology",
		"industry": "Consumer Electronics",
		"market_cap": "3.4T",
		"pe_ratio": "32.5",
		"desc": "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories."
	},
	"MSFT": {
		"sector": "Technology",
		"industry": "Software - Infrastructure",
		"market_cap": "3.1T",
		"pe_ratio": "35.2",
		"desc": "Microsoft Corporation develops, licenses, and supports software, services, devices, and solutions worldwide."
	},
	"TSLA": {
		"sector": "Consumer Cyclical",
		"industry": "Auto Manufacturers",
		"market_cap": "750B",
		"pe_ratio": "45.8",
		"desc": "Tesla, Inc. designs, develops, manufactures, leases, and sells electric vehicles, and energy generation and storage systems."
	},
	"GOOGL": {
		"sector": "Communication Services",
		"industry": "Internet Content & Information",
		"market_cap": "2.1T",
		"pe_ratio": "24.5",
		"desc": "Alphabet Inc. offers various products and platforms in the United States, Europe, the Middle East, Africa, the Asia-Pacific, Canada, and Latin America."
	},
	"AMZN": {
		"sector": "Consumer Cyclical",
		"industry": "Internet Retail",
		"market_cap": "1.9T",
		"pe_ratio": "42.1",
		"desc": "Amazon.com, Inc. engages in the retail sale of consumer products and subscriptions in North America and internationally."
	},
	"NVDA": {
		"sector": "Technology",
		"industry": "Semiconductors",
		"market_cap": "2.8T",
		"pe_ratio": "65.4",
		"desc": "NVIDIA Corporation provides graphics, compute and networking solutions in the United States, Taiwan, China, and internationally."
	}
}

# Tutorial data
var tutorials: Dictionary = {
	"welcome": {
		"title": "Welcome to Stock Trading Simulator!",
		"content": "You begin with $10,000 in cash and four decision points—one per quarter of the fiscal\nyear—to build your portfolio.\n\nYour mission: use chart data and smart timing to maximize profit.\n\nYour toolkit:\n• Buy when the stock shows strength or when the price dips\n• Sell when momentum slows or prices reach a peak\n• Hold if the market is unclear or you expect a future rise\n• Candlestick charts show price movement, trends, and reversals—use them to predict what\n   might come next\n\nPro tip: Look for patterns such as rising highs, falling lows, or even sudden spikes.\n              These help you decide whether a stock is gaining momentum or losing it."
	},
	"sma": {
		"title": "Understanding Market Trends",
		"content": "Trends help you understand where a stock is heading. The Simple Moving Average (SMA)\nsmooths out price changes so you can spot direction more easily.\n\nCandlestick basics:\n• Green candles = price increased\n• Red candles = price decreased\n• Tall candles = strong volatility\n• Short candles = stable prices\n\nTip: A rising SMA or a series of higher highs can signal upward momentum, while falling\npatterns may hint at a decline."
	},
	"sentiment": {
		"title": "Market Sentiment Analysis",
		"content": "Market sentiment reflects how investors feel about a stock. High confidence often drives\nprices up, while fear can push them down.\n\nSentiment scale:\n• High (0.7–1.0): Bullish — prices more likely to rise\n• Medium (0.4–0.6): Neutral — uncertain or sideways movement\n• Low (0.0–0.3): Bearish — prices more likely to fall\n\nTip: Sentiment reacts to news, earnings, and market events. Keep an eye on what's\n        happening to anticipate price swings."
	},
	"diversification": {
		"title": "Portfolio Diversification",
		"content": "Diversification protects your portfolio from unexpected swings. Instead of putting all your money into a\nsingle stock, spreading your investments reduces the impact of sudden price drops.\n\nWhy diversify?\n• Reduces risk by balancing losses in one stock with gains in another\n• Smooths performance since different stocks rarely move the same way\n• Helps during uncertainty when market direction is unclear\n\nHow to diversify in this simulator:\nYou have three different stocks available. Investing in more than one creates a more balanced portfolio,\nespecially as trends shift quarter to quarter.\n\nTip: Even if a stock looks strong now, markets can change quickly. Diversification gives you a safety net."
	},
	"quarter_strategy": {
		"title": "Quarter-by-Quarter Strategy",
		"content": "Plan your moves across all 4 quarters to maximize profit. Each quarter gives\nyou a chance to buy, sell, or wait based on market movement.\n\nQuarter flow:\n• Q1: Research and buy promising stocks\n• Q2–Q3: Monitor trends and adjust holdings\n• Q4: Sell to secure profits before year-end\n• Use Hold when you're unsure or waiting for a better price\n\nCommon simple strategies:\n• Buy the Dip: Buy when prices fall, expecting a rebound\n• Trend Following: Hold or buy more when a stock keeps rising\n• Take Profits Early: Sell once you're up instead of waiting for the peak\n• Risk Balancing: Mix a safer stock with a riskier one to reduce losses"
	}
}

var tutorial_dialog: AcceptDialog = null

func _ready():
	print("=== GDScript Game Manager Ready ===")
	print("Starting cash: $", cash)
	print("AAPL Q1 has ", stock_prices["AAPL"][0].size(), " candlesticks")
	print("First candle: ", stock_prices["AAPL"][0][0])
	create_tutorial_dialog()
	update_display()
	update_quarter_label()
	
	# Initialize chart with current quarter's data
	var chart = find_child("CandlestickChart", true, false)
	if chart and chart.has_method("set_stock_data"):
		print("Loading initial chart data for ", current_stock, " Q", current_quarter + 1)
		var quarter_data = stock_prices[current_stock][current_quarter]
		print("Passing ", quarter_data.size(), " candles to chart")
		chart.call("set_stock_data", quarter_data)
	else:
		print("ERROR: Chart not found or doesn't have set_stock_data method!")
	
	# Show welcome tutorial after a short delay
	call_deferred("show_tutorial", "welcome")

func create_tutorial_dialog():
	"""Create a popup dialog for tutorials"""
	tutorial_dialog = AcceptDialog.new()
	tutorial_dialog.title = "Tutorial"
	tutorial_dialog.dialog_text = ""
	tutorial_dialog.ok_button_text = "Got it!"
	tutorial_dialog.set_flag(Window.FLAG_RESIZE_DISABLED, false)
	tutorial_dialog.size = Vector2(600, 400)
	add_child(tutorial_dialog)

func show_tutorial(tutorial_key: String):
	"""Show a tutorial popup"""
	if tutorial_key in tutorials and tutorial_dialog:
		var tut = tutorials[tutorial_key]
		tutorial_dialog.title = tut["title"]
		tutorial_dialog.dialog_text = tut["content"]
		tutorial_dialog.popup_centered()
		print("Showing tutorial: ", tutorial_key)

func show_tutorial_menu():
	"""Show menu to select which tutorial to view"""
	var menu_dialog = AcceptDialog.new()
	menu_dialog.title = " Tutorials"
	var menu_text = "Choose a topic to learn about:\n\n"
	menu_text += "1. Welcome - Game basics\n"
	menu_text += "2. Market Trends - Understanding charts\n"
	menu_text += "3. Sentiment Analysis - News & feelings\n"
	menu_text += "4. Diversification - Spread your risk\n"
	menu_text += "5. Quarter Strategy - Plan your moves\n\n"
	menu_text += "Click buttons below to view tutorials!"
	
	menu_dialog.dialog_text = menu_text
	menu_dialog.ok_button_text = "Close"
	menu_dialog.size = Vector2(500, 400)
	
	# Add custom buttons for each tutorial
	menu_dialog.add_button("Welcome", false, "welcome")
	menu_dialog.add_button("Trends", false, "sma")
	menu_dialog.add_button("Sentiment", false, "sentiment")
	menu_dialog.add_button("Diversify", false, "diversification")
	menu_dialog.add_button("Strategy", false, "quarter_strategy")
	
	menu_dialog.custom_action.connect(func(action): show_tutorial(action))
	
	add_child(menu_dialog)
	menu_dialog.popup_centered()
	# Clean up after closing
	menu_dialog.confirmed.connect(func(): menu_dialog.queue_free())
	menu_dialog.canceled.connect(func(): menu_dialog.queue_free())
	
func show_performance_review(total_value: float, profit: float):
	"""Show the user's performance"""
	var menu_dialog = AcceptDialog.new()
	menu_dialog.title = " Portfolio Performance"
	
	var invested_sum = 0
	for ticker in total_spent:
		invested_sum += total_spent[ticker]
	
	var starting_amount = 10000
	var return_on_investment = 0 if invested_sum == 0 else (profit / invested_sum) * 100
	var portfolio_value_change = ((total_value - starting_amount) / starting_amount) * 100
	
	var menu_text = "Portfolio Value: %f \n\n" %total_value
	menu_text += "Profit: %f \n\n" %profit
	menu_text += "Total Invested: %f \n\n" %invested_sum
	menu_text += "Return on Invested Capital: %f%% \n\n" %return_on_investment
	menu_text += "Portfolio Return: %f%% \n\n" %portfolio_value_change
	
	menu_dialog.dialog_text = menu_text
	menu_dialog.ok_button_text = "Try Again"
	menu_dialog.size = Vector2(500, 400)
	
	add_child(menu_dialog)
	menu_dialog.popup_centered()
	menu_dialog.confirmed.connect(func(): get_tree().reload_current_scene())

func select_stock(ticker: String):
	"""Switch to viewing a different stock"""
	current_stock = ticker
	print("Selected stock: ", ticker)
	
	# Update stock name labels
	var stock_name_label = find_child("StockName", true, false)
	if stock_name_label:
		stock_name_label.set_text(stock_names[ticker])
	
	var stock_code_label = find_child("StockCode", true, false)
	if stock_code_label:
		stock_code_label.set_text(ticker)
	
	update_display()
	
	# Update chart if it exists - pass current quarter's candlesticks
	var chart = find_child("CandlestickChart", true, false)
	if chart and chart.has_method("set_stock_data"):
		chart.call("set_stock_data", stock_prices[ticker][current_quarter])

func calculate_sma(ticker: String, period: int) -> float:
	var prices = []
	for q in range(current_quarter + 1):
		var candles = stock_prices[ticker][q]
		prices.append(candles[-1]["close"])
		
	if prices.size() < period:
		return 0.0
		
	var sum = 0.0
	for i in range(period):
		sum += prices[prices.size() - 1 - i]
		
	return sum / period

func calculate_volatility(ticker: String) -> float:
	var prices = []
	for q in range(current_quarter + 1):
		var candles = stock_prices[ticker][q]
		prices.append(candles[-1]["close"])
		
	if prices.size() < 2:
		return 0.0
		
	var mean = 0.0
	for p in prices:
		mean += p
	mean /= prices.size()
	
	var variance = 0.0
	for p in prices:
		variance += pow(p - mean, 2)
	variance /= prices.size()
	
	return sqrt(variance)

func calculate_rsi(ticker: String, period: int = 14) -> float:
	# Collect all closing prices up to current quarter
	var prices = []
	for q in range(current_quarter + 1):
		var candles = stock_prices[ticker][q]
		for candle in candles:
			prices.append(candle["close"])
			
	if prices.size() < period + 1:
		return 50.0 # Not enough data
		
	var gains = []
	var losses = []
	
	# Calculate changes
	for i in range(1, prices.size()):
		var change = prices[i] - prices[i-1]
		if change > 0:
			gains.append(change)
			losses.append(0.0)
		else:
			gains.append(0.0)
			losses.append(abs(change))
			
	# Calculate RSI using simple moving average for simplicity
	# (Standard RSI uses smoothed moving average)
	var avg_gain = 0.0
	var avg_loss = 0.0
	
	var recent_gains = gains.slice(-period)
	var recent_losses = losses.slice(-period)
	
	for g in recent_gains:
		avg_gain += g
	avg_gain /= period
	
	for l in recent_losses:
		avg_loss += l
	avg_loss /= period
	
	if avg_loss == 0:
		return 100.0
		
	var rs = avg_gain / avg_loss
	return 100.0 - (100.0 / (1.0 + rs))

func get_volume(ticker: String) -> String:
	# Mock volume based on price movement
	var quarter_candles = stock_prices[ticker][current_quarter]
	var current_price = quarter_candles[-1]["close"]
	var open_price = quarter_candles[0]["open"]
	var change_pct = abs((current_price - open_price) / open_price)
	
	var base_vol = 10000000 # 10M base
	var vol = base_vol * (1.0 + (change_pct * 10.0))
	
	# Format as string (e.g. 12.5M)
	return "%.2fM" % (vol / 1000000.0)

func update_quarter_label():
	var q_label = find_child("QuarterLabel", true, false)
	if q_label:
		q_label.text = "Quarter %d of %d" % [current_quarter + 1, max_quarters]	

func update_display():
	var label = find_child("StockPrice", true, false)
	if label:
		# Get the last candlestick's close price from current quarter
		var quarter_candles = stock_prices[current_stock][current_quarter]
		var current_price = quarter_candles[-1]["close"]
		label.set_text("%.2f USD" % current_price)
	
	# Update Data Panel
	var sma_label = find_child("Value_SMA", true, false)
	if sma_label:
		var sma = calculate_sma(current_stock, 3)
		if sma > 0:
			sma_label.set_text("$%.2f" % sma)
		else:
			sma_label.set_text("N/A")
			
	var vol_label = find_child("Value_Vol", true, false)
	if vol_label:
		var vol = calculate_volatility(current_stock)
		vol_label.set_text("%.2f" % vol)
		
	var sent_label = find_child("Value_Sent", true, false)
	if sent_label:
		if current_quarter < stock_sentiment[current_stock].size():
			sent_label.set_text("%.2f" % stock_sentiment[current_stock][current_quarter])
		else:
			sent_label.set_text("0.50")

	var avg_price_label = find_child("Value_AvgPrice", true, false)
	if avg_price_label:
		if stocks_owned[current_stock] > 0:
			var avg_price = total_spent[current_stock] / stocks_owned[current_stock]
			avg_price_label.set_text("$%.2f" % avg_price)
		else:
			avg_price_label.set_text("--")

	var rsi_label = find_child("Value_RSI", true, false)
	if rsi_label:
		var rsi = calculate_rsi(current_stock)
		rsi_label.set_text("%.2f" % rsi)
		
	var vol_label_data = find_child("Value_Volume", true, false)
	if vol_label_data:
		var vol = get_volume(current_stock)
		vol_label_data.set_text(vol)

	# Update Company Info Panel
	var sector_label = find_child("Value_Sector", true, false)
	if sector_label:
		sector_label.set_text(stock_details[current_stock]["sector"])
		
	var industry_label = find_child("Value_Industry", true, false)
	if industry_label:
		industry_label.set_text(stock_details[current_stock]["industry"])
		
	var mkt_cap_label = find_child("Value_MktCap", true, false)
	if mkt_cap_label:
		mkt_cap_label.set_text(stock_details[current_stock]["market_cap"])
		
	var pe_label = find_child("Value_PE", true, false)
	if pe_label:
		pe_label.set_text(stock_details[current_stock]["pe_ratio"])
		
	var desc_label = find_child("Value_Desc", true, false)
	if desc_label:
		desc_label.set_text(stock_details[current_stock]["desc"])

	# Update Portfolio View
	update_portfolio_view()

func update_portfolio_view():
	"""Update the Portfolio View tab with current holdings"""
	var cash_value_label = find_child("CashHoldingsValue", true, false)
	if cash_value_label:
		cash_value_label.set_text("$%.2f" % cash)
	
	var stock_value_label = find_child("StockHoldingsValue", true, false)
	if stock_value_label:
		var holdings_text = ""
		for ticker in ["AAPL", "MSFT", "TSLA", "GOOGL", "AMZN", "NVDA"]:
			if stocks_owned[ticker] > 0:

				# Get Price
				var quarter_candles = stock_prices[ticker][current_quarter]
				var current_price = quarter_candles[-1]["close"]
				var value = stocks_owned[ticker] * current_price

				# Avg Price Calculation
				var avg_price = 0.0
				if stocks_owned[ticker] > 0:
					avg_price = total_spent[ticker] / stocks_owned[ticker]

				# Add Line Output Text
				holdings_text += "%s: %d shares ($%.2f)\n  Avg Buy Price: $%.2f\n  Current Price per Stock: $%.2f\n" % [
					ticker,
					stocks_owned[ticker],
					value,
					avg_price,
					current_price
				]

		if holdings_text == "":
			holdings_text = "No stocks owned"
		stock_value_label.set_text(holdings_text.strip_edges())
	
	var portfolio_value_label = find_child("PortfolioValue", true, false)
	if portfolio_value_label:
		var total_value = cash
		for ticker in ["AAPL", "MSFT", "TSLA", "GOOGL", "AMZN", "NVDA"]:
			var quarter_candles = stock_prices[ticker][current_quarter]
			var current_price = quarter_candles[-1]["close"]
			total_value += stocks_owned[ticker] * current_price
		var profit = total_value - 10000.0
		portfolio_value_label.set_text("$%.2f\n(Profit: $%.2f)" % [total_value, profit])

func buy_stock(ticker="", shares=1):
	if ticker == "":
		ticker = current_stock
	
	# Show quantity dialog
	show_quantity_dialog("buy", ticker)

func sell_stock(ticker="", shares=1):
	if ticker == "":
		ticker = current_stock
	
	# Show quantity dialog
	show_quantity_dialog("sell", ticker)

func show_quantity_dialog(action: String, ticker: String):
	"""Show dialog to input number of shares"""
	var dialog = ConfirmationDialog.new()
	dialog.title = action.capitalize() + " " + ticker
	var quarter_candles = stock_prices[ticker][current_quarter]
	var current_price = quarter_candles[-1]["close"]
	dialog.dialog_text = "How many shares?\n\nCurrent price: $%.2f\nYou own: %d shares\nCash: $%.2f" % [current_price, stocks_owned[ticker], cash]
	dialog.ok_button_text = action.capitalize()
	dialog.cancel_button_text = "Cancel"
	
	# Add SpinBox for quantity input
	var vbox = VBoxContainer.new()
	var label = Label.new()
	label.text = "Quantity:"
	var spinbox = SpinBox.new()
	spinbox.min_value = 1
	spinbox.max_value = 999
	spinbox.value = 1
	spinbox.step = 1
	spinbox.allow_greater = false
	spinbox.allow_lesser = false
	
	vbox.add_child(label)
	vbox.add_child(spinbox)
	dialog.add_child(vbox)
	
	# Connect confirmation
	dialog.confirmed.connect(func():
		var quantity = int(spinbox.value)
		if action == "buy":
			execute_buy(ticker, quantity)
		else:
			execute_sell(ticker, quantity)
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	
	add_child(dialog)
	dialog.popup_centered()

func execute_buy(ticker: String, shares: int):
	"""Actually execute the buy"""
	print("Buy clicked: ", ticker, " x", shares)
	var quarter_candles = stock_prices[ticker][current_quarter]
	var current_price = quarter_candles[-1]["close"]
	var total_cost = current_price * shares
	
	if cash >= total_cost:
		cash -= total_cost
		# Update total spent and shares
		total_spent[ticker] += total_cost

		# Update shares owned
		stocks_owned[ticker] += shares

		# Compute new average buy price
		buy_price[ticker] = total_spent[ticker] / stocks_owned[ticker]

		update_display()
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("NOT ENOUGH CASH!\nNeed: $%.2f\nHave: $%.2f" % [total_cost, cash])

func execute_sell(ticker: String, shares: int):
	print("Sell clicked: ", ticker, " x", shares)

	if stocks_owned[ticker] >= shares:
		var quarter_candles = stock_prices[ticker][current_quarter]
		var current_price = quarter_candles[-1]["close"]
		var total_value = current_price * shares
		
		# --- IMPORTANT: Adjust cost basis ---
		var old_shares = stocks_owned[ticker]
		var proportion = float(shares) / float(old_shares)
		total_spent[ticker] -= total_spent[ticker] * proportion

		# Update shares + cash
		stocks_owned[ticker] -= shares
		cash += total_value

		# Recalculate average
		if stocks_owned[ticker] > 0:
			buy_price[ticker] = total_spent[ticker] / stocks_owned[ticker]
		else:
			buy_price[ticker] = 0.0
			total_spent[ticker] = 0.0

		update_display()
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("DON'T OWN ENOUGH!\nHave: %d shares\nNeed: %d" % [stocks_owned[ticker], shares])


func hold_stock():
	print("Hold clicked")
	var label = find_child("StockPrice", true, false)
	if label:
		label.set_text("HOLD - Skipped action\nCash: $%.2f" % cash)

func advance_quarter():
	print("Next Quarter clicked")
	if current_quarter < max_quarters - 1:
		current_quarter += 1
		update_display()
		update_quarter_label()
		
		# Update chart with new quarter's candlesticks
		var chart = find_child("CandlestickChart", true, false)
		if chart and chart.has_method("set_stock_data"):
			chart.call("set_stock_data", stock_prices[current_stock][current_quarter])
		
		# Show strategy tutorial on Q2
		if current_quarter == 1:
			call_deferred("show_tutorial", "quarter_strategy")
		
		var label = find_child("StockPrice", true, false)
		if label:
			label.set_text("QUARTER %d/%d\nCash: $%.2f" % [current_quarter + 1, max_quarters, cash])
	else:
		var label = find_child("StockPrice", true, false)
		if label:
			var total_value = cash
			for ticker in stocks_owned:
				var quarter_candles = stock_prices[ticker][current_quarter]
				var current_price = quarter_candles[-1]["close"]
				total_value += stocks_owned[ticker] * current_price
			var profit = total_value - 10000.0
			show_performance_review(total_value, profit)
			label.set_text("GAME OVER!\nFinal Value: $%.2f\nProfit: $%.2f" % [total_value, profit])
