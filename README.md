# DataAnalytics-Assessment
## Question Explanations
### Question 1
<p align="justify">
To identify customers with at least one funded savings plan and one funded investment plan, I first created a CTE named plans that counts the number of funded savings and investment plans per user and  grouped them by their unique IDs. Then, I wrote a second CTE called deposits to aggregate the total successful deposits for each user, converting amounts from kobo to naira for easier comparison. In the final query, I joined the users table with both CTEs on user IDs to return the user id for each user,  concatenated the first and last names to address missing values in the name column, returned the plan type as expected and rounded up the results to two decimal places for readability. The query then filters for users who have counts greater than zero for both plan types and a positive total deposit amount, and it sorts the results by total deposits in descending order.

The main challenge I experienced while working on this task was determining the appropriate unit in which to report the deposit amounts. The raw data was in kobo, and it was not expressly stated whether the expected output should remain in kobo or be converted to naira. I made the decision to convert the values to naira, assuming that this would be the expected and more readable format for analysis and reporting.
</p>

### Question 2
<p align="justify">
To calculate the average number of transactions per customer per month and categorize them by frequency, I created a CTE named transaction_summary that sums the total count of successful transactions for each user (owner_id) and counts the distinct months in which transactions occurred. To ensure the average calculation was accurate, I divided the total successful transactions by the number of distinct months per user in a second CTE called user_average, to address any potential division by zero. Using this average, I then categorized customers into the three groups: "High Frequency" for those with an average of 10 or more transactions per month, "Medium Frequency" for averages between 3 and 9, and "Low Frequency" for 2 or fewer. Finally, I grouped the results by these frequency categories, counted the number of customers in each group, calculated the average transactions per month rounded to two decimal places for clarity, and ordered the output so that the categories appear from high to low frequency.
</p>

### Question 3
<p align="justify">
This task required extracting active savings or investment accounts with no transactions in the last 365 days. I used a CTE called last_txn_date to extract the most recent transaction date per user and plan by taking the MAX of the transaction_date. After this, I wrote another CTE called plan_type to classify each plan as either “Savings” or “Investments” based on specific  flags (is_regular_savings and is_a_fund) in the plans_plan table. I also included a third CTE, max_date, to get the latest transaction date across the dataset, to serve as the reference point for calculating inactivity. In the final query, I joined the last_txn_date with the plan_type and used a cross join with max_date to calculate the number of days since each plan’s last transaction. I then filtered for accounts with 365 or more inactive days and ensured only savings and investment plans were considered. The results were grouped accordingly and ordered by the number of inactive days in descending order to highlight the most inactive accounts.
</p>

### Question 4
<p align="justify">
This analysis aimed to calculate the estimated customer lifetime value (CLV) based on a 0.1% profit margin per transaction. I began by preparing a base dataset that captured each customer's tenure (in months), total successful transactions, and the average profit per transaction. The tenure was derived using the difference in months between the customer's registration date and the current date. For profitability, I focused on inflows—specifically successful deposits—by applying a 0.1% rate after converting the amounts from kobo to naira.

With this base in place, I then computed the estimated CLV byapplyinmg the formula: total_transactions / tenure) * 12 * avg_profit_per_transaction. The final result was rounded for readability and ranked in descending order to show the most valuable customers.

A key challenge here was determining which type of transaction to base the profit calculation on. Since the problem did not clarify whether withdrawals should be considered, I assumed only inflows were profit-generating.
</p>
