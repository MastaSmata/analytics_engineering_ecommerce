SELECT
    TRIM(ads_id) AS ads_id,
    TRIM(campaign_id) AS campaign_id,

    LOWER(TRIM(channel_name)) AS channel_name,
    LOWER(TRIM(campaign_objective)) AS campaign_objective,

    SAFE_CAST(date AS DATE) AS date,

    SAFE_CAST(ad_spend AS NUMERIC) AS ad_spend,
    SAFE_CAST(impressions AS INT64) AS impressions,
    SAFE_CAST(clicks AS INT64) AS clicks,
    SAFE_CAST(conversions AS INT64) AS conversions,

    LOWER(TRIM(campaign_type)) AS campaign_type

FROM {{ source('raw', 'raw_marketing') }}