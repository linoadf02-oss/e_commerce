
{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        TRADE_ID,
        CUSTOMER_ID,
        BRANCH_ID,
        COUNTERPARTY_ID,
        UPPER(PRODUCT_TYPE) AS PRODUCT_TYPE,
        TRADE_DATE,
        MATURITY_DATE,
        TRADE_AMOUNT,
        UPPER(STATUS) AS STATUS,
        LOAD_TIMESTAMP
    FROM {{ source('trade_source', 'raw_trade') }}
),

deduplicated AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY TRADE_ID
            ORDER BY LOAD_TIMESTAMP DESC
        ) AS rn
    FROM source_data
)

SELECT
    TRADE_ID,
    CUSTOMER_ID,
    BRANCH_ID,
    COUNTERPARTY_ID,
    PRODUCT_TYPE,
    TRADE_DATE,
    MATURITY_DATE,
    TRADE_AMOUNT,
    STATUS,
    LOAD_TIMESTAMP
FROM deduplicated
WHERE rn = 1
  AND TRADE_AMOUNT > 0
