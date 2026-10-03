import pandas as pd
from pathlib import Path


# ============================================================
# PROJECT PATHS
# ============================================================

PROJECT_ROOT = Path(__file__).resolve().parents[2]

RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw" / "sample-superstore.xls"


# ============================================================
# LOAD RAW DATA
# ============================================================

df = pd.read_excel(RAW_DATA_PATH)

# print("Raw dataset loaded successfully.")
# print(f"Rows: {len(df)}")
# print(f"Columns: {len(df.columns)}")

# ============================================================
# BASIC DATA VALIDATION
# ============================================================

# print("\nMissing values:")
# print(df.isna().sum())

# print("\nDuplicate rows:")
# print(df.duplicated().sum())

# print("\nData types:")
# print(df.dtypes)

# ============================================================
# STANDARDIZE DATA TYPES
# ============================================================

df["Postal Code"] = df["Postal Code"].astype(str)

# print("\nPostal Code data type:")
# print(df["Postal Code"].dtype)

# ============================================================
# STANDARDIZE COLUMN NAMES
# ============================================================

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("/", "_")
    .str.replace("-", "_")
)

# print("\nStandardized columns:")
# print(df.columns.tolist())

# ============================================================
# STANDARDIZE TEXT VALUES
# ============================================================

text_columns = df.select_dtypes(include=["object", "str"]).columns

for column in text_columns:
    df[column] = df[column].str.strip()

# print("\nText fields standardized.")

# ============================================================
# STANDARDIZE DATE COLUMNS
# ============================================================

date_columns = ["order_date", "ship_date"]

for column in date_columns:
    df[column] = pd.to_datetime(df[column], errors="coerce")

# print("\nDate columns standardized:")
# print(df[date_columns].dtypes)

# ============================================================
# VALIDATE DATE VALUES
# ============================================================

# print("\nInvalid date values:")

# for column in date_columns:
    # print(f"{column}: {df[column].isna().sum()}")
    
# ============================================================
# VALIDATE ORDER / SHIP DATE RELATIONSHIP
# ============================================================

invalid_ship_dates = df[df["ship_date"] < df["order_date"]]

# print("\nInvalid shipping dates:")
# print(len(invalid_ship_dates))


# ============================================================
# VALIDATE NUMERICAL VALUES
# ============================================================

# print("\nNumerical validation:")

# print("Negative sales:", (df["sales"] < 0).sum())
# print("Invalid quantity:", (df["quantity"] <= 0).sum())
# print("Invalid discount:", ((df["discount"] < 0) | (df["discount"] > 1)).sum())

# ============================================================
# VALIDATE CUSTOMER / ORDER RELATIONSHIP
# ============================================================

customer_per_order = df.groupby("order_id")["customer_id"].nunique()

orders_with_multiple_customers = customer_per_order[
    customer_per_order > 1
]

# print("\nOrders with multiple Customer IDs:")
# print(len(orders_with_multiple_customers))

# print("\nAffected orders:")
# print(orders_with_multiple_customers)

# ============================================================
# INVESTIGATE CUSTOMER ID ANOMALY
# ============================================================

affected_order_ids = orders_with_multiple_customers.index

customer_anomaly = df[
    df["order_id"].isin(affected_order_ids)
][
    ["order_id", "customer_id", "customer_name", "product_id", "sales", "profit"]
]

# print("\nCustomer ID anomaly:")
# print(customer_anomaly.to_string(index=False))

# ============================================================
# FLAG CUSTOMER ID ANOMALIES
# ============================================================

df["customer_id_anomaly"] = df["order_id"].isin(affected_order_ids)

# print("\nCustomer ID anomaly flags:")
# print(df["customer_id_anomaly"].value_counts())

# ============================================================
# VALIDATE TEXT CLEANING
# ============================================================

whitespace_issues = {}

for column in text_columns:
    issues = (df[column] != df[column].str.strip()).sum()
    if issues > 0:
        whitespace_issues[column] = issues

# print("\nRemaining whitespace issues:")
# print(whitespace_issues)

# ============================================================
# PROFIT OUTLIERS
# ============================================================

# Profit outliers identified during the audit are retained.
# No records are removed or capped because no data-quality
# error was established.

# ============================================================
# CREATE SHIPPING DAYS
# ============================================================

df["shipping_days"] = (
    df["ship_date"] - df["order_date"]
).dt.days

# print("\nShipping days:")
# print(df["shipping_days"].describe())

# ============================================================
# FINAL DATA VALIDATION
# ============================================================

# print("\nFinal validation:")
# print(f"Rows: {len(df):,}")
# print(f"Columns: {len(df.columns)}")
# print(f"Missing values: {df.isna().sum().sum():,}")
# print(f"Duplicate rows: {df.duplicated().sum():,}")

# ============================================================
# SAVE PROCESSED DATASET
# ============================================================

PROCESSED_DIR = PROJECT_ROOT / "data" / "processed"
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

OUTPUT_PATH = PROCESSED_DIR / "superstore_cleaned.csv"

df.to_csv(OUTPUT_PATH, index=False)

# print(f"\nCleaned dataset saved to:")
# print(OUTPUT_PATH)

