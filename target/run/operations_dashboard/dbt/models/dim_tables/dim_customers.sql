
  
    

    create or replace table `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_customers`
      
    
    

    OPTIONS()
    as (
      

WITH customer_orders AS (

    SELECT

        customer_id,

        MIN(DATE(order_date)) AS first_purchase_date,

        MAX(DATE(order_date)) AS latest_purchase_date,

        COUNT(DISTINCT order_id) AS lifetime_orders,

        SUM(revenue) AS lifetime_revenue

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_sales`

    GROUP BY customer_id

)

SELECT

    --------------------------------------------------
    -- SURROGATE KEY
    --------------------------------------------------

    to_hex(md5(cast(coalesce(cast(customers.customer_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS customer_key,

    --------------------------------------------------
    -- BUSINESS KEY
    --------------------------------------------------

    customers.customer_id,

    --------------------------------------------------
    -- DEMOGRAPHICS
    --------------------------------------------------

    LOWER(TRIM(customers.gender)) AS gender,

    customers.age,

    CASE

        WHEN customers.age < 18 THEN 'Under 18'

        WHEN customers.age BETWEEN 18 AND 24 THEN '18-24'

        WHEN customers.age BETWEEN 25 AND 34 THEN '25-34'

        WHEN customers.age BETWEEN 35 AND 44 THEN '35-44'

        WHEN customers.age BETWEEN 45 AND 54 THEN '45-54'

        ELSE '55+'

    END AS age_band,

    LOWER(TRIM(customers.country)) AS country,

    LOWER(TRIM(customers.region)) AS region,

    LOWER(TRIM(customers.city)) AS city,

    --------------------------------------------------
    -- ACQUISITION ATTRIBUTES
    --------------------------------------------------

    customers.acquisition_date,

    LOWER(TRIM(customers.acquisition_channel))
        AS acquisition_channel,

    LOWER(TRIM(customers.acquisition_campaign))
        AS acquisition_campaign,

    --------------------------------------------------
    -- CUSTOMER LIFECYCLE
    --------------------------------------------------

    customer_orders.first_purchase_date,

    customer_orders.latest_purchase_date,

    customer_orders.lifetime_orders,

    customer_orders.lifetime_revenue,

    --------------------------------------------------
    -- CUSTOMER STATUS
    --------------------------------------------------

    CASE

        WHEN customer_orders.lifetime_orders IS NULL
            THEN 'prospect'

        WHEN customer_orders.lifetime_orders = 1
            THEN 'new'

        ELSE 'returning'

    END AS customer_status,

    --------------------------------------------------
    -- AUDIT
    --------------------------------------------------

    CURRENT_TIMESTAMP() AS loaded_at

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_customers` AS customers

LEFT JOIN customer_orders

    ON customers.customer_id = customer_orders.customer_id
    );
  