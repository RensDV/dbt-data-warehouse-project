{{ config(alias='erp_px_cat_g1v2', materialized='table') }}

-- Straight passâ€‘through of ERP product categories
select *
from {{ ref('erp_px_cat_g1v2') }};
