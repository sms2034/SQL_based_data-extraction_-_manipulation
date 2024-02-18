

# 1.A Identifing and listing the primary and foreign keys for the dataset

-- market_fact: This tables has no primary keys (combination of cust_id, prod_id, ord_id and ship_id is also not unique) 
		-- Ord_id is a foreign key to order_dimen table; cust_id is a foreign key to cust_dimen; prod_id is a foreign key to prod_dimen;
		-- Ship_id is a foreign key for shipping_dimen.
-- cust_dimen: cust_id is the primary key of this table, there are no foreign keys in this table
-- order_dimen: Ord_id is the primary key for this table. there are no foreign keys in this table
-- prod_dimen: prod_id acts as primary key for this table and there are no foreign keys in this table
-- shipping_dimen: ship_id acts as primary key for this table. There are no foreign keys in this table

-- -----------------------------------------------------------------------------------------------
# 2.A Finding the total and average sales 

select sum(Sales) as total_sales, avg(sales) as avg_sales	 			-- renaming sum(sales) as total_sales and avg(sales) as avg_sales
from market_fact;

-- -----------------------------------------------------------------------------------------------
# 2.B Number of customers in each region in decreasing order of no_of_customers. 

select region, count(cust_id) as no_of_customers 						
from cust_dimen
group by region
order by no_of_customers desc; 											-- in descending order of no_of_customers

-- -----------------------------------------------------------------------------------------------
# 2.C Region having maximum customers 

select region, count(cust_id) as no_of_customers
from cust_dimen
group by Region
order by count(Cust_id) desc
limit 1;																-- Limit arguement to show only top row i.e. max(no_of_customers)

-- -----------------------------------------------------------------------------------------------
# 2.D Number and id of products sold in decreasing order of products sold 

select prod_id, sum(Order_Quantity) as no_of_products_sold 				
from market_fact
group by Prod_id
order by no_of_products_sold desc; 										

-- -----------------------------------------------------------------------------------------------		
# 3.A Product categories in descending order of profits 

select product_category, sum(profit) as profits 						
from market_fact m
left outer join prod_dimen p on p.Prod_id = m.Prod_id     				
group by Product_Category
order by profits desc;

-- -----------------------------------------------------------------------------------------------
# 3.B Product category, product sub-category and the profit within each subcategory 

select product_category, Product_Sub_Category, sum(profit) as profits 	
from market_fact m
left outer join prod_dimen p on p.Prod_id = m.Prod_id     				
group by Product_Category, Product_Sub_Category 						
order by Product_Category, Product_Sub_Category; 						

-- -----------------------------------------------------------------------------------------------
/* 3.C Where is the least profitable product subcategory shipped the most? region-wise no_of_shipments for the least profitable 
product sub category and the profit made in each region in decreasing order of profits */

select product_sub_category 												
from market_fact m
left outer join prod_dimen p on p.Prod_id = m.Prod_id 					
group by Product_Sub_Category
order by sum(profit) 													
limit 1; 																

select region, count(Ship_id)
from market_fact m
left outer join cust_dimen c on  c.Cust_id = m.Cust_id
left outer join prod_dimen p on p.Prod_id = m.Prod_id
where Product_Sub_Category = "Tables" 									
group by region
order by count(Ship_id) desc
limit 1;

select region, count(Ship_id) as no_of_shipments, sum(Profit) as profit_in_each_region
from market_fact m
left outer join cust_dimen c on c.Cust_id = m.Cust_id 					
left outer join prod_dimen p on p.Prod_id = m.Prod_id 					
where p.Product_Sub_Category = "Tables" 								
group by region 														
order by profit_in_each_region desc;		

							

