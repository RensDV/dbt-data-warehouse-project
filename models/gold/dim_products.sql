{{ config(materialized='view') }}

select
    row_number() over (order by p.prd_start_dt, p.prd_key) as product_key,
    p.prd_id        as product_id,
    p.prd_key       as product_number,
    p.prd_nm        as product_name,
    p.cat_id        as category_id,
    c.cat           as category,
    c.subcat        as subcategory,
    c.maintenance   as maintenance,
    p.prd_cost      as cost,
    p.prd_line      as product_line,
    p.prd_start_dt  as start_date
from {{ ref('silver__crm__prd_info') }} as p
left join {{ ref('silver__erp__px_cat_g1v2') }} as c
    on p.cat_id = c.id
where p.prd_end_dt is null;