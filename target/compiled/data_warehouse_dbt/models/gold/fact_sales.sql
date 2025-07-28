

select
    sd.sls_ord_num  as order_number,
    pr.product_key  as product_key,
    cu.customer_key as customer_key,
    sd.sls_order_dt as order_date,
    sd.sls_ship_dt  as shipping_date,
    sd.sls_due_dt   as due_date,
    sd.sls_sales    as sales_amount,
    sd.sls_quantity as quantity,
    sd.sls_price    as price
from "DataWarehouse"."silver"."crm_sales_details" as sd
left join "DataWarehouse"."gold"."dim_products" as pr
    on sd.sls_prd_key = pr.product_number
left join "DataWarehouse"."gold"."dim_customers" as cu
    on sd.sls_cust_id = cu.customer_id;