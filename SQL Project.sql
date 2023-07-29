DROP TABLE IF EXISTS OLYMPICS_HISTORY;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY
(
	id INT,
	name VARCHAR,
	sex VARCHAR,
	age VARCHAR,
	height VARCHAR,
	weight VARCHAR,
	team VARCHAR,
	noc VARCHAR,
	games VARCHAR,
	year INT,
	season VARCHAR,
	city VARCHAR,
	sport VARCHAR,
	event VARCHAR,
	medal VARCHAR
);

DROP TABLE IF EXISTS OLYMPICS_HISTORY_NOC_REGIONS;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY_NOC_REGIONS
(
	noc VARCHAR,
	region VARCHAR,
	notes VARCHAR
);

SELECT * FROM OLYMPICS_HISTORY;
SELECT * FROM OLYMPICS_HISTORY_NOC_REGIONS;

1] Which nation has participated in all of the olympic games
      with tot_games as
              (select count(distinct games) as total_games
              from olympics_history),
          countries as
              (select games, nr.region as country
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(1) as total_participated_games
              from countries
              group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;
	  
2] Fetch the total no of sports played in each olympic games.
      with t1 as
      	(select distinct games, sport
      	from olympics_history),
        t2 as
      	(select games, count(1) as no_of_sports
      	from t1
      	group by games)
      select * from t2
      order by no_of_sports desc;
	  
3] Top 5 athletes who have won the most gold medals.
    with t1 as
            (select name, team, count(1) as total_gold_medals
            from olympics_history
            where medal = 'Gold'
            group by name, team
            order by total_gold_medals desc),
        t2 as
            (select *, dense_rank() over (order by total_gold_medals desc) as rnk
            from t1)
    select name, team, total_gold_medals
    from t2
    where rnk <= 5;


4] Top 5 athletes who have won the most medals (gold/silver/bronze).
    with t1 as
            (select name, team, count(1) as total_medals
            from olympics_history
            where medal in ('Gold', 'Silver', 'Bronze')
            group by name, team
            order by total_medals desc),
        t2 as
            (select *, dense_rank() over (order by total_medals desc) as rnk
            from t1)
    select name, team, total_medals
    from t2
    where rnk <= 5;


5] In which Sport/event, India has won highest medals.
    with t1 as
        	(select sport, count(1) as total_medals
        	from olympics_history
        	where medal <> 'NA'
        	and team = 'India'
        	group by sport
        	order by total_medals desc),
        t2 as
        	(select *, rank() over(order by total_medals desc) as rnk
        	from t1)
    select sport, total_medals
    from t2
    where rnk = 1;
	

6] Break down all olympic games where india won medal for Hockey and how many medals in each olympic games
    select team, sport, games, count(1) as total_medals
    from olympics_history
    where medal <> 'NA'
    and team = 'India' and sport = 'Hockey'
    group by team, sport, games
    order by total_medals desc;
