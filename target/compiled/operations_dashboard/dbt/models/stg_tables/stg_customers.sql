SELECT
    TRIM(customer_id) AS customer_id,
    LOWER(TRIM(gender)) AS gender,
    SAFE_CAST(age AS INT64) AS age,
    LOWER(TRIM(country)) AS country,
    LOWER(TRIM(region)) AS region,
    LOWER(TRIM(city)) AS city,
    SAFE_CAST(acquisition_date AS DATE) AS acquisition_date,
    LOWER(TRIM(acquisition_channel)) AS acquisition_channel,
    TRIM(acquisition_campaign) AS acquisition_campaign

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`raw_customers`