
-- aggregate total successful transactions 
with transaction_summary  AS (
    SELECT
        owner_id AS owner_id, 
        sum(case when s.transaction_status='success' then 1 else 0 end ) txn_count,
        count( distinct extract(month from s.transaction_date)) as month_count
    FROM adashi_staging.savings_savingsaccount s
    GROUP BY owner_id
),
user_average as 
(
select owner_id,
 txn_count, 
 txn_count/nullif(month_count,0) avg_no
from transaction_summary)

select  
 case when avg_no >=10 then 'High Frequency'
 when avg_no  between 3 and 9 then 'Medium Frequency'
 else 'Low Frequency' end as frequency_category,
 count(owner_id) customer_count,
round( avg(avg_no),2) avg_transactions_per_month
 from user_average
group by frequency_category
-- order the categories from high to low
order by 
case when frequency_category = 'High Frequency' then 1
 when frequency_category = 'Medium Frequency' then 2
 when frequency_category = 'Low Frequency' then 3
 end 





