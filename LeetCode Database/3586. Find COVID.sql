Table: patients

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| patient_id  | int     |
| patient_name| varchar |
| age         | int     |
+-------------+---------+
patient_id is the unique identifier for this table.
Each row contains information about a patient.
Table: covid_tests

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| test_id     | int     |
| patient_id  | int     |
| test_date   | date    |
| result      | varchar |
+-------------+---------+
test_id is the unique identifier for this table.
Each row represents a COVID test result. The result can be Positive, Negative, or Inconclusive.
Write a solution to find patients who have recovered from COVID - patients who tested positive but later tested negative.

A patient is considered recovered if they have at least one Positive test followed by at least one Negative test on a later date
Calculate the recovery time in days as the difference between the first positive test and the first negative test after that positive test
Only include patients who have both positive and negative test results
Return the result table ordered by recovery_time in ascending order, then by patient_name in ascending order.

The result format is in the following example.

 

Example:

Input:

patients table:

+------------+--------------+-----+
| patient_id | patient_name | age |
+------------+--------------+-----+
| 1          | Alice Smith  | 28  |
| 2          | Bob Johnson  | 35  |
| 3          | Carol Davis  | 42  |
| 4          | David Wilson | 31  |
| 5          | Emma Brown   | 29  |
+------------+--------------+-----+
covid_tests table:

+---------+------------+------------+--------------+
| test_id | patient_id | test_date  | result       |
+---------+------------+------------+--------------+
| 1       | 1          | 2023-01-15 | Positive     |
| 2       | 1          | 2023-01-25 | Negative     |
| 3       | 2          | 2023-02-01 | Positive     |
| 4       | 2          | 2023-02-05 | Inconclusive |
| 5       | 2          | 2023-02-12 | Negative     |
| 6       | 3          | 2023-01-20 | Negative     |
| 7       | 3          | 2023-02-10 | Positive     |
| 8       | 3          | 2023-02-20 | Negative     |
| 9       | 4          | 2023-01-10 | Positive     |
| 10      | 4          | 2023-01-18 | Positive     |
| 11      | 5          | 2023-02-15 | Negative     |
| 12      | 5          | 2023-02-20 | Negative     |
+---------+------------+------------+--------------+
Output:

+------------+--------------+-----+---------------+
| patient_id | patient_name | age | recovery_time |
+------------+--------------+-----+---------------+
| 1          | Alice Smith  | 28  | 10            |
| 3          | Carol Davis  | 42  | 10            |
| 2          | Bob Johnson  | 35  | 11            |
+------------+--------------+-----+---------------+







-- with pos as (
--     select p.patient_id, p.patient_name, p.age, s.test_date, 
--     row_number() over(partition by p.patient_id order by s.test_date desc) as rowneg
--     from patients p
--     join covid_tests s on p.patient_id = s.patient_id 
--     where s.result = 'Positive'
-- ), neg as (
--     select p.patient_id, p.patient_name, p.age, test_date,
--     row_number() over(partition by p.patient_id order by s.test_date) as rowneg
--     from patients p
--     join covid_tests s on p.patient_id = s.patient_id 
--     where s.result = 'Negative'
-- )

-- select p.patient_id, p.patient_name, p.age, datediff(day, p.test_date, n.test_date) as recovery_time
-- from pos p
-- join neg n on p.patient_id = n.patient_id
-- where n.rowneg = 1 and p.rowneg = 1
-- order by datediff(day, p.test_date, n.test_date), p.patient_name



-- select p.patient_id, p.patient_name, p.age,     
--     case 
--         when 
-- from patients p
-- join covid_tests t on p.patient_id = t.patients_id


-- Write your PostgreSQL query statement below


-- with pos as (
--     select p.patient_id, p.patient_name, p.age, min(s.test_date) as test_date 
--     from patients p
--     inner join covid_tests s on p.patient_id = s.patient_id 
--     where s.result = 'Positive'
--     group by p.patient_id, p.patient_name, p.age
-- ), neg as (
--     select p.patient_id, p.patient_name, p.age, max(s.test_date) as test_date
--     from patients p
--     inner join covid_tests s on p.patient_id = s.patient_id 
--     where s.result = 'Negative'
--     group by p.patient_id, p.patient_name, p.age
-- )

-- select p.patient_id, p.patient_name, p.age, datediff(day, p.test_date, n.test_date) as recovery_time
-- from pos p
-- join neg n on p.patient_id = n.patient_id

-- order by datediff(day, p.test_date, n.test_date), p.patient_name



with first_positive as (
    select 
        s.patient_id, 
        min(s.test_date) as positive_date
    from covid_tests s
    where s.result = 'positive'
    group by s.patient_id
),
first_negative_after_positive as (
    select 
        s.patient_id, 
        min(s.test_date) as negative_date
    from covid_tests s
    join first_positive fp on s.patient_id = fp.patient_id
    where s.result = 'negative' and s.test_date > fp.positive_date
    group by s.patient_id
)

select 
    p.patient_id, 
    p.patient_name, 
    p.age, 
    datediff(day, fp.positive_date, fnap.negative_date) as recovery_time
from first_positive fp
join first_negative_after_positive fnap on fp.patient_id = fnap.patient_id
join patients p on p.patient_id = fp.patient_id
order by recovery_time, p.patient_name;