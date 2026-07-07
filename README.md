# Hands-On MIS Sales Analysis

A Management Information Systems project for Chapter 1: **Information Systems in Global Business Today**.

This project analyzes business decision problems and uses a transactional sales database to demonstrate how information systems support management decision making. The project includes written MIS analysis, SQLite database queries, CSV export, sales trend analysis, and a LaTeX report.

---

## Project Overview

The project covers four Hands-On MIS tasks:

1. **Management Decision Problem 1-7**  
   Analysis of Snyder's of Hanover and its spreadsheet-based financial reporting problems.

2. **Management Decision Problem 1-8**  
   Analysis of Dollar General's inventory management problem and decisions required before investing in an information system.

3. **Database Analysis Project 1-9**  
   SQL-based analysis of transactional marketplace sales data to answer:
   - Which products should be restocked?
   - Which stores and sales regions would benefit from promotional campaigns?
   - When should products be offered at full price, and when should discounts be used?

4. **Job Search Project 1-10**  
   Research on business jobs that require information systems knowledge.

---

## Repository Structure

```text
hands-on-mis-sales-analysis/

├── data/
│   ├── raw/
│   │   └── transactional_data.sqlite
│   └── csv/
│       ├── order_items.csv
│       ├── order_reviews.csv
│       ├── orders.csv
│       ├── products.csv
│       └── sellers.csv
│
├── figures/
│
├── report/
│   ├── report.tex
│   └── report.pdf
│
├── scripts/
│   └── sqlite_to_csv.py
│
├── sql/
│   ├── sales_analysis_queries.sql
│   ├── restock_analysis.sql
│   ├── promotion_analysis.sql
│   └── pricing_timing_analysis.sql
│
├── .gitignore
├── README.md
└── requirements.txt
```

---

## Dataset

The project uses a transactional marketplace database stored in SQLite format.

The database contains five main tables:

| Table | Description |
|---|---|
| `orders` | Order IDs, order dates, and customer contact information |
| `order_items` | Products sold, seller IDs, product IDs, and prices |
| `products` | Product IDs, product categories, and product weight |
| `sellers` | Seller IDs and seller state/region |
| `order_reviews` | Customer review scores and review comments |

The main analysis uses:

```text
orders + order_items + products + sellers
```

The `order_reviews` table is included in the dataset but is not required for the main assignment questions.

---

## Database Size

| Table | Number of Records |
|---|---:|
| `orders` | 96,478 |
| `order_items` | 110,197 |
| `products` | 32,216 |
| `sellers` | 2,970 |
| `order_reviews` | 39,462 |

The order dates range from:

```text
2016-09-15 to 2018-08-29
```

---

## Field Mapping

The original textbook assignment expects a store and regional sales database. This project uses an equivalent transactional marketplace dataset.

| Textbook Field | Dataset Field Used |
|---|---|
| Store identification number | `seller_id` |
| Sales region | `seller_state` |
| Item number | `product_id` |
| Item description | `product_category_name` |
| Unit price | `price` |
| Units sold | Count of rows in `order_items` |
| Sales period | Month extracted from `timestamp` |

---

## Requirements

### Fedora System Packages

Install Python, SQLite, and LaTeX tools:

```bash
sudo dnf install python3 python3-pip python3-virtualenv sqlite texlive-scheme-full
```

Check installation:

```bash
python3 --version
sqlite3 --version
pdflatex --version
```

---

## Python Environment

Create and activate a virtual environment:

```bash
python3 -m venv env
source env/bin/activate
```

Install Python dependencies:

```bash
pip install -r requirements.txt
```

The main Python package used is:

```text
pandas
```

---

## Export SQLite Tables to CSV

The dataset is stored as a SQLite database. The script below exports every table into a separate CSV file.

Run from the project root:

```bash
python3 scripts/sqlite_to_csv.py data/raw/transactional_data.sqlite data/csv
```

Expected CSV files:

```text
data/csv/orders.csv
data/csv/order_items.csv
data/csv/products.csv
data/csv/sellers.csv
data/csv/order_reviews.csv
```

---

## SQL Analysis

All SQL files are located in the `sql/` folder.

### 1. Database Profile and Base View

```bash
sqlite3 data/raw/transactional_data.sqlite < sql/sales_analysis_queries.sql
```

This file:

- Counts records in each table
- Checks the order date range
- Creates the joined sales view `sales_analysis_base`
- Checks for missing values

