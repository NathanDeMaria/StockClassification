library(lubridate)

get_data <- function(ticker_symbol, start_date, max_lag, pages_back=10) {
	source('news.R')
	source('quandl.R')
	source('changes.R')
	
	dats <- get_text_data(ticker_symbol, start_date, pages_back)
	prices <- get_quandl(ticker_symbol, 
						 as.character(min(dats$date)), 
						 as.character(max(dats$date) + days(max_lag)))
	
	get_lag <- function(lag_amt) {
		sapply(dats$date, function(d) {		
			changes[date > d][lag_amt,change]
		})
	}
	
	if(is.null(prices)) {
		return(NULL)
	}
	
	changes <- get_price_changes(prices)
	lag_names <- sapply(seq_len(max_lag), function(i) {paste0('lag', i)})
	dats[,eval(lag_names):=lapply(seq_len(max_lag), get_lag)]
	dats
}

