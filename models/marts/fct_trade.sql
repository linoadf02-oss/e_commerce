
{{
    config(materialized='table')
}}

SELECT
    TRADE_ID,
    CUSTOMER_ID,
    BRANCH_ID,
    COUNTERPARTY_ID,
    PRODUCT_TYPE,
    TRADE_DATE,
    MATURITY_DATE,
    TRADE_AMOUNT,
    TRADE_STATUS,
    LOAD_TIMESTAMP
FROM {{ ref('int_trade') }}
