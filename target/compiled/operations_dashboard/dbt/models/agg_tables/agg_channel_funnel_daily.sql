

--------------------------------------------------
-- DAILY CHANNEL FUNNEL
--------------------------------------------------

SELECT

    --------------------------------------------------
    -- REPORTING GRAIN
    --------------------------------------------------

    fact_marketing.date_key,

    --------------------------------------------------
    -- CHANNEL
    --------------------------------------------------

    dim_channels.channel_name,

    dim_channels.channel_category,

    dim_channels.traffic_type,

    --------------------------------------------------
    -- MARKETING ACTIVITY
    --------------------------------------------------

    SUM(fact_marketing.ad_spend)
        AS total_ad_spend,

    SUM(fact_marketing.impressions)
        AS total_impressions,

    SUM(fact_marketing.clicks)
        AS total_clicks,

    SUM(fact_marketing.conversions)
        AS total_conversions,

    
    --------------------------------------------------
    -- AUDIT
    --------------------------------------------------

    CURRENT_TIMESTAMP()

        AS loaded_at

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`fact_marketing` fact_marketing

JOIN `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_channels` dim_channels

    ON fact_marketing.channel_key =
       dim_channels.channel_key

GROUP BY

    fact_marketing.date_key,

    dim_channels.channel_name,

    dim_channels.channel_category,

    dim_channels.traffic_type