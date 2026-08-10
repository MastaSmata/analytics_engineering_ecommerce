
  
    

    create or replace table `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`fact_marketing`
      
    
    

    OPTIONS()
    as (
      

WITH marketing AS (

    SELECT *

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_marketing`

),

date_dimension AS (

    SELECT
        date_key

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_date`

),

campaign_dimension AS (

    SELECT
        campaign_key,
        campaign_id,

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_campaigns`

),

channel_dimension AS (

    SELECT
        channel_key,
        channel_name

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_channels`

)

SELECT

    --------------------------------------------------
    -- FACT SURROGATE KEY
    --------------------------------------------------

    to_hex(md5(cast(coalesce(cast(marketing.ads_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS marketing_key,

    --------------------------------------------------
    -- FOREIGN KEYS
    --------------------------------------------------

    date_dimension.date_key,

    campaign_dimension.campaign_key,

    channel_dimension.channel_key,

    --------------------------------------------------
    -- BUSINESS IDENTIFIER
    --------------------------------------------------

    marketing.ads_id,

    --------------------------------------------------
    -- MARKETING METRICS
    --------------------------------------------------

    marketing.ad_spend,

    marketing.impressions,

    marketing.clicks,

    marketing.conversions,

    marketing.campaign_objective,

    --------------------------------------------------
    -- DERIVED METRICS
    --------------------------------------------------

    SAFE_DIVIDE(
        marketing.clicks,
        marketing.impressions
    ) AS click_through_rate,

    SAFE_DIVIDE(
        marketing.conversions,
        marketing.clicks
    ) AS conversion_rate,

    SAFE_DIVIDE(
        marketing.ad_spend,
        marketing.clicks
    ) AS cost_per_click,

    SAFE_DIVIDE(
        marketing.ad_spend,
        marketing.impressions
    ) * 1000 AS cost_per_thousand_impressions,

    SAFE_DIVIDE(
        marketing.ad_spend,
        marketing.conversions
    ) AS cost_per_conversion,

    --------------------------------------------------
    -- AUDIT
    --------------------------------------------------

    CURRENT_TIMESTAMP() AS loaded_at

FROM marketing

JOIN date_dimension

    ON marketing.date = date_dimension.date_key

JOIN campaign_dimension

    ON marketing.campaign_id = campaign_dimension.campaign_id

JOIN channel_dimension

    ON LOWER(TRIM(marketing.channel_name))
       = channel_dimension.channel_name
    );
  