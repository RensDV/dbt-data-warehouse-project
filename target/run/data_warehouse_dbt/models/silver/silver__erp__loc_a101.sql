
  
    USE [DataWarehouse];
    USE [DataWarehouse];
    
    

    

    
    USE [DataWarehouse];
    EXEC('
        create view "silver"."erp_loc_a101__dbt_tmp__dbt_tmp_vw" as 

-- Strip dashes from the customer ID and map country codes
select
    replace(cid, ''-'', '''') as cid,
    case
        when trim(cntry) = ''DE''          then ''Germany''
        when trim(cntry) in (''US'',''USA'') then ''United States''
        when trim(cntry) = '''' or cntry is null then ''n/a''
        else trim(cntry)
    end as cntry
from "DataWarehouse"."bronze"."erp_loc_a101";;
    ')

EXEC('
            SELECT * INTO "DataWarehouse"."silver"."erp_loc_a101__dbt_tmp" FROM "DataWarehouse"."silver"."erp_loc_a101__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS silver.erp_loc_a101__dbt_tmp__dbt_tmp_vw')



    
    use [DataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'silver_erp_loc_a101__dbt_tmp_cci'
        AND object_id=object_id('silver_erp_loc_a101__dbt_tmp')
    )
    DROP index "silver"."erp_loc_a101__dbt_tmp".silver_erp_loc_a101__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX silver_erp_loc_a101__dbt_tmp_cci
    ON "silver"."erp_loc_a101__dbt_tmp"

   


  