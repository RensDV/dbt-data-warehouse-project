{{ config(alias='erp_loc_a101', materialized='table') }}

-- Strip dashes from the customer ID and map country codes
select
    replace(cid, '-', '') as cid,
    case
        when trim(cntry) = 'DE'          then 'Germany'
        when trim(cntry) in ('US','USA') then 'United States'
        when trim(cntry) = '' or cntry is null then 'n/a'
        else trim(cntry)
    end as cntry
from {{ ref('erp_loc_a101') }};
