--Bank Transaction Analysis

-- QUERY 1: DISPLAY customers and their bank accounts

SELECT 
  c.customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  a.account_number,
  a.account_type,
  a.current_balance,
  a.account_status
FROM customers AS c
JOIN accounts AS a 
 ON c.customer_id = a.customer_id
ORDER BY c.customer_id, a.account_type;

-- QUERY 2: SUMMARIZE accounts by account type

SELECT 
   account_type,
   COUNT(*) as total_accounts,
   SUM(current_balance) AS total_balance,
   ROUND(AVG(current_balance),2) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;

-- QUERY 3: RANK customers by completed purchase spending

SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(t.transaction_id) AS completed_purchases,
    ROUND(SUM(t.amount),1) AS total_spent
FROM customers AS c
JOIN accounts AS a
 ON c.customer_id = a.customer_id
JOIN transactions AS t
 ON a.account_id = t.account_id
WHERE t.transaction_type = 'purchase'
  AND t.transaction_status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- QUERY 4: spending by merchant

SELECT 
 m.category,
 COUNT(t.transaction_id) as total_transactions,
 ROUND(SUM(t.amount),2) as total_spent,
 ROUND(AVG(t.amount),2) as avg_amount
FROM merchants as m
JOIN transactions as t
 ON m.merchant_id = t.merchant_id
WHERE t.transaction_type = 'purchase'
AND t.transaction_status = 'completed'
GROUP BY m.category
ORDER BY total_spent DESC;

-- QUERY 5: Summarize transactions by status

SELECT 
  transaction_status,
  COUNT(*) as total_transactions,
  ROUND(SUM(amount),2) as total_amount,
  ROUND(AVG(amount),2) as avg_amount
FROM transactions
GROUP BY transaction_status
ORDER BY total_transactions DESC;

-- QUERY 6: Summarize transactions by channel

SELECT 
  channel,
  COUNT(*) AS total_transactions,
  COUNT(*) FILTER (WHERE transaction_status = 'complete') AS completed_transactions,
  ROUND(SUM(amount),2) AS total_amount,
  ROUND( 100.0 * COUNT(*) FILTER (WHERE transaction_status = 'complete') / COUNT(*),2) AS completion_rate
  FROM transactions
  GROUP BY channel
  ORDER BY total_amount DESC;

-- QUERY 7: analyze monthly transaction
SELECT 
 DATE_TRUNC('month' , transaction_timestamp) :: DATE as transaction_month,
 COUNT(*) AS total_transactions,
 COUNT(*) FILTER (WHERE transaction_status = 'completed') AS completed_transactions,
 ROUND(SUM(amount),2) AS total_amount,
 ROUND(SUM(amount) FILTER (WHERE transaction_status = 'completed'),2) AS completed_transactions_amount
FROM transactions
GROUP BY transaction_month
ORDER BY transaction_month;

-- QUERY 8: Finding customers with multiple accounts
SELECT 
 c.customer_id,
 c.first_name || ' ' || c.last_name AS customer_name,
 COUNT(a.account_id) AS total_accounts,
 ROUND(SUM(a.current_balance),2) AS total_balance
FROM customers AS c
JOIN accounts AS a 
  ON c.customer_id = a.customer_id
GROUP BY c.customer_id, customer_name
HAVING COUNT (a.account_id) > 1
ORDER BY total_accounts DESC;

-- QUERY 9: merchants with no completed purchases
SELECT 
 m.merchant_id,
 m.merchant_name,
 m.category,
 COUNT(t.transaction_id) AS total_transactions
FROM merchants AS m
JOIN transactions AS t
 ON m.merchant_id = t.merchant_id
WHERE transaction_type = 'purchase'
 AND transaction_status != 'completed'
GROUP BY m.merchant_id, m.merchant_name, m.category
ORDER BY total_transactions DESC;

--Query:10 Finding transactions above overall average
SELECT 
 t.reference_number,
 c.first_name || ' ' || c.last_name AS customer_name,
 a.account_number,
 t.account_id,
 t.merchant_id,
 COALESCE(m.merchant_name, 'No Merchant') AS merchant_name,
 t.amount,
  t.transaction_type
FROM transactions AS t 
JOIN accounts AS a 
 ON t.account_id = a.account_id
JOIN merchants AS m
 ON t.merchant_id = m.merchant_id
JOIN customers AS c
 ON a.customer_id = c.customer_id
WHERE t.amount > (SELECT AVG (amount) FROM transactions)
ORDER BY t.amount DESC;

--QUERY: 11 Calculating net transaction amount by account
SELECT
 a.account_number,
 c.first_name || ' ' || c.last_name AS customer_name,
 a.account_type,
 COUNT(transaction_id) AS total_transactions,
 ROUND(
  SUM(
    CASE 
     WHEN t.transaction_type IN ('deposit', 'refund') THEN t.amount
     WHEN t.transaction_type IN ('withdrawal', 'purchase', 'transfer') THEN -t.amount
     END
  ), 2
 ) AS net_transaction_amount
FROM accounts AS a
JOIN transactions as t 
 ON a.account_id = t.account_id
JOIN customers AS c 
 ON a.customer_id = c.customer_id
GROUP BY a.account_number, customer_name, account_type, a.account_id
ORDER BY net_transaction_amount DESC;

-- Query 12: Find the top 5 merchants by purchase value

SELECT 
 m.merchant_id,
  m.merchant_name,
  m.category,
  COUNT(t.transaction_id) AS total_transactions,
  ROUND(SUM(t.amount),2) AS total_purchase_value
