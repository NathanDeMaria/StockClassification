
# doing it like this for now, should probably make less bad in the future
save_data <- function(dat, name) {
	saveRDS(dat, paste0("data/", name, ".rds"))
}

load_data <- function(name) {
	filename <- paste0("data/", name, ".rds")
	
	if(!file.exists(filename)) {
		stop(paste(name, "not found"))
	}
	
	readRDS(filename)
}