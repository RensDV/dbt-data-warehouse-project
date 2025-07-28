# dbt Data Warehouse Project

Welcome to the refactored **Data Warehouse and Analytics Project**!  This version reâ€‘implements
the original SQLâ€‘Server based warehouse as a dbt project running directly against an
**Azure SQL Database**.  The goal remains the same â€“ to demonstrate a complete modern data
warehouse across **bronze**, **silver** and **gold** layers â€“ but the implementation now
leverages dbtâ€™s modelling, testing and documentation features and is containerised for easy
reproduction.  The warehouse is no longer backed by SQLite; instead it uses your Azure SQL
instance via the connection defined in `profiles.yml`.

In the original repository the project was described as a â€œBasic SQL Data Warehouse and
Analytics Projectâ€ that showcases best practices in data architecture, ETL pipelines and data
modelling.  This refactor preserves those concepts while replacing stored procedures with dbt
models and connecting directly to your Azure SQL database.  Everything you need to build the
warehouse is included in this repository â€“ from the raw CSV seeds to the dbt models, tests and
documentation.

---
## ðŸ—ï¸ Data Architecture

The warehouse still follows the medallion architecture:

1. **Bronze Layer** â€“ Raw data from the CRM and ERP systems is stored as seeds in the
   `seeds/` directory.  Each CSV file is prefixed with `bronze_` to denote its role as a
   landing table.
2. **Silver Layer** â€“ Cleansed and standardised tables live in `models/silver/`.  These models
   trim whitespace, normalise categorical values, convert dates and deduplicate records.
3. **Gold Layer** â€“ Businessâ€‘ready dimensions and fact tables are defined in `models/gold/` as
   views.  The star schema consists of `dim_customers`, `dim_products` and `fact_sales` (see
   the data catalogue in `docs/data_catalog.md` for details).

---
## ðŸš€ Getting Started

### Running with Docker

The easiest way to build and explore the warehouse is via Docker.  Make sure you have Docker
and dockerâ€‘compose installed, then run:

```bash
# From the root of this repository
docker-compose up --build
```

This command will build the Docker image, install dbt and the SQLÂ Server adapter, connect to
your Azure SQL database and run the full pipeline.  It will:

1. Load the CSV seeds into the **bronze** schema.
2. Build the **silver** models in the silver schema.
3. Build the **gold** models in the gold schema.
4. Execute the defined tests against the gold layer.

Because the warehouse lives on your Azure SQL instance, there is no local `warehouse.db` file.

### Running Locally

If you prefer not to use Docker you can run dbt directly on your machine.  Youâ€™ll need
PythonÂ 3.11+ and the `dbt-core` and `dbt-sqlserver` packages.  Clone this repository and
install the dependencies:

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install --no-cache-dir dbt-core dbt-sqlserver

# Set the profiles directory so dbt finds profiles.yml in this repo
export DBT_PROFILES_DIR=$(pwd)

# Load seeds into the bronze schema
dbt seed --full-refresh

# Build silver and gold models
dbt run

# Run tests
dbt test
```

### ðŸ“‚ Repository Structure

```
data_warehouse_dbt/
â”‚
â”œâ”€â”€ models/                       # dbt models organised by layer
â”‚   â”œâ”€â”€ bronze/                   # (empty) â€“ bronze tables are created from seeds
â”‚   â”œâ”€â”€ silver/                   # cleansing and transformation logic
â”‚   â”œâ”€â”€ gold/                     # businessâ€‘ready dimensions and fact tables
â”‚   â””â”€â”€ schema.yml               # documentation and tests for models
â”‚
â”œâ”€â”€ seeds/                        # Raw CSV files (bronze layer)
â”‚
â”œâ”€â”€ docs/                         # Data catalogue, naming conventions, diagrams
â”‚
â”œâ”€â”€ projectplan/                  # Highâ€‘level implementation plan
â”‚
â”œâ”€â”€ dbt_project.yml               # dbt project configuration
â”œâ”€â”€ profiles.yml                  # dbt profiles pointing at your Azure SQL database
â”œâ”€â”€ Dockerfile                    # Container specification for building and running the project
â”œâ”€â”€ docker-compose.yml            # dockerâ€‘compose wrapper to run the pipeline
â””â”€â”€ README.md                     # This file
```

## ðŸ§ª Tests and Documentation

Each model is accompanied by tests defined in `models/schema.yml`.  dbt will run these tests
after executing the models to validate assumptions such as uniqueness of primary keys, allowed
values for categorical fields and nonâ€‘null constraints.  Additional project documentation,
including the data catalogue and naming conventions, resides in the `docs/` directory and has
been updated to reflect the dbt workflow.

## ðŸ›¡ï¸ License & Attribution

The original project was licensed under MIT, and this adaptation inherits the same license.
Credits go to **RensÂ DeÂ Vent** for designing the initial SQL data warehouse project.  This
version refactors the ETL into dbt and connects directly to Azure SQL for portability.
