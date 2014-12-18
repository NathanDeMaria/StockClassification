library(lubridate)
source('news.R')
source('quandl.R')
source('changes.R')

ticker_symbol <- 'CAG'
current_date <- Sys.Date() - 1  # things today might have just the time, so I'll mess with that later
								# also, Quandl sometimes gives NA for today's price
max_lag <- 3

dats <- get_text_data(ticker_symbol, current_date, 10)
prices <- get_quandl(ticker_symbol, 
					 as.character(min(dats$date)), 
					 as.character(max(dats$date) + days(max_lag)))

get_lag <- function(lag_amt) {
	sapply(dats$date, function(d) {		
		changes[date > d][lag_amt,change]
	})
}

if(!is.null(prices)) {	
	changes <- get_price_changes(prices)
	lag_names <- sapply(seq_len(max_lag), function(i) {paste0('lag', i)})
	dats[,eval(lag_names):=lapply(seq_len(max_lag), get_lag)]
}