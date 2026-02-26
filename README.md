# 📈 Walmart Revenue Forecasting with AR & ARIMA

Advanced forecasting project extending regression models by incorporating autocorrelation correction and ARIMA modeling.

Objective: Identify the most accurate model for forecasting Walmart’s quarterly revenue for 2025–2026.

---

## 📊 Dataset

- Walmart quarterly revenue
- Period: Q1 2005 – Q4 2024
- Forecast Horizon: 2025–2026

---

## 🔍 Step 1 – Predictability Testing

### AR(1) Model

- Tested revenue predictability using AR(1)
- High AR coefficient (~0.96)
- Hypothesis testing initially suggested random walk behavior

### First Differencing + ACF

- Differenced series showed significant autocorrelation
- Confirmed presence of predictable structure

Conclusion: Revenue contains exploitable time dependence.

---

## 🧠 Step 2 – Two-Level Regression + AR(1)

1. Built regression model (trend + seasonality)
2. Examined residual ACF
3. Identified remaining autocorrelation
4. Fit AR(1) model on regression residuals

Final Two-Level Model:
Final Forecast = Regression Forecast + AR(1) Residual Forecast


Residual diagnostics showed no remaining autocorrelation after AR correction.

---

## 🔬 Step 3 – ARIMA Modeling

### Manual Model

ARIMA(1,1,1)(1,1,1)[4]

- Captures both trend and seasonal differencing
- Strong validation accuracy

### Auto ARIMA

- Model selected automatically
- Included drift component
- Slightly higher error on validation set

---

## 📊 Model Comparison

Models Compared:

- Regression (Trend + Seasonality)
- Two-Level Regression + AR(1)
- ARIMA(1,1,1)(1,1,1)
- Auto ARIMA
- Seasonal Naïve

Evaluation Metrics:

- RMSE
- MAPE
- Residual diagnostics

---

## 🏆 Best Performing Model

Top accuracy achieved by:

**ARIMA(1,1,1)(1,1,1)**  
Closely followed by Two-Level Regression + AR(1)

Both models effectively captured:

- Long-term growth
- Seasonal effects
- Autocorrelation structure

---

## 🛠 Tools Used

- R
- `forecast`
- `stats`
- AR and ARIMA modeling techniques

---

## 📌 Key Takeaways

- Residual autocorrelation correction significantly improves forecasts
- ARIMA models outperform basic regression for structured seasonal data
- Validation performance is more important than training accuracy
- Combining models often yields superior results

---

## 🚀 Final Outcome

Produced quarterly revenue forecasts for Walmart (2025–2026) using the most accurate ARIMA-based model.
