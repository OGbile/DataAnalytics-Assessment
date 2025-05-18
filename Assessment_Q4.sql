with base as (
SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    -- count all successful transactions
	SUM(CASE 
            WHEN s.transaction_status = 'success' THEN 1 
            ELSE 0 
        END) AS total_transactions,
	-- factor in 0.1% charge for inflows
	COALESCE(
            AVG(CASE
                WHEN s.confirmed_amount IS NOT NULL
                     AND s.transaction_status = 'success' 
                -- convert from kobo to naira then apply the multiplier
                THEN ((s.confirmed_amount / 100) * 0.001) 
                ELSE NULL 
            END), 0
        ) AS avg_profit_per_transaction
    FROM adashi_staging.users_customuser u
    LEFT JOIN adashi_staging.savings_savingsaccount s 
        ON u.id = s.owner_id
    GROUP BY 
        u.id,
        CONCAT(u.first_name, ' ', u.last_name),
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE)
)

SELECT 
    customer_id, 
    name, 
    tenure_months,
    total_transactions,
    ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) AS estimated_clv
FROM base
ORDER BY estimated_clv DESC