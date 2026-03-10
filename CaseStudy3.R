## USE FORECAST LIBRARY.

install.packages("forecast")
library(forecast)
library(zoo)


## CREATE DATA FRAME. 

# Set working directory for locating files.
setwd("/Users/amishafarhanashaik/Desktop/MSBA/BAN673TimeSeries /Case Studies")

# Create data frame.
data <- read.csv("673_case2.csv")


walmart.ts <- ts(data$Revenue, 
                 start = c(2005, 1), end = c(2024, 4), freq = 4)
length(walmart.ts)

nValid <- 16 
nTrain <- length(walmart.ts) - nValid
train.ts <- window(walmart.ts, start = c(2005, 4), end = c(2005, nTrain))
valid.ts <- window(walmart.ts, start = c(2005, nTrain + 1), 
                   end = c(2005, nTrain + nValid))

#QUESTION 1A


# Use Arima() function to fit AR(1) model.
# The ARIMA model of order = c(1,0,0) gives an AR(1) model.
walmart.ar1<- Arima(walmart.ts, order = c(1,0,0))
summary(walmart.ar1)

# Apply z-test to test the null hypothesis that beta 
# coefficient of AR(1) is equal to 1.
ar1 <- 0.9570
s.e. <- 0.0373
null_mean <- 1
alpha <- 0.05
z.stat <- (ar1-null_mean)/s.e.
z.stat
p.value <- pnorm(z.stat)
p.value
if (p.value<alpha) {
  "Reject null hypothesis"
} else {
  "Accept null hypothesis"
}

#QUESTION 1B

# Create first difference of Walmart data using diff() function.
diff.walmart <- diff(walmart.ts, lag = 1)
diff.walmart

# Develop data frame with Close Price, Close Price lag 1, and first
# differenced data.
diff.df <- data.frame(walmart.ts, c("", round(walmart.ts[1:79],2)), 
                      c("", round(diff.walmart,2)))

names(diff.df) <- c("Original", "Lag-1", 
                    "First Difference")
diff.df 

# Use Acf() function to identify autocorrealtion for first differenced

Acf(diff.walmart, lag.max = 8, 
    main = "Autocorrelation for Walmart Revenue")



#QUESTION 2A

#Regression model with linear trend and seasonality
train.lin.season <- tslm(train.ts ~ trend + season)
summary(train.lin.season)

train.lin.season.pred <- forecast(train.lin.season, h = nValid, level = 0)
train.lin.season.pred


#QUESTION 2B

# Use Acf() function to identify autocorrelation for the model residuals 
# (training set), and plot autocorrelation for different 
# lags (up to maximum of 8).
Acf(train.lin.season.pred$residuals, lag.max = 8, 
    main = "Autocorrelation for Walmart Training Residuals")


#QUESTION 2C

# Use Arima() function to fit AR(1) model for training residuals. The Arima model of 
# order = c(1,0,0) gives an AR(1) model.
# Use summary() to identify parameters of AR(1) model. 
res.ar1 <- Arima(train.lin.season$residuals, order = c(1,0,0))
summary(res.ar1)
res.ar1$fitted


# Use Acf() function to identify autocorrelation for the training 
# residual of residuals and plot autocorrelation for different lags 
Acf(res.ar1$residuals, lag.max = 8, 
    main = "Autocorrelation for Walmart Training Residuals of Residuals")


#QUESTION 2D

# Create two-level model's forecast with linear trend and seasonality 
# regression + AR(1) for residuals for validation period.
# Create data table with validation data, regression forecast
# for validation period, AR(1) residuals for validation, and 
# two level model results. 
# Use forecast() function to make prediction of residuals in validation set.
res.ar1.pred <- forecast(res.ar1, h = nValid, level = 0)

valid.two.level.pred <- train.lin.season.pred$mean + res.ar1.pred$mean

valid.df <- round(data.frame(valid.ts, train.lin.season.pred$mean, 
                             res.ar1.pred$mean, valid.two.level.pred),3)
names(valid.df) <- c("Validation Data", "Reg.Forecast", 
                     "AR(1)Forecast", "Combined.Forecast")
valid.df

#QUESTION 2E

