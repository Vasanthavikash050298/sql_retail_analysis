
create table retail_sales
		(
		transactions_id int primary key,	
		sale_date DATE,
		sale_time TIME,
		customer_id	int,
		gender char(6),
		age	int,
		category varchar(100),
		quantiy	int,
		price_per_unit float,
		cogs float,	
		total_sale float
		)
alter table retail_sales
rename column quantiy to quantity

--data cleaning
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULl
delete  from retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULl
	
	
 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
 select * from retail_sales
 where sale_date='2022-11-05'

 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where category ='Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as total_sales from retail_sales
group by category
order by category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as average_age from retail_sales
where category='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(*) as total_transactions from retail_sales
group by 1,2
order by 1



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
       avg_sale,2
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY (AVG(total_sale)) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id) as unique_customer,category from retail_sales
group by 2
order by 2

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hoursale as
(select 
    case
	when extract(hours from sale_time)<12 then 'morning'
	when extract(hours from sale_time)between 12 and 15 then 'noon'
	else 'evening'
	end as shift 
from retail_sales)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hoursale
GROUP BY shift