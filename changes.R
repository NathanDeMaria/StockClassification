
# prices {from Quandl}
get_price_changes <- function(prices) {
	ror <- prices[,diff(adj_close)/adj_close[-1]]
	return_sd <- sd(ror)
	return_mean <- mean(ror)
	change <- ifelse(ror < return_mean - return_sd/4, "down", 
						   ifelse(ror > return_mean + return_sd/4, 
						   	   "up", "neutral"))
	data.table(date=prices$Date[-1], change=change)
}