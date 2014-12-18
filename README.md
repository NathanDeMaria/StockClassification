# Stock Classification

This R project tests out a little idea: stock prices can be predicted by looking at current news articles related to that stock.

## The Data
Data on prices is currently from Quandl. News articles are from Yahoo Finance.

## The Algorithm
For each day, a stock is flagged as up, down, or neutral (within 1/4 * sd) based on its rate of return. Using the textcat package, these will be matched with articles written x days beforehand.

## To Run
Need an app_settings.xml file in the root directory, containing:
\<key name="quandl_key"\>
	\<value\>yourQuandlKey\</value\>
\</key\>

First, run the data_gatherer.R script to fill the data/ directory with .rds files.