# Stock Classification

This R project tests out a little idea: stock prices can be predicted by looking at current news articles related to that stock.

## The Data
Data on prices is currently from Quandl. News articles are from Yahoo Finance.

## The Algorithm
For each day, a stock is flagged as up, down, or neutral (within 1/4 * sd) based on its rate of return. Using the textcat package, these will be matched with articles written x days beforehand.

## To Run
Need an app_settings.xml file in the app_data directory, containing:
\<key name="quandl_key"\>
	\<value\>yourQuandlKey\</value\>
\</key\>

First, run the data_gatherer.R script to fill the data/ directory with .rds files.

Then run main.R and look at <code>mean(matches, na.rm=T)</code> to see how well it did.  Right now, this is just assessing the value of the text of an article in relation to predicting stock price change.

### Current Use Case
Given an article, the current "system" will gather data to build a model that will tell you whether the article means the stock price will go up, down, or no change.  Based on the current default "settings", it gets it right 41.43% of the time (more than 1/3 so yay).

### Eventually...
Eventually, this could be expanded to gather lots more data and enable a user to input a ticker symbol and it will say up/down/no change with some kind of probability weight for each.  Eventually...