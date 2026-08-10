
  
    

    create or replace table `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_channels`
      
    
    

    OPTIONS()
    as (
      SELECT
    to_hex(md5(cast(coalesce(cast(channel_name as string), '_dbt_utils_surrogate_key_null_') as string))) AS channel_key,

    LOWER(TRIM(channel_name)) AS channel_name,
    LOWER(TRIM(channel_category)) AS channel_category,
    LOWER(TRIM(traffic_type)) AS traffic_type
    

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_channels`
    );
  