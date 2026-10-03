# Retail Sales Data Cleaning & Analytics

An end-to-end retail analytics project focused on data quality, data cleaning, SQL analysis, and interactive Power BI reporting.

The project uses a Superstore retail sales dataset to investigate sales performance, profitability, discounting, products, regions, customer behavior, and business segments.

---

## Project Overview

This project simulates a real-world client request:

> I have a retail sales dataset containing several years of orders. I want the data cleaned and prepared for analysis, followed by an analysis of sales and profitability. I also need a dashboard/report that helps me understand sales performance, customers, products, regions, and profitability.

The project covers the complete analytical workflow:

**Raw Data → Data Audit → Data Cleaning → SQL Analysis → Power BI Dashboard → Business Insights**

---

## Business Objectives

The analysis was designed to answer the following questions:

- How is overall sales and profitability performing?
- How does performance change over time?
- Which categories and sub-categories generate the most profit?
- Which regions perform best?
- How is discounting associated with profitability?
- Which products generate the largest losses?
- Which customers are loss-making?
- How do different customer segments contribute to sales and profit?
- Does customer order frequency show a consistent relationship with profitability?

---

## Dataset

The project uses a Superstore retail sales dataset containing order, customer, product, geographic, shipping, sales, discount, and profit information.

### Dataset Structure

- **10,194 rows**
- **21 original columns**
- Order information
- Customer information
- Product information
- Geographic information
- Shipping information
- Sales and profitability metrics

The cleaned analytical dataset contains additional derived fields used for analysis, including:

- `customer_id_anomaly`
- `shipping_days`

---

## Data Quality & Cleaning

The dataset was first audited using Python and Pandas before analysis.

### Data Quality Checks

The audit covered:

- Missing values
- Duplicate records
- Data types
- Date validity
- Shipping date validation
- Categorical consistency
- Numerical ranges
- Outlier investigation
- Customer ID consistency
- Order-level anomalies
- Dataset grain

### Audit Results

- **0 missing values**
- **0 exact duplicate rows**
- No invalid order dates
- No shipping dates occurring before order dates
- No negative sales values
- No invalid quantities
- No discounts outside the expected range
- No obvious categorical inconsistencies

Potential outliers were investigated rather than automatically removed.

### Identified Anomaly

Two orders contained inconsistent customer IDs despite having the same customer name and repeated product composition.

Rather than deleting or modifying the records without sufficient evidence, the affected orders were flagged using:

`customer_id_anomaly`

This preserves the original data while making the issue visible for further investigation.

---

## Data Cleaning

Python and Pandas were used to prepare the analytical dataset.

Main transformations included:

- Standardizing column names
- Removing unnecessary whitespace
- Converting dates to proper datetime types
- Converting postal codes to string
- Validating numerical fields
- Validating order and shipping dates
- Flagging confirmed customer ID anomalies
- Creating `shipping_days`
- Exporting the cleaned dataset to CSV

### Output

The final cleaned dataset contains:

- **10,194 rows**
- **23 columns**
- **0 missing values**
- **0 duplicate rows**

---

## SQL Analysis

SQL Server was used for business analysis and analytical aggregation.

### Overall Performance

- Total Sales
- Total Profit
- Profit Margin
- Total Orders
- Total Customers
- Total Products
- Average Discount

### Time Analysis

- Monthly Sales
- Monthly Profit
- Monthly Profit Margin
- Monthly Orders
- Monthly Customers
- Year-over-year performance

### Category Analysis

- Sales by Category
- Profit by Category
- Profit Margin by Category
- Average Discount by Category

### Regional Analysis

- Sales by Region
- Profit by Region
- Profit Margin by Region
- Average Discount by Region

### Discount Analysis

- Sales by Discount Level
- Profit by Discount Level
- Profit Margin by Discount Level

### Product Analysis

- Loss-making products
- Product profitability
- Product margins
- Average product discounts
- Order frequency

### Customer Analysis

- Customer sales
- Customer profit
- Customer profitability
- Customer order frequency
- Loss-making customers
- Customer profitability groups

---

## Key Business Findings

### Overall Performance

The dataset generated approximately:

| Metric           |    Value |
| ---------------- | -------: |
| Total Sales      |   $2.33M |
| Total Profit     | $292.30K |
| Profit Margin    |   12.56% |
| Total Orders     |    5,111 |
| Total Customers  |      804 |
| Total Products   |    1,862 |
| Average Discount |   15.54% |

### Category Profitability

Technology generated the highest profit at approximately **$146.5K**, followed by Office Supplies at approximately **$126.0K**.

Furniture generated approximately **$754.7K in sales**, but only **$19.7K in profit**, resulting in a substantially lower profit margin of approximately **2.61%**.

### Regional Performance

West generated the highest profit at approximately **$110.8K**, with a margin of approximately **14.98%**.

