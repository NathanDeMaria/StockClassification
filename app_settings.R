library(XML)

app_settings <- function(key) {	
	doc <- xmlParse(file = 'app_settings.xml')
	xmlValue(getNodeSet(doc, sprintf("//key[@name = '%s']/value", key))[[1]])
}