--find top 10 highest reveue generating products

select top 10 product_id,sum(sale_price*quantity) as sum from df_orders
group by product_id
order by sum desc



--find top 5 highest selling products in each region
with cte as (select product_id,region,sum(sale_price*quantity) as sales from df_orders
group by product_id,region
)

,cte2 as (select *, DENSE_RANK() over(partition by region order by sales desc) as d_rnk from cte)

select product_id,sales,region from cte2
where d_rnk<=5


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023


with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
round(sum(sale_price*quantity),2) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
,sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month


--for each category which month had highest sales

with cte as (select format(order_date,'yyyyMM') as order_year_month,category,sum(sale_price*quantity) as sales from df_orders
group by category,format(order_date,'yyyyMM')
)

,rn_cte as (select *, row_number() over(partition by category order by sales desc) as rn from cte )

select category,order_year_month, sales from rn_cte
where rn=1
--which sub category had highest growth by profit in 2023 compare to 2022

with cte as (select datepart(year,order_date) as order_year , sub_category, round(sum(profit),2) as total_profit from df_orders
group by datepart(year,order_date),sub_category)


,cte2 as(select sub_category,
sum(case when order_year=2022 then total_profit else 0 end ) as year_2022,
sum(case when order_year=2023 then total_profit else 0 end ) as year_2023
from cte
group by sub_category)

select top 1 *, year_2022-year_2023 as growth from cte2
order by growth desc

















select * from df_orders
 


