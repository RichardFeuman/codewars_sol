-- Substitute with your SQL

--10 -12
--01-03
--04-06
with terms as (
select 
       student_id, 
       name,
       course_name, 
       score, 
       course_date, 
       case when extract(month from course_date) between 10 and 12 then 'Michaelmas'
            when extract(month from course_date) between 1 and 3 then 'Lent'
            when extract(month from course_date) between 4 and 6 then 'Summer'
            end term
       
from courses c join students s 
on s.id = c.student_id
), avg_scores as (
  
  select  
       student_id, 
       name,
       course_name, 
       score, 
       course_date, 
       term,
       avg(score) over(partition by student_id, term) as avg_score
from terms
), by_termes_scores as (
  select        
       name,
       student_id, 
       'Michaelmas ('||
        round(max(avg_score) 
              filter(where term = 'Michaelmas'), 2)||')' as Michaelmas_avg_score,
       'Lent ('||round(max(avg_score) 
                       filter(where term = 'Lent'),2)||')' as Lent_avg_score,
       'Summer ('||round(max(avg_score) 
                       filter(where term = 'Summer'),2)||')' as Summer_avg_score,
       case when round(max(avg_score) 
              filter(where term = 'Michaelmas'), 2) < 
            round(max(avg_score) 
                       filter(where term = 'Lent'),2)
            and round(max(avg_score) 
                       filter(where term = 'Lent'),2) <
            round(max(avg_score) 
                       filter(where term = 'Summer'),2) then 1 else 0 end as flag
  from avg_scores
  group by 1, 2

)
select student_id,
       name,
       array_to_string(array_agg(Michaelmas_avg_score||', '|| 
                  Lent_avg_score||', '||
                  Summer_avg_score), ',') as trimesters_avg_scores,
      
      sum(flag) = 1 as consistent_improvement 
from by_termes_scores
group by 1, 2
order by 1 desc


/*, islands as (
  
  select 
       student_id, 
       name,
       course_name, 
       score, 
       course_date, 
       term,
       avg_score,
       prev_avg_score,
       sum(case when avg_score > prev_avg_score then 1 else 0 end) 
  over(partition by student_id order by course_date) as grp
  from prev_scores

)
select distinct 
       student_id, 
       name,
       string_agg(avg_score::varchar, ',') 
       over(partition by student_id order by course_date) trimesters_avg_scores,
       --prev_avg_score,
       grp = 3 as consistent_improvement
from islands
--group by student_id, name, grp
order by student_id
--order by student_id, prev_avg_score, avg_score*/
