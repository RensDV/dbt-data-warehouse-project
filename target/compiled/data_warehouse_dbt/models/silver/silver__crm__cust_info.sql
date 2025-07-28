


-- Trim names, normalise codes and deduplicate customers
with ranked as (
    select
        cst_id,
        cst_key,
        trim(cst_firstname) as cst_firstname,
        trim(cst_lastname)  as cst_lastname,
        case
            when upper(trim(cst_marital_status)) = 'S' then 'Single'
            when upper(trim(cst_marital_status)) = 'M' then 'Married'
            else 'n/a'
        end as cst_marital_status,
        case
            when upper(trim(cst_gndr)) = 'F' then 'Female'
            when upper(trim(cst_gndr)) = 'M' then 'Male'
            else 'n/a'
        end as cst_gndr,
        cst_create_date,
        row_number() over (partition by cst_id order by cst_create_date desc) as rn
    from "DataWarehouse"."bronze"."crm_cust_info"
    where cst_id is not null
)
select
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
from ranked
where rn = 1;