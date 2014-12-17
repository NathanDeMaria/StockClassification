# NOTE: Yahoo's thing will give the last 20(?) articles
# so loop back by passing the day before the most recent day
library(httr)
library(lubridate)
library(XML)
library(data.table)

get_text_data <- function(ticker_symbol, start_date, pages_back) {
	get_dat <- function(ticker_symbol, current_date) {
		result <- content(GET(sprintf('http://finance.yahoo.com/q/h?s=%s&t=%s', 
				ticker_symbol, current_date)))
		
		nodes <- getNodeSet(result, "//table[@id='yfncsumtab']/tr/td/div/ul")
		nodes <- nodes[-1]  # the first node is a title ul
		links <- sapply(nodes, function(node) {
			xmlAttrs(getNodeSet(node, 'li/a')[[1]])['href']
		})
		raw_dates <- sapply(nodes, function(node) {	
			raw_date <- xmlValue(getNodeSet(node, 'li/cite/span')[[1]])
			raw_date <- substr(raw_date, 2, nchar(raw_date)-1)
			parsed_date <- paste(raw_date, year(current_date))
			
			# fixes dates that are from the previous year
			# could fix by doing smarter parsing, but this is faster
			if(month(current_date) < 6 && month(mdy(parsed_date)) > 10) {
				parsed_date <- paste(raw_date, year(current_date) - 1)
			}			
			parsed_date
		})
		if(length(raw_dates) == 0) {
			return(data.table(ticker_symbol=character(), link=character(), date=character()))
		}
		publish_dates <- mdy(raw_dates)	
		data.table(ticker_symbol=ticker_symbol, link=links, date=publish_dates)
	}
	
	get_text <- Vectorize(function(url) {
		if(length(grep('http://finance\\.yahoo\\.com/news', url)) > 0) {
			#Sys.sleep(.1)
			parsed_text <- tryCatch({
				result <- GET(url)
				html_content <- content(result)
				nodeset <- getNodeSet(html_content, "//section[@id='mediacontentstory']")
				# gets all the text in there, but some stuff I don't want (like JavaScript)
				raw_text <- xmlApply(nodeset, xmlValue)[[1]]
				raw_text <- gsub('\\{.*\\}', ' ', raw_text)
				gsub('[^[:alnum:]]', ' ', raw_text)	
			}, error=function(e) {
				warning(sprintf("Probably didn't sleep long enough for %s", url))
			})
			if(length(parsed_text) == 0) {
				warning(sprintf("Probably didn't sleep long enough for %s", url))
				return(NULL)
			}
			
			return(parsed_text)
		}
	
		# only handling Yahoo cases for now
		NULL
	})
	
	datas <- get_dat(ticker_symbol, start_date)
	for(i in 1:pages_back) {
		current_date <- min(datas$date) - days(1)
		this_dat <- get_dat(ticker_symbol, current_date)
		datas <- rbind(datas, this_dat)
	}
	
	datas[,text:=get_text(link)]
	# have to sapply because is.null doesn't vectorize like you think it would in data.table
	datas[!sapply(text, is.null)] 
}