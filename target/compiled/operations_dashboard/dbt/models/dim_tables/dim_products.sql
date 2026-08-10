SELECT
to_hex(md5(cast(coalesce(cast(product_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS product_key,
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

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_products`