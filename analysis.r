# Loading the required packages
library("Rcpp")
library("ggplot2")
library("stats")
library("forecast")

# Set up the working directory
setwd("C:/Users/shaik/Desktop/Projects/Inflation Forecasting using ARIMA")

# Set the output directory
output_dir <- getwd()

# Pull the data
DataInflation=read.csv(file="DataInflation.csv")

# Conversion of data into time series object
Inflation <- ts(DataInflation$Inflation, start=c(2016, 7), frequency=12)

# Plotting the data
png(filename = file.path(output_dir, "Inflation_Series.png"), width = 800, height = 600)
autoplot(Inflation, ylab='Inflation Rate (%)')
dev.off()

# Differencing the data
DInflation=diff(Inflation)

# plotting the differenced data
png(filename = file.path(output_dir, "Differenced_Inflation.png"), width = 800, height = 600)
autoplot(DInflation, ylab='First Difference of Inflation Rate (%)')
dev.off()

# ACF and PACF of the data
png(filename = file.path(output_dir, "ACF_PACF_Inflation.png"), width = 1000, height = 500)
par(mfrow=c(1,2))
acf(as.numeric(Inflation), lag.max=20, main="ACF of Inflation")
pacf(as.numeric(Inflation),  lag.max=20, main="PACF of Inflation")
dev.off()

# ACF and PACF of the differenced data
png(filename = file.path(output_dir, "ACF_PACF_Differenced.png"), width = 1000, height = 500)
par(mfrow=c(1,2))
acf(as.numeric(DInflation), lag.max=20, main="ACF of Differenced Inflation")
pacf(as.numeric(DInflation), lag.max=20, main="PACF of Differenced Inflation")
dev.off()

# Fitting the models
FittedModel1 = Arima(Inflation, order=c(4,1,1), include.drift = TRUE)
summary(FittedModel1)

FittedModel2 = Arima(Inflation, order=c(2,1,5), include.drift = TRUE)
summary(FittedModel2)

AutoModel <- auto.arima(Inflation)
summary(AutoModel)

# Comparing the models on AIC
AIC(FittedModel1)
AIC(FittedModel2)
AIC(AutoModel)

# Forecasting
salesForecast= forecast(FittedModel1,h=12)
png(filename = file.path(output_dir, "Forecast_ARIMA_411.png"), width = 800, height = 600)
autoplot(salesForecast, ylab='Inflation Rate (%)')
dev.off()