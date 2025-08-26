# 🏗️ dbt Data Warehouse Project

This project is a modernized, modular **data transformation pipeline** built with [dbt](https://docs.getdbt.com) (Data Build Tool) and SQL. It simulates a realistic business scenario using customer and sales datasets. The pipeline follows a **multi-layer architecture** (Bronze → Silver → Gold) and runs on **Azure SQL Database**.

---

## ⚡ Quickstart

1. Clone the repo
   ```bash
   git clone https://github.com/yourusername/data_warehouse_dbt.git
   cd data_warehouse_dbt
   ```

2. Create and activate a virtual env  
   ```bash
   python -m venv .venv
   source .venv/bin/activate   # Mac/Linux
   .venv\Scripts\activate      # Windows
   ```

3. Install dependencies  
   ```bash
   pip install -r requirements.txt
   ```

4. Set environment variables (adjust values for your Azure SQL Database):  
   ```bash
   export DBT_USER=your_user
   export DBT_PASSWORD=your_password
   export DBT_HOST=your_server.database.windows.net
   export DBT_DB=DataWarehouse
   export DBT_SCHEMA=dev
   ```

5. Test your connection  
   ```bash
   dbt debug
   ```

6. Load seed data & build pipeline  
   ```bash
   dbt seed
   dbt run
   dbt test
   ```

7. Explore documentation site  
   ```bash
   dbt docs generate && dbt docs serve
   ```

---

## 🧾 Versions Tested

- Python: 3.11.6
- dbt-core: 1.10.9  
- dbt-sqlserver: 1.9.0  

(Confirm locally with `dbt --version`.)

---

## 📦 Project Structure

```
data_warehouse_dbt/
├── models/                 # Core transformation logic
│   ├── bronze/             # Raw ingested data (from seeds)
│   ├── silver/             # Cleaned, structured data
│   └── gold/               # Business-ready analytics
├── seeds/                  # Source CSV data (crm_cust_info, crm_sales_details, etc.)
├── macros/                 # Reusable macros
├── dbt_project.yml         # Project config
├── profiles.yml            # dbt profile (uses env vars for credentials)
├── requirements.txt        # Python dependencies
├── README.md               # This file
└── .gitignore              # Ignore .venv, target/, logs/, dbt_packages/
```

---

## 🛠️ Configuration

Your `profiles.yml` references environment variables for credentials and schema:

```yaml
my_azure_project:
  target: dev
  outputs:
    dev:
      type: sqlserver
      server: "{{ env_var('DBT_HOST') }}"
      port: 1433
      database: "{{ env_var('DBT_DB') }}"
      schema: "{{ env_var('DBT_SCHEMA') }}"
      user: "{{ env_var('DBT_USER') }}"
      password: "{{ env_var('DBT_PASSWORD') }}"
      encrypt: true
      trust_cert: true
```

---

## 📊 Data Pipeline Overview

### 🟫 Bronze Layer
- Raw ingestion from `seeds/` CSVs (e.g., `crm_cust_info`, `crm_sales_details`)  
- Minimal transformations: renaming, timestamps  

### 🪙 Silver Layer
- Cleansing & normalization  
- Deduplication, null handling, parsing  
- Ready for business joins  

### 🥇 Gold Layer
- Business-ready fact and dimension tables  
- Example outputs:  
  - `fact_sales`  
  - `dim_customers`  
  - `dim_products`  
- Optimized for BI/analytics tools  

---

## 📐 Modeling Philosophy

- Clear **Bronze → Silver → Gold** separation for transparency and lineage  
- Reusable logic via **macros**  
- **Tests + docs** stored alongside models for reproducibility  
- Naming conventions: `bronze_*`, `silver_*`, `dim_*`, `fact_*`  

---

## 📚 Useful dbt Commands

```bash
# Build only the silver layer
dbt run --select silver/

# Force full refresh
dbt run --full-refresh

# Run tests
dbt test

# Debug connection
dbt debug
```

---

## 🔍 Testing & Documentation

- Tests live in `schema.yml` files (examples: `unique`, `not_null`)  
- Document models with `description:` fields  
- Generate & serve interactive documentation:  
  ```bash
  dbt docs generate
  dbt docs serve
  ```

---

## 📊 Optional BI Integration

Gold models are accessible directly in **Power BI** using the SQL Server connector.  

Example visuals:
- Sales trends by product and customer  
- Country segmentation and sales volume  

---

## 🧠 Architecture Trade-offs

| Design Choice                  | Benefit                                 | Trade-off                                |
|--------------------------------|-----------------------------------------|------------------------------------------|
| Azure SQL instead of Data Lake | Easier setup, familiar SQL workflow     | Limited scalability for very large data   |
| SQL-only dbt transformations   | Simpler onboarding                     | No advanced ML/streaming capabilities    |
| Seeds → Bronze → Silver → Gold | Transparent lineage, modular            | More verbose than direct ELT              |
| dbt `view` materializations    | Easy to inspect logic in DB             | Potentially slower queries on large data  |

---

## 🙌 Credits

Built by [Rens De Vent](https://github.com/RensDV) — Data Engineer & Digital Nomad.  

> Demo / learning project. Fork ⭐, explore, and adapt!


