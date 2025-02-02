
select country, population_increase from 
(
select country, 
       concat(round((sum(population) filter(where year=2020) - 
        sum(population) filter(where year=2000))/1000000.0, 2), ' M')
       population_increase,
       round((sum(population) filter(where year=2020) - 
        sum(population) filter(where year=2000))/1000000.0, 2)
       population_increase_for_sort,
       dense_rank() over(order by round((sum(population) filter(where year=2020) - 
        sum(population) filter(where year=2000))/1000000.0, 2) desc) as drn
from world_population
group by country) x
where drn < 6
order by population_increase_for_sort desc
