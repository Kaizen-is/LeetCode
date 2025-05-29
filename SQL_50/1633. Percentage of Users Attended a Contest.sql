Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key (column with unique values) for this table.
Each row of this table contains the name and the id of a user.
 

Table: Register

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id of a user and the contest they registered into.
 

Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-----------+
| user_id | user_name |
+---------+-----------+
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |
+---------+-----------+
Register table:
+------------+---------+
| contest_id | user_id |
+------------+---------+
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |
+------------+---------+
Output: 
+------------+------------+
| contest_id | percentage |
+------------+------------+
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |
+------------+------------+
Explanation: 
All the users registered in contests 208, 209, and 210. The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%


Solution:
-- select r.contest_id, round(count(((r.contest_id)/count(u.user_id))*1.0) * 100, 2) as percentage
-- from Users u
-- join Register r on u.user_id = r.user_id
-- group by r.contest_id
-- order by r.contest_id;


-- with cte as ( select user_id, contest_id, count(contest_id) as contest from Register
--               group by user_id, contest_id)


-- select r.contest_id, round(count(r.user_id) * 100.0 / (select count(*) from Users), 2) as percentage
-- from Users u
-- join cte r on u.user_id = r.user_id
-- group by r.contest_id
-- order by percentage desc;            




select r.contest_id, round(count(r.user_id) * 100.0 / (select count(*) from Users), 2) as percentage
from Users u
join Register r on u.user_id = r.user_id
group by r.contest_id
order by percentage desc, r.contest_id  