## FIT REGRESSION MODEL WITH LINEAR TREND AND SEASONALITY 
## FOR ENTIRE DATASET.

# Use tslm() function to create linear trend and seasonality model.
lin.season <- tslm(walmart.ts ~ trend + season)
summary(lin.season)

lin.season.pred <- forecast(lin.season, h = 8, level = 0)
lin.season.pred

# Use Arima() function to fit AR(1) model for training residuals. The Arima model of 
# order = c(1,0,0) gives an AR(1) model.
residual.ar1 <- Arima(lin.season$residuals, order = c(1,0,0))
summary(residual.ar1)
res.ar1$fitted

residual.ar1.pred <- forecast(residual.ar1, h = 8, level = 0)

full.two.level.pred <- lin.season.pred$mean + residual.ar1.pred$mean

# Use Acf() function to identify autocorrelation for the residuals of residuals 
# and plot autocorrelation for different lags.
Acf(residual.ar1$residuals, lag.max = 8, 
    main = "Autocorrelation for Residuals of Residuals for Entire Data Set")

# Create a data table with linear trend and seasonal forecast 
# for 12 future periods,
# AR(1) model for residuals for 12 future periods, and combined 
# two-level forecast for 12 future periods. 

# Identify forecast for the future 12 periods as sum of linear trend and 
# seasonal model and AR(1) model for residuals.
lin.season.ar1.pred <- lin.season.pred$mean + residual.ar1.pred$mean
lin.season.ar1.pred

table.df <- round(data.frame(lin.season.pred$mean, 
                             residual.ar1.pred$mean, lin.season.ar1.pred),3)
names(table.df) <- c("Reg.Forecast", "AR(1)Forecast","Combined.Forecast")
table.df


##QUESTION 3A

## FIT ARIMA(1,1,1)(1,1,1) MODEL.

train.arima.seas <- Arima(train.ts, order = c(1,1,1), 
                          seasonal = c(1,1,1)) 
summary(train.arima.seas)

# Apply forecast() function to make predictions for ts with 
# ARIMA model in validation set.    
train.arima.seas.pred <- forecast(train.arima.seas, h = nValid, level = 0)
train.arima.seas.pred

#QUESTION 3B

## FIT AUTO ARIMA MODEL.

# Use auto.arima() function to fit ARIMA model.
# Use summary() to show auto ARIMA model and its parameters.
train.auto.arima <- auto.arima(train.ts)
summary(train.auto.arima)

# Apply forecast() function to make predictions for ts with 
# auto ARIMA model in validation set.  
train.auto.arima.pred <- forecast(train.auto.arima, h = nValid, level = 0)
train.auto.arima.pred

#QUESTION 3C

# Use accuracy() function to identify common accuracy measures 
# for validation period forecast:
round(accuracy(train.arima.seas.pred$mean, valid.ts), 3)
round(accuracy(train.auto.arima.pred$mean, valid.ts), 3)

#QUESTION 3D

# Use arima() function to fit seasonal ARIMA model 
# for entire data set.
# use summary() to show auto ARIMA model and its parameters for entire data set.
arima.seas <- Arima(walmart.ts, order = c(1,1,1), 
                    seasonal = c(1,1,1)) 
auto.arima <- auto.arima(walmart.ts)

summary(arima.seas)
summary(auto.arima)

# Apply forecast() function to make predictions for ts with 
# seasonal ARIMA model and AUTO ARIMA for the future 8 periods. 
arima.seas.pred <- forecast(arima.seas, h = 8, level = 0)
arima.seas.pred
auto.arima.pred <- forecast(auto.arima, h = 8, level = 0)
auto.arima.pred


#QUESTION 3E

# MEASURE FORECAST ACCURACY FOR ENTIRE DATA SET.

# Use accuracy() function to identify common accuracy measures:

round(accuracy(lin.season$fitted + residual.ar1$fitted, walmart.ts), 3)
round(accuracy(lin.season$fitted, walmart.ts), 3)
round(accuracy(arima.seas.pred$fitted, walmart.ts), 3)
round(accuracy(auto.arima.pred$fitted, walmart.ts), 3)
round(accuracy((snaive(walmart.ts))$fitted, walmart.ts), 3)










