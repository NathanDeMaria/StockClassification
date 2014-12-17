
# prices {from Quandl}, n {number of days to go back}
get_price_changes <- function(prices, n) {
	ror <- prices[,diff(close)/close[-1]]
	return_sd <- sd(ror)
	return_mean <- mean(ror)
	change <- ifelse(ror < return_mean - return_sd/4, "down", 
						   ifelse(ror > return_mean + return_sd/4, 
						   	   "up", "neutral"))
	data.table(date=prices$date, change=change)
}