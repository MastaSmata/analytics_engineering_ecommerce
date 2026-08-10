{{ config(
    materialized='table'
) }}

WITH channel_dimension AS (

    SELECT
        channel_key,
        channel_name

    FROM {{ ref('dim_channels') }}

)

SELECT

    --------------------------------------------------
    -- SURROGATE KEY
    --------------------------------------------------

    {{ dbt_utils.generate_surrogate_key([
        'campaign_id'
    ]) }} AS campaign_key,

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

FROM {{ ref('stg_campaigns') }} AS campaigns

LEFT JOIN channel_dimension

    ON LOWER(TRIM(campaigns.channel))
       = channel_dimension.channel_name