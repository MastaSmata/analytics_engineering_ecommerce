

  create or replace view `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`stg_channels`
  OPTIONS()
  as SELECT
    LOWER(TRIM(channel_name)) AS channel_name,
    LOWER(TRIM(channel_category)) AS channel_category,
    LOWER(TRIM(traffic_type)) AS traffic_type

FROM `project-004c9430-f8fa-4b9a-861`.`ecommerce_data`.`raw_channels`;

