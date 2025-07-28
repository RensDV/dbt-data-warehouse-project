

-- Strip dashes from the customer ID and map country codes
select
    replace(cid, '-', '') as cid,
    case
        when trim(cntry) = 'DE'          then 'Germany'
        when trim(cntry) in ('US','USA') then 'United States'
        when trim(cntry) = '' or cntry is null then 'n/a'
        else trim(cntry)
    end as cntry
from "DataWarehouse"."bronze"."erp_loc_a101";