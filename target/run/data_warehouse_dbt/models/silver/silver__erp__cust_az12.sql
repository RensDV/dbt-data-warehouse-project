
  
    USE [DataWarehouse];
    USE [DataWarehouse];
    
    

    

    
    USE [DataWarehouse];
    EXEC('
        create view "silver"."erp_cust_az12__dbt_tmp__dbt_tmp_vw" as 

-- Remove ''NAS'' prefix, null future birthdates and normalise gender
select
    case when cid like ''NAS%'' then SUBSTRING(cid, 4) else cid end as cid,
    case when bdate > current_date then null else bdate end as bdate,
    case
        when upper(trim(gen)) in (''F'',''FEMALE'') then ''Female''
        when upper(trim(gen)) in (''M'',''MALE'')   then ''Male''
        else ''n/a''
    end as gen
from "DataWarehouse"."bronze"."erp_cust_az12";;
    ')

EXEC('
            SELECT * INTO "DataWarehouse"."silver"."erp_cust_az12__dbt_tmp" FROM "DataWarehouse"."silver"."erp_cust_az12__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS silver.erp_cust_az12__dbt_tmp__dbt_tmp_vw')



    
    use [DataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'silver_erp_cust_az12__dbt_tmp_cci'
        AND object_id=object_id('silver_erp_cust_az12__dbt_tmp')
    )
    DROP index "silver"."erp_cust_az12__dbt_tmp".silver_erp_cust_az12__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX silver_erp_cust_az12__dbt_tmp_cci
    ON "silver"."erp_cust_az12__dbt_tmp"

   


  