This directory should contain the raw CSV files used to load the bronze layer of the warehouse.
Each file should be prefixed with `bronze_` to indicate its role as a landing table.  For example,
`bronze_crm_cust_info.csv` for the CRM customer information table.  These CSVs will be loaded by
running `dbt seed`.

To reproduce the original data warehouse, copy the CSV files from the `datasets/source_crm` and
`datasets/source_erp` folders of the original project into this directory and prefix them with
`bronze_`.
