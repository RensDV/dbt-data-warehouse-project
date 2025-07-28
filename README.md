md

🏗️ dbt Data Warehouse Project

This project is a modernized, modular data transformation pipeline built with dbt (Data Build Tool) and SQL, designed to simulate a realistic business scenario using customer and sales datasets. The pipeline implements a multi-layer architecture (Bronze → Silver → Gold) and uses Azure SQL Database as its data platform.

📦 Project Structure

data_warehouse_dbt/
├── models/                 # Core transformation logic
│   ├── bronze/            # Raw ingested data
│   ├── silver/            # Cleaned, structured data
│   └── gold/              # Business-ready analytics
├── seeds/                 # Source CSV data (crm_cust_info, crm_sales_details, etc.)
├── macros/                # Reusable logic/macros
├── dbt_project.yml        # Project config
├── profiles.yml           # dbt profile for database connection (sanitize before sharing)
├── README.md              # You're here!
└── .gitignore             # Clean exclusions for Git

🚀 Getting Started

🔧 Prerequisites

Python 3.10+

dbt-core and dbt-sqlserver installed:

pip install dbt-core dbt-sqlserver

Access to an Azure SQL Database

🛠️ Configuration

Edit profiles.yml to match your Azure SQL connection. Use environment variables for security:

dev:
  target: dev_gold
  outputs:
    dev_gold:
      type: sqlserver
      server: your_server.database.windows.net
      port: 1433
      database: DataWarehouse
      schema: gold
      user: {{ env_var('DBT_USER') }}
      password: {{ env_var('DBT_PASSWORD') }}
      encrypt: true
      trust_cert: true

Set these environment variables:

export DBT_USER=your_user
export DBT_PASSWORD=your_password

🧪 Running the Project

From the root folder:

dbt deps       # (if using dbt packages)
dbt seed       # Load CSVs into Azure SQL (Bronze layer)
dbt run        # Run all models (Bronze → Silver → Gold)
dbt test       # Run tests defined in .yml configs
dbt docs generate && dbt docs serve  # Launch documentation site

📊 Data Pipeline Overview

🟫 Bronze Layer

Raw ingestion from seeds/ CSVs (e.g. crm_cust_info, crm_sales_details)

Minimal transformations (renaming, timestamps)

🪙 Silver Layer

Applies cleaning and normalization

Deduplicates records, parses countries, handles nulls

Ready for business joins

🥇 Gold Layer

Final facts and dimensions

Includes:

fact_sales

dim_customer

dim_product

Optimized for use in BI tools like Power BI

📐 Modeling Philosophy

Modular folder-based dbt layout

Reproducible, testable SQL logic with clear layer separation

Naming convention: bronze_*, silver_*, dim_*, fact_*

Seed → Bronze → Silver → Gold pattern ensures traceability

📚 Useful dbt Commands

dbt run --select silver/       # Only run silver layer

# Run with logs and partial refresh:
dbt run --full-refresh

# Debug connection
DBT_USER=xxx DBT_PASSWORD=yyy dbt debug

🔍 Testing & Documentation

Tests are defined in .yml files:

unique, not_null, accepted_values

Document your models with description: fields

Auto-generate docs:

dbt docs generate
dbt docs serve

📊 Power BI Integration

Once Gold models are deployed to Azure SQL, they can be directly imported into Power BI via SQL Server connector.
Recommended visuals:

Sales over time by customer and product

Country segmentation and volume

🧠 Architecture Trade-offs

Design Decision

Benefit

Trade-off / Risk

Azure SQL instead of Data Lake

Easier setup, familiar SQL workflow

Less scalable for big data / streaming

SQL-only dbt transformations

Simpler onboarding for analysts

No complex logic or ML integrations

Seeded CSV → Azure Bronze

Fast local dev and testing

Not a true real-time ingestion simulation

Flat file → Bronze → Silver → Gold

Great transparency and modularity

More verbose and step-heavy than ELT-in-one

Use of dbt view materializations

Easy to inspect logic in DB

Potentially slow queries for large datasets

🙌 Credits

Built by Rens De Vent — data engineer and digital nomad.

Feel free to fork, star ⭐, or suggest improvements!

