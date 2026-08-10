
  
    

    create or replace table `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_campaigns`
      
    
    

    OPTIONS()
    as (
      

WITH channel_dimension AS (

    SELECT
        channel_key,
        channel_name

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_channels`

)

SELECT

    --------------------------------------------------
    -- SURROGATE KEY
    --------------------------------------------------

    to_hex(md5(cast(coalesce(cast(campaign_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS campaign_key,

    --------------------------------------------------
    -- BUSINESS KEY
    --------------------------------------------------

    campaign_id,

    --------------------------------------------------
    -- DIMENSION KEYS
    --------------------------------------------------

    channel_dimension.channel_key,

    --------------------------------------------------
    -- CAMPAIGN ATTRIBUTES
    --------------------------------------------------

    LOWER(TRIM(campaign_name))
        AS campaign_name,

    LOWER(TRIM(campaign_type))
        AS campaign_type,

    LOWER(TRIM(campaign_objective))
        AS campaign_objective,

    start_date,

    end_date,

    budget,

    --------------------------------------------------
    -- AUDIT
    --------------------------------------------------

    CURRENT_TIMESTAMP()
        AS loaded_at

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_campaigns` AS campaigns

LEFT JOIN channel_dimension

    ON LOWER(TRIM(campaigns.channel))
       = channel_dimension.channel_name
    );
  