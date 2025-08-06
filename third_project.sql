## third_project_6_August_2025
## In_this_project_I'm_applying_6_steps_strategy_as_i'v_learned_from_Google_data_analytics_course
## the_6_steps_strategy_ask_prepare_process_analyze_share_act
## first_step_Ask
##1.Which coffee type generates the highest revenue?
##2.During which time of day are sales the highest?
##3.Do customers pay more often with cash or card?
##4.Which day of the week has the highest total sales?
##5.Which month of the year has the highest revenue?

###Second_step_prepare
select *
from coffe_sales;

create table coffe_sales_staging
like coffe_sales;

insert coffe_sales_staging
select *
from coffe_sales;

select *
from coffe_sales_staging;

## add one more column row_num to check duplicates
select *,
row_number() over(partition by `date`, `datetime`, hour_of_day, cash_type, card, money, coffee_name, Time_of_Day, 
Weekday, Month_name, Weekdaysort, Monthsort
 ) as row_num
from coffe_sales_staging;

## create CTE for filter duplicates 
with duplicates_CTE as 
(
select *,
row_number() over(partition by `date`, `datetime`, hour_of_day, cash_type, card, money, coffee_name, Time_of_Day, 
Weekday, Month_name, Weekdaysort, Monthsort
 ) as row_num
from coffe_sales_staging
)
select *
from duplicates_CTE
where row_num > 1;  
##so,there's_no_duplicates_great!!

##lets_change_the_format_of_date_from_text_format_to_date_format
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from coffe_sales_staging;
##now_update_it
update coffe_sales_staging
set `date` = str_to_date(`date` , '%m/%d/%Y');

###3.prepare
select *
from coffe_sales_staging;

##check_nulls
SELECT
  COUNT(*) AS total_rows,
  COUNT(`date`) AS non_null_dates,
  COUNT(`datetime`) AS non_null_datetime,
  COUNT(money) AS non_null_money,
  COUNT(coffee_name) AS non_null_coffee_name,
  COUNT(cash_type) AS non_null_cash_type  
from coffe_sales_staging;
##all_have_the_count_3636_so,_there's_no_nulls

SELECT DISTINCT hour_of_day
FROM coffe_sales_staging
ORDER BY hour_of_day;
##i_think_it_opens_6am_and_closes_about_10pm

select distinct cash_type
from coffe_sales_staging;


select min(`date`),max(`date`)
from coffe_sales_staging;
##this_data_is_about_one_year


###4.Analyze
##1.Which coffee type generates the highest revenue?
select *
from coffe_sales_staging;

select distinct coffee_name
from coffe_sales_staging;

select coffee_name,round(sum(money),2) as total_revenue_for_one
from coffe_sales_staging
group by coffee_name
order by total_revenue_for_one desc
limit 5 ;
##so_the_highest_revenue_comes_from_Latte 

##2. During which time of day are sales the highest?
select *
from coffe_sales_staging;

select hour_of_day,round(sum(money),2) as total_revenue_for_hour
from coffe_sales_staging
group by hour_of_day
order by total_revenue_for_hour desc;
##it's_10am 


##3.Do customers pay more often with cash or card?
select *
from coffe_sales_staging;

SELECT 
  cash_type,
  COUNT(*) AS payments,
  round(sum(money),2) AS total_value
FROM coffe_sales_staging
GROUP BY cash_type;
##it's_card

##4. Which day of the week has the highest total sales?
select *
from coffe_sales_staging;

select Weekday,round(sum(money),2) as total_revenue_for_day
from coffe_sales_staging
group by Weekday
order by total_revenue_for_day desc
##it's_Tuesday 

##5.Which month of the year has the highest revenue?
select *
from coffe_sales_staging;

select Month_name,round(sum(money),2) as total_revenue_for_month
from coffe_sales_staging
group by Month_name
order by total_revenue_for_month desc;
##it's_Mars

















