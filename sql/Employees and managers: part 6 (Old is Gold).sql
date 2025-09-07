


with tgt as
(
select mng.id, mng.name, 
count(distinct e.id) as older_subordinate_count
from employees e
  join employees mng
  on e.manager_id = mng.id
  where extract(year from age(current_timestamp::date, e.birthdate))>=60
group by 1,2)
select id, name, older_subordinate_count from tgt
where older_subordinate_count = (select max(older_subordinate_count) from tgt)
order by 3 desc, 1 desc
