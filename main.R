source('data_gatherer.R')
source('database.R')

ticker_symbol <- 'CAG'
current_date <- Sys.Date() - 1  # things today might have just the time, so I'll mess with that later
								# also, Quandl sometimes gives NA for today's price
max_lag <- 3

datas <- get_data(ticker_symbol, current_date, max_lag)
if(!is.null(datas)) {
	save_data(datas, ticker_symbol)
}
