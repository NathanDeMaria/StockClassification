library(data.table)
library(Quandl)

source('app_settings.R')

Quandl.auth(app_settings('quandl_key'))

get_quandl <- function(code, start_date, end_date, data_frequency = NULL) {
	# NULL is daily	
	tryCatch({		
		data.table(Quandl(paste0('YAHOO/', code), 
						  trim_start=start_date, 
						  trim_end=end_date, 
						  collapse=data_frequency,
						  sort='asc'))
	}, error = function(e) {
		warning(sprintf('Quandl returned NULL for %s', code))
		NULL
	})
}