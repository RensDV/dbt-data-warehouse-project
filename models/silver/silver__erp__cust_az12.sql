{{ config(alias='erp_cust_az12', materialized='table') }}

-- Remove 'NAS' prefix, null future birthdates and normalise gender
select
    case when cid like 'NAS%' then SUBSTRING(cid, 4) else cid end as cid,
    case when bdate > current_date then null else bdate end as bdate,
    case
        when upper(trim(gen)) in ('F','FEMALE') then 'Female'
        when upper(trim(gen)) in ('M','MALE')   then 'Male'
        else 'n/a'
    end as gen
from {{ ref('erp_cust_az12') }};