---

### 2. Restocking Analysis

```bash
sqlite3 data/raw/transactional_data.sqlite < sql/restock_analysis.sql
```

This file answers:

```text
Which products should be restocked?
```

Because the dataset does not include inventory levels, units sold are used as a demand indicator.

---

### 3. Promotional Campaign Analysis

```bash
sqlite3 data/raw/transactional_data.sqlite < sql/promotion_analysis.sql
```

This file answers:

```text
Which stores and sales regions would benefit from promotional campaigns?
```

In this dataset:

```text
seller_id = store/seller
seller_state = sales region
```

---

### 4. Pricing and Discount Timing Analysis

```bash
sqlite3 data/raw/transactional_data.sqlite < sql/pricing_timing_analysis.sql
```

This file answers:

```text
When should products be offered at full price, and when should discounts be used?
```

Because the dataset does not include a discount field, monthly units sold and revenue are used to identify high-demand and low-demand periods.

---

## Main Findings

### Restocking Analysis

The highest-demand product categories by units sold were:

| Product Category | Units Sold | Total Revenue |
|---|---:|---:|
| `cama_mesa_banho` | 10,953 | 1,023,434.76 |
| `beleza_saude` | 9,465 | 1,233,131.72 |
| `esporte_lazer` | 8,431 | 954,852.55 |
| `moveis_decoracao` | 8,160 | 711,927.69 |
| `informatica_acessorios` | 7,644 | 888,724.61 |

These categories should be prioritized for restocking because they show the strongest customer demand.

---

### Promotional Campaign Analysis

The lowest-performing regions by revenue were:

| Region | Units Sold | Number of Sellers | Total Revenue |
|---|---:|---:|---:|
| AM | 3 | 1 | 1,177.00 |
| PA | 8 | 1 | 1,238.00 |
| SE | 10 | 2 | 1,606.20 |
| PI | 11 | 1 | 2,383.00 |
| RO | 14 | 2 | 4,762.20 |

These regions may benefit from promotional campaigns, additional marketing, or seller expansion.

---

### Pricing and Discount Timing Analysis

The strongest months by total revenue were:

| Month | Units Sold | Total Revenue |
|---|---:|---:|
| May | 11,814 | 1,466,882.94 |
| August | 11,939 | 1,393,276.34 |
| July | 11,379 | 1,349,557.98 |
| April | 10,396 | 1,314,203.77 |
| March | 10,914 | 1,312,555.10 |

These months are better candidates for full-price selling.

The weakest months by total revenue were:

| Month | Units Sold | Total Revenue |
|---|---:|---:|
| September | 4,740 | 607,534.64 |
| October | 5,527 | 688,572.76 |
| December | 6,188 | 726,044.09 |
| November | 8,475 | 987,765.37 |
| January | 8,950 | 1,036,443.36 |

These months are better candidates for discounts, promotions, or additional marketing campaigns.

---

## Report

The written report is located in:

```text
report/report.tex
```

Compile the report from the `report/` folder:

```bash
cd report
pdflatex report.tex
pdflatex report.tex
```

The compiled PDF will be created as:

```text
report/report.pdf
```

The report includes:

- Written answers for MIS decision problems
- Dataset description
- Data preparation explanation
- SQL analysis results
- Job search findings
- Conclusion
- Appendices containing Python and SQL code

---

## Notes About Data Files

The raw SQLite database and exported CSV files may be large. Depending on submission requirements, they may be excluded from GitHub using `.gitignore`.

Recommended `.gitignore` entries:

```gitignore
env/
__pycache__/
*.pyc

data/raw/*
data/csv/*

*.aux
*.log
*.out
*.toc
*.lof
*.lot
*.fls
*.fdb_latexmk
*.synctex.gz
```

If the professor requires the dataset to be submitted, include the dataset separately or provide instructions for obtaining it.

---

## Skills Demonstrated

This project demonstrates:

- Management information systems analysis
- Business decision problem analysis
- SQLite database inspection
- SQL querying
- Data preparation
- CSV export using Python
- Sales trend analysis
- Product demand analysis
- Regional sales performance analysis
- Pricing and promotion timing analysis
- LaTeX report writing
- GitHub project organization

---

## Author

**Parsa Mohebian**

---

## License

This project is for educational use as part of a Management Information Systems assignment.