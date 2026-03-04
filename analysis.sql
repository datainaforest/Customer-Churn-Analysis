/* =====================================================
   TELCO CUSTOMER CHURN ANALYSIS
   Author: Łukasz Trzeciak
   Database: Telco Churn Dataset
   ===================================================== */


/* =====================================================
   DATA EXPLORATION
   ===================================================== */


/* Total number of customers */

select
	count(*) as total_customers
from telco_churn


/* Churn distribution */

select 
	churn
	,count(*) as total_customers
from telco_churn 
group by churn


/*Churn rate*/

select 
	churn
	,COUNT(*) as total_customers
	,ROUND(100*COUNT(*) / SUM(COUNT(*)) over (),2) as percentage
from telco_churn
group by churn 


/* =====================================================
   KPI METRICS
   ===================================================== */


/* Average monthly charges */

select 
	ROUND(AVG(MonthlyCharges),2) as avg_monthly_charges
from telco_churn


/*Average tenure */

select 
	ROUND(AVG(tenure ),2) as avg_customer_lifetime
from telco_churn


/*Revenue Share by churn Status*/

select
	churn
	,ROUND(SUM(MonthlyCharges),2) as total_monthly_revenue
	,ROUND(100 * SUM(MonthlyCharges) / SUM(SUM(MonthlyCharges )) over (),2) as percentage
from telco_churn
group by churn


/* =====================================================
   CHURN DRIVERS ANALYSIS
   ===================================================== */


/*Churn Rate by Contract Type*/

select 
	contract
	,churn
	,COUNT(*) as total_customers
	,ROUND(100 * COUNT(*) / SUM(COUNT(*)) over(partition by contract),2) as percentage
from telco_churn
group by contract, Churn
order by contract 


/*Churn Rate by Payment Method*/

select 
	PaymentMethod 
	,Churn 
	,COUNT(*) as total_customers
	,ROUND(100 * COUNT(*) / SUM(COUNT(*)) over (partition by paymentmethod),2) as percentage
from telco_churn
group by PaymentMethod, churn
order by PaymentMethod 


/*Average Monthly Charges by Customer Status*/

select 
	churn
	, ROUND(AVG(MonthlyCharges),2) as avg_monthly_charges
from telco_churn
group by Churn 


/* =====================================================
   CUSTOMER TENURE SEGMENTATION
   ===================================================== */


/* Customer segmentation by tenure group */

SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12'
        WHEN tenure <= 24 THEN '13-24'
        WHEN tenure <= 48 THEN '25-48'
        ELSE '49+'
    END AS tenure_group,
    ROUND(
        100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churned_percentage
FROM telco_churn
GROUP BY tenure_group
ORDER BY tenure_group;
	
