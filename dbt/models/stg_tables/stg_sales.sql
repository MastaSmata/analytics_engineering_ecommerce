SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,

    LOWER(TRIM(customer_status)) AS customer_status,

    TRIM(product_id) AS product_id,
    LOWER(TRIM(product_name)) AS product_name,
    LOWER(TRIM(category)) AS category,

    LOWER(TRIM(ship_mode)) AS ship_mode,

    SAFE_CAST(quantity AS INT64) AS quantity,
    SAFE_CAST(discount AS NUMERIC) AS discount,
    SAFE_CAST(unit_cost AS NUMERIC) AS unit_cost,
    SAFE_CAST(price AS NUMERIC) AS price,
    SAFE_CAST(revenue AS NUMERIC) AS revenue,

    LOWER(TRIM(refund_status)) AS refund_status,

    SAFE_CAST(order_date AS DATE) AS order_date,

    LOWER(TRIM(channel)) AS channel,

    TRIM(campaign_id) AS campaign_id

FROM {{ source('raw', 'raw_sales') }}