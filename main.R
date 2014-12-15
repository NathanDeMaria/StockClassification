
source('news.R')

ticker_symbol <- 'CAG'
current_date <- Sys.Date() - 1  # things today might have just the time, so I'll mess with that later
dats <- get_text_data(ticker_symbol, current_date, 10)