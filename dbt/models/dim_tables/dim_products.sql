SELECT
{{ dbt_utils.generate_surrogate_key([
        'product_id'
    ]) }} AS product_key,
    product_id,
    LOWER(TRIM(product_name)) AS product_name,
    price,
    unit_cost,
    LOWER(TRIM(sub_category)) AS sub_category,
    LOWER(TRIM(category)) AS category,
    LOWER(TRIM(brand)) AS brand,
    supplier_id,

    -------------------------------------------------
    -- BUSINESS DERIVED METRICS
    -------------------------------------------------
    (price - unit_cost) AS unit_margin

FROM {{ ref('stg_products') }}