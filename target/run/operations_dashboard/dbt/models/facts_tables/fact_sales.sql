
  
    

    create or replace table `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`fact_sales`
      
    
    

    OPTIONS()
    as (
      

WITH sales AS (

    SELECT *

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_sales`

),

date_dimension AS (

    SELECT
        date_key

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_date`

),

customer_dimension AS (

    SELECT
        customer_key,
        customer_id

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_customers`

),

product_dimension AS (

    SELECT
        product_key,
        product_id

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_products`

),

channel_dimension AS (

    SELECT
        channel_key,
        channel_name

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_channels`

),

campaign_dimension AS (

    SELECT
        campaign_key,
        campaign_id

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_campaigns`

)

SELECT

    --------------------------------------------------
    -- FACT SURROGATE KEY
    --------------------------------------------------

    to_hex(md5(cast(coalesce(cast(sales.order_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(sales.product_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS sales_key,

    --------------------------------------------------
    -- BUSINESS IDENTIFIER
    --------------------------------------------------

    sales.order_id,

    --------------------------------------------------
    -- STAR SCHEMA KEYS
    --------------------------------------------------

    date_dimension.date_key,

    customer_dimension.customer_key,

    product_dimension.product_key,

    channel_dimension.channel_key,

    campaign_dimension.campaign_key,

    --------------------------------------------------
    -- TRANSACTION ATTRIBUTES
    --------------------------------------------------

    sales.ship_mode,

    LOWER(TRIM(sales.refund_status))
        AS refund_status,

    sales.customer_status,

    --------------------------------------------------
    -- SALES MEASURES
    --------------------------------------------------

    sales.quantity,

    sales.price,

    sales.unit_cost,

    sales.discount,

    sales.revenue AS net_sales,

    --------------------------------------------------
    -- ROW-LEVEL FINANCIAL METRICS
    --------------------------------------------------

    sales.quantity * sales.price
        AS gross_sales,

    sales.quantity * sales.unit_cost
        AS total_cost,

    sales.quantity
        * sales.price
        * sales.discount
        AS discount_amount,

    sales.revenue
        - (sales.quantity * sales.unit_cost)
        AS gross_profit,

    sales.price
        - sales.unit_cost
        AS unit_margin,

    --------------------------------------------------
    -- FLAGS
    --------------------------------------------------

    LOWER(TRIM(sales.refund_status)) = 'refunded'
        AS is_refunded,

    --------------------------------------------------
    -- AUDIT
    --------------------------------------------------

    CURRENT_TIMESTAMP()
        AS loaded_at

FROM sales

JOIN date_dimension

    ON DATE(sales.order_date)
       = date_dimension.date_key

JOIN customer_dimension

    ON sales.customer_id
       = customer_dimension.customer_id

JOIN product_dimension

    ON sales.product_id
       = product_dimension.product_id

LEFT JOIN channel_dimension

    ON LOWER(TRIM(sales.channel))
       = channel_dimension.channel_name

LEFT JOIN campaign_dimension

    ON sales.campaign_id
       = campaign_dimension.campaign_id
    );
  