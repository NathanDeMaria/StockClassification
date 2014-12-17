library(lubridate)
source('news.R')
source('quandl.R')
source('changes.R')

ticker_symbol <- 'CAG'
current_date <- Sys.Date() - 7  # things today might have just the time, so I'll mess with that later
dats <- get_text_data(ticker_symbol, current_date, 10)

prices <- get_quandl(ticker_symbol, max(dats$date) - years(10), max(dats$date))
if(!is.null(prices)) {	
	changes <- get_price_changes(prices, 5)
}
