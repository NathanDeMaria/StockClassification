library(data.table)
library(Quandl)

source('app_settings.R')

Quandl.auth(app_settings('quandl_key'))

get_quandl <- function(code, start_date, end_date, data_frequency = NULL) {
	# NULL is daily	
	prices <- tryCatch({		
		dat <- data.table(Quandl(paste0('YAHOO/', code), 
						  trim_start=start_date, 
						  trim_end=end_date, 
						  collapse=data_frequency,
						  sort='asc'))
		setnames(dat, "Adjusted Close", "close")
		dat
	}, error = function(e) {
		warning(paste0("get_quandl returned NULL for symbol ", code, ": ", e$message))
		NULL
	})
}