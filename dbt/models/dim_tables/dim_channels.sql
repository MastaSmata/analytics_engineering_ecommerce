
SELECT
    {{ dbt_utils.generate_surrogate_key([
        'channel_name'
    ]) }} AS channel_key,

    LOWER(TRIM(channel_name)) AS channel_name,
    LOWER(TRIM(channel_category)) AS channel_category,
    LOWER(TRIM(traffic_type)) AS traffic_type
    

FROM {{ ref('stg_channels') }}