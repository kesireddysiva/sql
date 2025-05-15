with cte as (SELECT team_1 as team , case when team_1=Winner then 1 else 0 end as win_flag
FROM icc_world_cup
union all
SELECT team_2 as team, case when team_2=Winner then 1 else 0 end as win_flag
FROM icc_world_cup)

select team,count(1) as Matchs_palyed,sum(win_flag) as Win, count(1)- sum(win_flag)  as Lost from cte
group by team
order by Win desc


