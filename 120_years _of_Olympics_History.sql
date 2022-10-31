-- It is the real data of 120 years of olympics hoistory downloaded from kaggle and wrote queries on PostgreSQL to get our desired output.

-- SQL query to fetch the list of all sports which have been part of every olympics. 

with t1 as
(select  count(DISTINCT games) as total_summer_games
from olympics_history
where season = 'Summer'),

t2 as
(select  distinct sport,games
from olympics_history
where season = 'Summer' order by games),

t3 as ( 
	select sport, count(games) as no_of_games
	from t2
	group by sport)

select * from t3
join t1
on t1.total_summer_games = t3.no_of_games

-- SQL query to fetch the top 5 athletes who have won the most gold medals.

with t1 as 
(select name, count(1) as total_gold_medals
from olympics_history
where medal = 'Gold'
group by name
order by count(1) desc),

t2 as (
select *, dense_rank() over (order by total_gold_medals desc) as rnk from t1)

select * from t2 where rnk <=5

-- Write a SQL query to list down the  total gold, silver and bronze medals won by each country.

select country, COALESCE (gold,0) as gold, COALESCE (silver,0) as silver, COALESCE (bronze,0) as bronze
from crosstab('select nr.region as country, medal, count(1) as total_medals
from olympics_history oh
join olympics_history_noc_regions nr
on oh.noc = nr.noc
where medal <> ''NA''
group by nr.region,medal
order by nr.region,medal','values (''Bronze''),(''Gold''), (''Silver'')')
as result(country varchar, bronze bigint, gold bigint, silver bigint)
order by gold desc, silver desc, bronze desc
