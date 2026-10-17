
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='TRADE_ID'
    )
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
    STATUS,
    LOAD_TIMESTAMP,
    CASE
        WHEN MATURITY_DATE < CURRENT_DATE()
            THEN 'MATURED'
        ELSE STATUS
    END AS TRADE_STATUS
FROM {{ ref('stg_trade') }}

{% if is_incremental() %}
WHERE LOAD_TIMESTAMP > (
    SELECT COALESCE(
        MAX(LOAD_TIMESTAMP),
        '1900-01-01'::TIMESTAMP_NTZ
    )
    FROM {{ this }}
)
{% endif %}
