
  
    USE [DataWarehouse];
    USE [DataWarehouse];
    
    

    

    
    USE [DataWarehouse];
    EXEC('
        create view "silver"."erp_px_cat_g1v2__dbt_tmp__dbt_tmp_vw" as 

-- Straight passâ€‘through of ERP product categories
select *
from "DataWarehouse"."bronze"."erp_px_cat_g1v2";;
    ')

EXEC('
            SELECT * INTO "DataWarehouse"."silver"."erp_px_cat_g1v2__dbt_tmp" FROM "DataWarehouse"."silver"."erp_px_cat_g1v2__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS silver.erp_px_cat_g1v2__dbt_tmp__dbt_tmp_vw')



    
    use [DataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'silver_erp_px_cat_g1v2__dbt_tmp_cci'
        AND object_id=object_id('silver_erp_px_cat_g1v2__dbt_tmp')
    )
    DROP index "silver"."erp_px_cat_g1v2__dbt_tmp".silver_erp_px_cat_g1v2__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX silver_erp_px_cat_g1v2__dbt_tmp_cci
    ON "silver"."erp_px_cat_g1v2__dbt_tmp"

   


  