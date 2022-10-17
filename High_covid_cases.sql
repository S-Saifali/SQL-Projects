with xxx as 
(
	select *
	,rank() over(PARTITION by city order by days) as rn_days
	, rank() over(PARTITION by city order by cases asc) as rn_cases
	,rank() over(PARTITION by city order by days) - rank() over(PARTITION by city order by cases asc) as diff
from covid)

select city 
from xxx
group by city 
having count(distinct city) = 1 and max (diff) = 0
