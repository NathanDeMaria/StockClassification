###############################################################
# Run this script to fill the data/ folder with *.rds for all #
# of the selected companies (see ticker_symbols)              #
###############################################################

library(lubridate)

get_data <- function(ticker_symbol, start_date, max_lag, pages_back=20) {
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

source('database.R')

# I picked one from each GICS Sector in the S&P 500
ticker_symbols <- readLines("app_data/symbols.txt")
	
# things today might have just the time, so I'll mess with that later
# also, Quandl sometimes gives NA for today's price
current_date <- Sys.Date() - 1  

max_lag <- 3
verbose <- T

success <- sapply(ticker_symbols, function(ticker_symbol) {	
	if(verbose) {
		print(paste("Getting data for", ticker_symbol))
	}
	datas <- get_data(ticker_symbol, current_date, max_lag)
	if(!is.null(datas)) {
		save_data(datas, ticker_symbol)
		return(T)
	}	
	F
})

