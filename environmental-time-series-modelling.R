
# Monthly temperature time-series analysis
# Nottingham, England (1920–1939)

# install.packages(c("ggplot2", "dplyr", "nlme", "mgcv"))

library(ggplot2)
library(dplyr)
library(nlme)
library(mgcv)

# Load temperature data
data("nottem")

# Convert Fahrenheit to Celsius
temperature <- (as.numeric(nottem) - 32) * 5 / 9

data <- data.frame(
  Date = seq(
    as.Date("1920-01-01"),
    by = "month",
    length.out = length(temperature)
  ),
  Time = seq_along(temperature),
  Temperature = temperature,
  Month = factor(rep(1:12, length.out = length(temperature)))
)

head(data)
summary(data)


# Monthly temperature variation
ggplot(data, aes(Date, Temperature)) +
  geom_line(colour = "steelblue") +
  theme_classic() +
  labs(
    title = "Monthly air temperature in Nottingham",
    x = "Year",
    y = "Temperature (°C)"
  )


# Seasonal decomposition
temperature_ts <- ts(
  data$Temperature,
  frequency = 12,
  start = c(1920, 1)
)

decomposition <- stl(
  temperature_ts,
  s.window = "periodic"
)

plot(decomposition)


# Seasonal AR(1) model
model_arima <- arima(
  temperature_ts,
  order = c(1, 0, 0),
  seasonal = list(
    order = c(0, 1, 0),
    period = 12
  )
)

print(model_arima)

acf(
  residuals(model_arima),
  main = "Residual autocorrelation: seasonal AR(1)"
)


# GLS models
model_gls <- gls(
  Temperature ~ Time + Month,
  data = data,
  method = "ML"
)

model_ar1 <- gls(
  Temperature ~ Time + Month,
  data = data,
  correlation = corAR1(form = ~ Time),
  method = "ML"
)

summary(model_gls)
summary(model_ar1)

AIC(model_gls, model_ar1)


# Residual autocorrelation
acf(
  resid(model_gls, type = "normalized"),
  main = "GLS residual autocorrelation"
)

acf(
  resid(model_ar1, type = "normalized"),
  main = "AR(1) residual autocorrelation"
)


# Observed and fitted temperatures
data$Predicted_AR1 <- predict(model_ar1)

ggplot(data, aes(Date)) +
  geom_line(
    aes(y = Temperature),
    colour = "grey60"
  ) +
  geom_line(
    aes(y = Predicted_AR1),
    colour = "steelblue",
    linewidth = 1
  ) +
  theme_classic() +
  labs(
    title = "Observed and fitted monthly temperatures",
    x = "Year",
    y = "Temperature (°C)"
  )


# Linear and nonlinear temperature trends
model_linear <- gam(
  Temperature ~ Time + Month,
  data = data,
  method = "ML"
)

model_gam <- gam(
  Temperature ~ s(Time, k = 10) + Month,
  data = data,
  method = "ML"
)

summary(model_linear)
summary(model_gam)

AIC(model_linear, model_gam)

gam.check(model_gam)


# GAM predictions
newdata <- data.frame(
  Date = data$Date,
  Time = data$Time,
  Month = factor(
    data$Month,
    levels = levels(data$Month)
  )
)

pred <- predict(
  model_gam,
  newdata = newdata,
  se.fit = TRUE
)

newdata$Predicted <- pred$fit
newdata$Lower <- pred$fit - 1.96 * pred$se.fit
newdata$Upper <- pred$fit + 1.96 * pred$se.fit


# Nonlinear temperature trends
ggplot(data, aes(Date, Temperature)) +
  geom_point(colour = "grey70", size = 1) +
  geom_ribbon(
    data = newdata,
    aes(
      x = Date,
      ymin = Lower,
      ymax = Upper
    ),
    inherit.aes = FALSE,
    fill = "steelblue",
    alpha = 0.2
  ) +
  geom_line(
    data = newdata,
    aes(x = Date, y = Predicted),
    inherit.aes = FALSE,
    colour = "steelblue",
    linewidth = 1
  ) +
  theme_classic() +
  labs(
    title = "Nonlinear temperature trends",
    x = "Year",
    y = "Temperature (°C)"
  )


# GAM residual autocorrelation
acf(
  residuals(model_gam),
  main = "GAM residual autocorrelation"
)


# Compare fitted temperature trends
data$Predicted_Linear <- predict(model_linear)
data$Predicted_GAM <- predict(model_gam)

ggplot(data, aes(Date)) +
  geom_line(
    aes(y = Temperature),
    colour = "grey70"
  ) +
  geom_line(
    aes(y = Predicted_Linear),
    colour = "darkgreen",
    linewidth = 0.8
  ) +
  geom_line(
    aes(y = Predicted_GAM),
    colour = "steelblue",
    linewidth = 0.8
  ) +
  theme_classic() +
  labs(
    title = "Linear and nonlinear temperature models",
    x = "Year",
    y = "Temperature (°C)"
  )


# Save results
dir.create("results", showWarnings = FALSE)

write.csv(
  data,
  "results/monthly_temperature.csv",
  row.names = FALSE
)

write.csv(
  newdata,
  "results/gam_predictions.csv",
  row.names = FALSE
)
