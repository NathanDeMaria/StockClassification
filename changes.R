
# prices {from Quandl}, n {number of days to go back}
get_price_changes <- function(prices, n) {
	prices[,ror:=c(NA, diff(close)/(close[-1]))]
	return_sd <- prices[,sd(ror, na.rm=T)]
	return_mean <- prices[,mean(ror, na.rm=T)]
	prices[,change:=ifelse(ror < return_mean - return_sd/4, "down", 
						   ifelse(ror > return_mean + return_sd/4, "up", "neutral"))]
	
}