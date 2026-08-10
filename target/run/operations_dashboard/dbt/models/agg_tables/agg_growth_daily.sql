
  
    

    create or replace table `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`agg_growth_daily`
      
    
    

    OPTIONS()
    as (
      

--------------------------------------------------
-- SALES SUMMARY
--------------------------------------------------

WITH sales_summary AS (

    SELECT

        fs.date_key,

        fs.channel_key,

        fs.campaign_key,

        dc.region,

        --------------------------------------------------
        -- CUSTOMER FACTS
        --------------------------------------------------

        COUNT(DISTINCT fs.customer_key)
            AS total_customers,

        COUNT(DISTINCT CASE

            WHEN dc.acquisition_date = fs.date_key

            THEN fs.customer_key

        END) AS new_customers,

        COUNT(DISTINCT CASE

            WHEN dc.acquisition_date < fs.date_key

            THEN fs.customer_key

        END) AS returning_customers,

        --------------------------------------------------
        -- SALES FACTS
        --------------------------------------------------

        COUNT(DISTINCT fs.order_id)
            AS total_orders,

        SUM(fs.net_sales)
            AS total_revenue,

        SUM(fs.gross_profit)
            AS gross_profit

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`fact_sales` fs

    JOIN `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_customers` dc

        ON fs.customer_key =
           dc.customer_key

    GROUP BY

        fs.date_key,

        fs.channel_key,

        fs.campaign_key,

        dc.region

),

--------------------------------------------------
-- MARKETING SUMMARY
--------------------------------------------------

marketing_summary AS (

    SELECT

        date_key,

        channel_key,

        campaign_key,

        --------------------------------------------------
        -- MARKETING FACTS
        --------------------------------------------------

        SUM(ad_spend)
            AS total_ad_spend,

        SUM(

            CASE

                WHEN LOWER(campaign_objective)
                    = 'acquisition'

                THEN ad_spend

                ELSE 0

            END

        ) AS acquisition_cost

    FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`fact_marketing`

    GROUP BY

        date_key,

        channel_key,

        campaign_key

)

--------------------------------------------------
-- FINAL TABLE
--------------------------------------------------

SELECT

    --------------------------------------------------
    -- REPORTING DIMENSIONS
    --------------------------------------------------

    ss.date_key
        AS report_date,

    dch.channel_name,

    dcmp.campaign_id,

    dcmp.campaign_name,

    dcmp.campaign_type,

    ss.region,

    --------------------------------------------------
    -- CUSTOMER FACTS
    --------------------------------------------------

    ss.total_customers,

    ss.new_customers,

    ss.returning_customers,

    --------------------------------------------------
    -- SALES FACTS
    --------------------------------------------------

    ss.total_orders,

    ss.total_revenue,

    ss.gross_profit,

    --------------------------------------------------
    -- MARKETING FACTS
    --------------------------------------------------

    COALESCE(

        ms.acquisition_cost,

        0

    ) AS acquisition_cost,

    COALESCE(

        ms.total_ad_spend,

        0

    ) AS total_ad_spend,

    --------------------------------------------------
    -- AUDIT
    --------------------------------------------------

    CURRENT_TIMESTAMP()

        AS loaded_at

FROM sales_summary ss

LEFT JOIN marketing_summary ms

    ON ss.date_key = ms.date_key

   AND ss.channel_key = ms.channel_key

   AND ss.campaign_key = ms.campaign_key

JOIN `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_channels` dch

    ON ss.channel_key =
       dch.channel_key

JOIN `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`dim_campaigns` dcmp

    ON ss.campaign_key =
       dcmp.campaign_key
    );
  