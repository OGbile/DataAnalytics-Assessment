-- compute last transaction date for each user by user id and plan id
WITH last_txn_date AS (
    SELECT 
        a.owner_id,
        a.plan_id,
        MAX(CAST(a.transaction_date AS DATE)) AS last_transaction_date
    FROM adashi_staging.savings_savingsaccount a
    GROUP BY a.owner_id, a.plan_id
),

plan_type AS (
    SELECT 
        p.plan_type_id, 
        p.owner_id,  
        CASE 
            WHEN p.is_a_fund = 1 THEN 'Investments'
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            ELSE 'Other'
        END AS type
    FROM adashi_staging.plans_plan p
    WHERE p.is_a_fund = 1 OR p.is_regular_savings = 1
),
-- extract the latest transaction date across all records
max_date AS (
    SELECT MAX(CAST(transaction_date AS DATE)) AS max_date
    FROM adashi_staging.savings_savingsaccount
)

SELECT 
    l.plan_id, 
    l.owner_id, 
    p.type,
    l.last_transaction_date, 
    DATEDIFF(m.max_date, last_transaction_date) AS inactive_days
FROM last_txn_date l 
LEFT JOIN plan_type p 
    ON l.owner_id = p.owner_id 
    AND l.plan_id = p.plan_type_id
CROSS JOIN max_date m
WHERE DATEDIFF(m.max_date, last_transaction_date) >= 365
  AND type IN ('Savings', 'Investments')
GROUP BY 
    l.plan_id, 
    l.owner_id, 
    p.type,
    l.last_transaction_date,
    DATEDIFF(m.max_date, last_transaction_date)
ORDER BY inactive_days DESC