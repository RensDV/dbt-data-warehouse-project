
  
    USE [DataWarehouse];
    USE [DataWarehouse];
    
    

    

    
    USE [DataWarehouse];
    EXEC('
        create view "silver"."crm_sales_details__dbt_tmp__dbt_tmp_vw" as 

-- Convert integer dates to real DATEs and derive missing sales/price values
with cleaned as (
    select
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        case
            when sls_order_dt is null or sls_order_dt = 0 or len(CAST(sls_order_dt AS VARCHAR)) != 8
                then null
            else cast(
                SUBSTRING(CAST(sls_order_dt AS VARCHAR), 1, 4) + ''-'' +
                SUBSTRING(CAST(sls_order_dt AS VARCHAR), 5, 2) + ''-'' +
                SUBSTRING(CAST(sls_order_dt AS VARCHAR), 7, 2)
                as date
            )
        end as sls_order_dt,
        case
            when sls_ship_dt is null or sls_ship_dt = 0 or len(CAST(sls_ship_dt AS VARCHAR)) != 8
                then null
            else cast(
                SUBSTRING(CAST(sls_ship_dt AS VARCHAR), 1, 4) + ''-'' +
                SUBSTRING(CAST(sls_ship_dt AS VARCHAR), 5, 2) + ''-'' +
                SUBSTRING(CAST(sls_ship_dt AS VARCHAR), 7, 2)
                as date
            )
        end as sls_ship_dt,
        case
            when sls_due_dt is null or sls_due_dt = 0 or len(CAST(sls_due_dt AS VARCHAR)) != 8
                then null
            else cast(
                SUBSTRING(CAST(sls_due_dt AS VARCHAR), 1, 4) + ''-'' +
                SUBSTRING(CAST(sls_due_dt AS VARCHAR), 5, 2) + ''-'' +
                SUBSTRING(CAST(sls_due_dt AS VARCHAR), 7, 2)
                as date
            )
        end as sls_due_dt,
        case
            when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
                then sls_quantity * abs(sls_price)
            else sls_sales
        end as sls_sales,
        sls_quantity,
        case
            when sls_price is null or sls_price <= 0 then
                case
                    when sls_quantity != 0 then (sls_sales / sls_quantity)
                    else null
                end
            else sls_price
        end as sls_price
    from "DataWarehouse"."bronze"."crm_sales_details"
)
select * from cleaned;;
    ')

EXEC('
            SELECT * INTO "DataWarehouse"."silver"."crm_sales_details__dbt_tmp" FROM "DataWarehouse"."silver"."crm_sales_details__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS silver.crm_sales_details__dbt_tmp__dbt_tmp_vw')



    
    use [DataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'silver_crm_sales_details__dbt_tmp_cci'
        AND object_id=object_id('silver_crm_sales_details__dbt_tmp')
    )
    DROP index "silver"."crm_sales_details__dbt_tmp".silver_crm_sales_details__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX silver_crm_sales_details__dbt_tmp_cci
    ON "silver"."crm_sales_details__dbt_tmp"

   


  