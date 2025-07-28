USE [DataWarehouse];
    
    

    

    
    USE [DataWarehouse];
    EXEC('
        create view "gold"."dim_products__dbt_tmp" as 

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
from "DataWarehouse"."silver"."crm_prd_info" as p
left join "DataWarehouse"."silver"."erp_px_cat_g1v2" as c
    on p.cat_id = c.id
where p.prd_end_dt is null;;
    ')

