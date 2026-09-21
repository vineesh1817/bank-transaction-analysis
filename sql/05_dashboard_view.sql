-- Transaction-level reporting view for Tableau

CREATE OR REPLACE VIEW vw_transaction_dashboard AS
SELECT
    t.transaction_id,
    t.reference_number,
    t.transaction_timestamp,
    t.transaction_timestamp::DATE AS transaction_date,
    DATE_TRUNC('month', t.transaction_timestamp)::DATE
        AS transaction_month,
    t.transaction_type,
    t.transaction_status,
    t.channel,
    t.amount,
    t.balance_after_transaction,
    t.description,

    CASE
        WHEN t.transaction_status = 'completed' THEN 1
        ELSE 0
    END AS completed_flag,

    CASE
        WHEN t.transaction_status = 'failed' THEN 1
        ELSE 0
    END AS failed_flag,

    CASE
        WHEN t.transaction_status = 'completed' THEN t.amount
        ELSE 0
    END AS completed_amount,

    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city AS customer_city,
    c.state AS customer_state,

    a.account_id,
    a.account_number,
    a.account_type,
    a.account_status,

    m.merchant_id,
    COALESCE(m.merchant_name, 'No merchant') AS merchant_name,
    COALESCE(m.category, 'Not applicable') AS merchant_category,
    COALESCE(m.city, 'Not applicable') AS merchant_city,
    COALESCE(m.state, 'Not applicable') AS merchant_state

FROM transactions AS t
JOIN accounts AS a
    ON t.account_id = a.account_id
JOIN customers AS c
    ON a.customer_id = c.customer_id
LEFT JOIN merchants AS m
    ON t.merchant_id = m.merchant_id;
