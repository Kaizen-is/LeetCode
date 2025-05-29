Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The result format is in the following example.

 

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33







-- with cte as (
--     select player_id, min(event_date) as event_date, 
--     dateadd(day, 1, event_date) as event_date2
--     from Activity 
--     group by player_id
-- )
-- select round((c.event_date2/count(c.player_id))*1.0, 2) as fraction
-- from cte c
-- join Activity a1 on c.player_id = a1.player_id
-- where datediff(day, a1.event_date, c.event_date2) = 1


-- with cte as (
--     select player_id, min(event_date) as event_date
--     from Activity 
-- )
-- select round((c.event_date2/count(c.player_id))*1.0, 2)
-- from cte c
-- join Activity a1 on c.player_id = a1.player_id
-- where datediff(a1.event_date, a1.event_date) = 1

-- with mi as (
--     select player_id, min(event_date) as star_event_date
--     from Activity 
--     group by player_id
-- )

-- with ma as (
--     select player_id, max(event_date) as end_event_date
--     from Activity 
--     group by player_id
-- )

-- with dif as (
--     select a3.player_id, datediff(day, m1.star_event_date, m2.end_event_date) as diff
--     from Activity a3
--     join ma m1 on a3.player_id = m1.player_id
--     join mi m2 on m1.player_id = m2.player_id
--     where diff = 1 
--     group by a3.player_id
-- )

-- select round(count(f.player_id*1.0)/count(m.player_id), 2) as fraction  
-- from dif f
-- join ma m


with mi as (
    select player_id, min(event_date) as start_event_date
    from activity 
    group by player_id
),
dif as (
    select a.player_id
    from activity a
    join mi m on a.player_id = m.player_id
    where datediff(day, m.start_event_date, a.event_date) = 1
)

select round(count(distinct d.player_id) * 1.0 / count(distinct m.player_id), 2) as fraction
from mi m
left join dif d on m.player_id = d.player_id;