Central generated approximately **$503.2K in sales**, but its profit margin was approximately **7.92%**, the lowest among the four regions.

Central also had the highest average discount at approximately **24.10%**.

### Discount & Profitability

The analysis showed a strong negative association between higher discount levels and profitability.

Discount levels of **30% or higher produced negative aggregate profit** in this dataset.

| Discount | Profit Margin |
| -------- | ------------: |
| 0%       |        29.56% |
| 20%      |        11.77% |
| 30%      |       -10.06% |
| 50%      |       -34.80% |
| 80%      |      -180.01% |

These results indicate an area that deserves further investigation into pricing and discount strategy.

The analysis identifies an association rather than proving that discounts directly cause the losses.

### Loss-Making Products

The largest product-level losses were concentrated in several products, particularly within:

- Machines
- Tables
- Binders

Examples:

| Product                                                  |     Profit |  Margin | Avg. Discount |
| -------------------------------------------------------- | ---------: | ------: | ------------: |
| Cubify CubeX 3D Printer Double Head Print                | -$8,879.97 | -80.00% |        53.33% |
| Lexmark MX611dhe Monochrome Laser Printer                | -$4,589.97 | -27.27% |        40.00% |
| Cubify CubeX 3D Printer Triple Head Print                | -$3,839.99 | -48.00% |        50.00% |
| Chromcraft Bull-Nose Wood Oval Conference Tables & Bases | -$2,876.12 | -29.00% |        28.00% |
| Bush Advantage Collection Racetrack Conference Table     | -$1,934.40 | -20.27% |        35.00% |

Several of these products were sold in relatively few orders, so product-level losses should be investigated further rather than interpreted as proof that every product in the category is broadly problematic.

### Customer Profitability

Customer analysis identified a group of loss-making customers whose combined sales were approximately **$392.7K**, while generating approximately **-$71.5K in profit**.

The analysis also showed that less profitable customer groups generally had higher average discounts.

Customer order frequency did not show a consistent relationship with profitability, indicating that simply increasing order frequency does not necessarily guarantee higher profitability.

---

## Power BI Dashboard

The final Power BI report contains three analytical pages.

### Page 1 — Executive Overview

Provides a high-level view of business performance.

Includes:

- KPI Cards
- Monthly Sales & Profit Trend
- Sales & Profit by Category
- Sales & Profit by Region
- Discount vs. Profit Margin
- Top 10 Loss-Making Products
- Year Filter
- Category Filter
- Region Filter

### Page 2 — Profitability Analysis

Focuses on identifying profitability problems.

Includes:

- Sales
- Profit
- Profit Margin
- Average Discount
- Profit by Sub-Category
- Discount vs. Profit Margin
- Loss-Making Product Analysis

### Page 3 — Customer & Segment Analysis

Focuses on customer profitability and business segments.

Includes:

- Sales
- Profit
- Profit Margin
- Total Customers
- Customer Orders vs. Profit
- Loss-Making Customer Analysis
- Sales & Profit by Customer Segment

---

## Technology Stack

### Data Cleaning & EDA

- Python
- Pandas
- Jupyter Notebook

### Database & Analysis

- SQL Server
- SQL

### Visualization & Reporting

- Microsoft Power BI

### Development Tools

- VS Code
- SQL Server Management Studio

---

## Project Structure

```text
Freelance-Retail-Analytics/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── notebooks/
│   └── exploratory_analysis.ipynb
│
├── sql/
│   └── analysis.sql
│
├── dashboard/
│   └── Freelance_Retail_Analytics.pbix
│
├── reports/
│   ├── data_quality_report.md
│   └── cleaning_log.md
│
├── src/
│   └── cleaning/
│       └── cleaning.py
│
├── requirements.txt
└── README.md
```

---

## Analytical Workflow

```text
Raw Superstore Dataset
        ↓
    Data Audit
        ↓
Python / Pandas Cleaning
        ↓
  Cleaned Dataset
        ↓
    SQL Server
        ↓
  Business Analysis
        ↓
     Power BI
        ↓
Interactive 3-Page Dashboard
        ↓
  Business Insights
```

---

## Skills Demonstrated

- Data Cleaning
- Data Quality Assessment
- Exploratory Data Analysis
- Python
- Pandas
- SQL
- SQL Server
- Business Analysis
- Profitability Analysis
- Customer Analysis
- Product Analysis
- Data Visualization
- Power BI
- Dashboard Design
- Business Reporting
- Analytical Storytelling

---

## Conclusion

This project demonstrates an end-to-end retail analytics workflow, from raw data auditing and cleaning to SQL-based business analysis and interactive Power BI reporting.

By combining data quality assessment, analytical SQL queries, and dashboard visualization, the project identifies profitability patterns, loss-making products and customers, regional performance differences, and the relationship between discount levels and profitability.

The findings provide a foundation for further investigation into pricing, discounting, product performance, and customer profitability.
