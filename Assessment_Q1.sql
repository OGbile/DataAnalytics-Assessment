-- aggregate plans by user
with plans as (
    select
        owner_id,
        sum(case when is_regular_savings = 1 then 1 else 0 end) as savings_count,
        sum(case when is_a_fund = 1 then 1 else 0 end) as investment_count
    from adashi_staging.plans_plan
    group by owner_id
),

-- aggregate total deposits 
deposits as (
    select
        owner_id as owner_id, 
        sum(confirmed_amount) / 100 as total_deposits_in_naira
    from adashi_staging.savings_savingsaccount
    where transaction_status = 'success'
    group by owner_id
)

-- join CTEs and apply filters
select
    u.id as user_id,
    concat(u.first_name, ' ', u.last_name) as name,
    p.savings_count,
    p.investment_count,
    round(coalesce(d.total_deposits_in_naira, 0), 2) as total_deposits_in_naira
from adashi_staging.users_customuser u
join plans p on u.id = p.owner_id
left join deposits d on u.id = d.owner_id
where 
    p.savings_count > 0 and 
    p.investment_count > 0 and 
    coalesce(d.total_deposits_in_naira, 0) > 0
order by d.total_deposits_in_naira desc

