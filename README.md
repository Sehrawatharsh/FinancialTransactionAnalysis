# 📘 Financial Transaction Analysis-using SQL and PowerBI

## 🎯 Project Overview

This project focuses on analyzing financial transaction behavior using SQL. It involves trend analysis, anomaly detection, and user segmentation based on demographic and behavioral data. The goal is to gain actionable insights into transaction patterns, highlight fraudulent activity, and support decision-making for financial services.

---

## 📂 Dataset Summary

### [**Dataset**](https://www.kaggle.com/datasets/valakhorasani/bank-transaction-dataset-for-fraud-detection) 
- **Key Fields**:
  - `TransactionID`, `AccountID`, `TransactionAmount`, `TransactionDate`
  - `TransactionType` (Credit/Debit)
  - `Channel` (ATM, Branch, Online)
  - `DeviceID`, `IP Address`, `MerchantID`
  - `CustomerAge`, `CustomerOccupation`
  - `LoginAttempts`, `TransactionDuration`

---

## 🛠️ Tools Used

- **MySQL** – Data querying, transformation, trend analysis
- **MS Word** – Report presentation
- **PowerBI** - Visualization

---

## 📊 Analysis Highlights

### 🔍 Trend Analysis
- Quarterly and monthly transaction volume increases observed
- Branch channels had the highest transaction count
- Age groups 60+ and 46–60 spent the most

### 👤 User Behavior
- Students were the most active users
- Professionals like doctors and engineers showed high ATM and Branch usage
- Online and ATM transactions had longer durations

### ⚠️ Anomaly Detection
- Login attempts ≥5 used to flag suspicious access
- Outliers detected using standard deviation filtering
- Kansas City and Jacksonville noted for frequent anomalies
- Devices with repeated high-risk behavior were identified

---

## 📈 Key Insights

- Branch remains dominant in usage, while ATM supports sensitive transactions
- Elderly and professional segments are high-value targets for premium services
- Cities and devices can be profiled for fraud hotspots

---

## ✅ Recommendations

1. Strengthen monitoring for devices with high login attempts
2. Deploy fraud detection rules for flagged cities and outlier transaction amounts
3. Improve online and ATM transaction performance to reduce duration
4. Offer targeted financial products for high-value demographics

---


