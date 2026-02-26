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
