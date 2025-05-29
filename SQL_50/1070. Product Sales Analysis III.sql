Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key (combination of columns with unique values) of this table.
product_id is a foreign key (reference column) to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.

Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the product name of each product.

Write a solution to select the product id, year, quantity, and price for the first year of every product sold. If any product is bought multiple times in its first year, return all sales separately.

Return the resulting table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
Output: 
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+ 
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+






-- select s.product_id, min(s.year) as first_year, s.quantity, s.price
-- from Sales s
-- join Product p on s.product_id = p.product_id
-- group by s.product_id, s.quantity, s.price, s.year
-- having s.year = min(s.year)

-- with m as (
--     select distinct min(s.year) as min_year, s.product_id
--     from Sales s 
--     group by s.product_id
-- )

-- select s1.product_id, s1.min_year as first_year, s2.quantity, s2.price
-- from m s1
-- join Sales s2 on s1.product_id = s2.product_id
-- where s2.year = s1.min_year

----------------------------------------------

-- select s.product_id, 
--    row_number() over(partition by s.product_id order by s.year),
--    min(s.year) as first_year, s.quantity, s.price
-- from Sales s
-- join Product p on s.product_id = p.product_id
-- group by s.product_id, s.quantity, s.price, s.year


-- with min_s as (
--     select s.product_id, s.year as first_year, s.quantity, s.price, row_number() over(partition by s.product_id order by s.year) as row_num
--     from Sales s 
    
-- )
-- select m.product_id, m.first_year, m.quantity, m.price
-- from min_s m
-- where m.row_num = 1



-- select s.product_id, s.year as first_year, s.quantity, s.price
-- from Sales s
-- join Product p on s.product_id = p.product_id
-- where s.year = (
--     select distinct min(year), product_id from Sales group by product_id
-- )
-- group by s.product_id, s.quantity, s.price, s.year




with m as (
    select distinct min(s.year) as min_year, s.product_id
    from Sales s 
    group by s.product_id
)

select s1.product_id, s1.min_year as first_year, s2.quantity, s2.price
from m s1
join Sales s2 on s1.product_id = s2.product_id
where s2.year = s1.min_year