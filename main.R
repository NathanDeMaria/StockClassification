library(data.table)
library(textcat)

set.seed(18)

dat <- lapply(list.files('data', full.names=T), function(f) {
	readRDS(f)	
})
dat <- rbindlist(dat)

train_indices <- 1:nrow(dat) %in% sample(1:nrow(dat), size = nrow(dat)*.6, replace = F)
training <- dat[train_indices]
validate <- dat[!train_indices]

news_profile <- textcat_profile_db(training$text, training$lag1)
result <- sapply(validate$text, function(words) {
	textcat(words, news_profile)
})
matches <- result == validate$lag1