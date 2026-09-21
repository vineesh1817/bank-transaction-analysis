-- Bank Transaction Analysis
-- Views and indexes

-- =====================================================
-- View 1: Customer and account details
-- =====================================================

CREATE OR REPLACE VIEW vw_customer_account_summary AS
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.city,
    c.state,
    a.account_id,
    a.account_number,
    a.account_type,
    a.current_balance,
    a.account_status,
    a.opened_date
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id;


-- =====================================================
-- View 2: Completed customer purchase summary
-- =====================================================

CREATE OR REPLACE VIEW vw_customer_spending_summary AS
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(t.transaction_id) FILTER (
        WHERE t.transaction_type = 'purchase'
          AND t.transaction_status = 'completed'
    ) AS completed_purchases,
    COALESCE(
        SUM(t.amount) FILTER (
            WHERE t.transaction_type = 'purchase'
              AND t.transaction_status = 'completed'
        ),
        0
    ) AS total_spent
FROM customers AS c
LEFT JOIN accounts AS a
    ON c.customer_id = a.customer_id
LEFT JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;


-- =====================================================
-- View 3: Monthly transaction summary
-- =====================================================

CREATE OR REPLACE VIEW vw_monthly_transaction_summary AS
SELECT
    DATE_TRUNC('month', transaction_timestamp)::DATE
        AS transaction_month,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (
        WHERE transaction_status = 'completed'
    ) AS completed_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_volume,
    ROUND(
        COALESCE(
            SUM(amount) FILTER (
                WHERE transaction_status = 'completed'
            ),
            0
        ),
        2
    ) AS completed_transaction_volume
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_timestamp);

-- =====================================================
-- INDEXES
-- =====================================================

-- Speeds up finding all accounts owned by a customer.
CREATE INDEX IF NOT EXISTS idx_accounts_customer_id
    ON accounts(customer_id);

-- Supports account history and window-function queries.
CREATE INDEX IF NOT EXISTS idx_transactions_account_timestamp
    ON transactions(account_id, transaction_timestamp);

-- Speeds up joins between transactions and merchants.
CREATE INDEX IF NOT EXISTS idx_transactions_merchant_id
    ON transactions(merchant_id);

-- Supports filtering by transaction type and status.
CREATE INDEX IF NOT EXISTS idx_transactions_type_status
    ON transactions(transaction_type, transaction_status);

-- Supports date-range and monthly analysis.
CREATE INDEX IF NOT EXISTS idx_transactions_timestamp
    ON transactions(transaction_timestamp);

-- Partial index containing only completed purchases.
CREATE INDEX IF NOT EXISTS idx_transactions_completed_purchases
    ON transactions(merchant_id, transaction_timestamp)
    WHERE transaction_type = 'purchase'
      AND transaction_status = 'completed';