FROM merchants AS m
JOIN transactions as t 
 ON m.merchant_id = t.merchant_id
WHERE t.transaction_type = 'purchase'
AND t.transaction_status = 'completed'
GROUP BY m.merchant_id, m.merchant_name, m.category
ORDER BY total_purchase_value DESC
LIMIT 5;

-- QUERY 13: USE CTE to calculate customer cash flow
WITH customer_cash_flow AS (
  SELECT 
   c.customer_id, c.first_name || ' '|| c.last_name as customer_name,
   SUM(
    CASE 
     WHEN t.transaction_type IN ('deposit', 'refund') THEN t.amount
     ELSE 0
     END
    
   ) AS total_inflow,
  SUM(
    CASE 
     WHEN t.transaction_type IN ('withdrawal', 'purchase', 'transfer') THEN t.amount
      ELSE 0
      END
    ) AS total_outflow
  FROM customers AS c
  JOIN accounts AS a 
   ON c.customer_id = a.customer_id
  JOIN transactions AS t
    ON a.account_id = t.account_id
  GROUP BY c.customer_id, customer_name
)
SELECT 
 customer_id,
 customer_name,
 total_inflow,
 total_outflow,
  ROUND(total_inflow - total_outflow,2) AS net_cash_flow
FROM customer_cash_flow
ORDER BY net_cash_flow DESC;

-- QUERY 14: Find customers with above average spending (use two cte)
WITH customer_spending AS (
  SELECT 
   c.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
    SUM(t.amount) AS total_spent
    FROM customers AS c
    JOIN accounts AS a 
    ON c.customer_id = a.customer_id
    JOIN transactions AS t
      ON a.account_id = t.account_id
    WHERE t.transaction_type = 'purchase'
      AND t.transaction_status = 'completed'
    GROUP BY c.customer_id, customer_name
),
average_spending AS (
  SELECT AVG(total_spent) AS avg_spent
  FROM customer_spending
)

SELECT 
 cs.customer_id,
  cs.customer_name,
  cs.total_spent,
  av.avg_spent
FROM customer_spending AS cs
JOIN average_spending AS av
 ON cs.total_spent > av.avg_spent
ORDER BY cs.total_spent DESC;

--QUERY 15: Rank customers by spending
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(t.transaction_id) AS completed_purchases,
        SUM(t.amount) AS total_spent
    FROM customers AS c
    JOIN accounts AS a
        ON c.customer_id = a.customer_id
    JOIN transactions AS t
        ON a.account_id = t.account_id
    WHERE t.transaction_type = 'purchase'
      AND t.transaction_status = 'completed'
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT
    customer_id,
    customer_name,
    completed_purchases,
    ROUND(total_spent, 2) AS total_spent,
    DENSE_RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM customer_spending
ORDER BY spending_rank, customer_name;
-- =====================================================
-- Query 16: Calculate running transaction flow
-- Window function: SUM OVER
-- =====================================================

WITH signed_transactions AS (
    SELECT
        t.transaction_id,
        a.account_number,
        t.reference_number,
        t.transaction_timestamp,
        t.transaction_type,
        t.amount,
        CASE
            WHEN t.transaction_type IN ('deposit', 'refund')
                THEN t.amount
            WHEN t.transaction_type IN (
                'purchase',
                'withdrawal',
                'transfer'
            )
                THEN -t.amount
            ELSE 0
        END AS signed_amount
    FROM transactions AS t
    JOIN accounts AS a
        ON t.account_id = a.account_id
    WHERE t.transaction_status = 'completed'
)
SELECT
    account_number,
    reference_number,
    transaction_timestamp,
    transaction_type,
    amount,
    ROUND(
        SUM(signed_amount) OVER (
            PARTITION BY account_number
            ORDER BY transaction_timestamp, transaction_id
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ),
        2
    ) AS running_net_flow
FROM signed_transactions
ORDER BY
    account_number,
    transaction_timestamp,
    transaction_id;


-- =====================================================
-- Query 17: Compare each transaction with the previous one
-- Window function: LAG
-- =====================================================

WITH transaction_comparison AS (
    SELECT
        t.transaction_id,
        a.account_number,
        t.reference_number,
        t.transaction_timestamp,
        t.transaction_type,
        t.amount,
        LAG(t.amount) OVER (
            PARTITION BY t.account_id
            ORDER BY t.transaction_timestamp, t.transaction_id
        ) AS previous_transaction_amount
    FROM transactions AS t
    JOIN accounts AS a
        ON t.account_id = a.account_id
)
SELECT
    account_number,
    reference_number,
    transaction_timestamp,
    transaction_type,
    amount,
    previous_transaction_amount,
    ROUND(
        amount - previous_transaction_amount,
        2
    ) AS amount_difference
FROM transaction_comparison
ORDER BY
    account_number,
    transaction_timestamp,
    transaction_id;


-- =====================================================
-- Query 18: Calculate a three-transaction moving average
-- Window function: AVG OVER
-- =====================================================

SELECT
    a.account_number,
    t.reference_number,
    t.transaction_timestamp,
    t.transaction_type,
    t.amount,
    ROUND(
        AVG(t.amount) OVER (
            PARTITION BY t.account_id
            ORDER BY t.transaction_timestamp, t.transaction_id
            ROWS BETWEEN 2 PRECEDING
                     AND CURRENT ROW
        ),
        2
    ) AS three_transaction_moving_average
FROM transactions AS t
JOIN accounts AS a
    ON t.account_id = a.account_id
WHERE t.transaction_status = 'completed'
ORDER BY
    a.account_number,
    t.transaction_timestamp,
    t.transaction_id;






 







