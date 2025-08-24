with meowth as (select distinct house_no, 
       street_name, 
       count(applicant_id) over(partition by house_no, street_name) as appl_cnt,
       array_agg(applicant_id::varchar) 
                over(partition by house_no, street_name order by applicant_id) as dup_app
       
from energy_rebate_applications), 
  ji as (
  select *,  
    array_to_string(dup_app, ', ') as app_str,
    array_length(dup_app, 1) len
    from meowth
    where appl_cnt > 1
  
  
  ), formatted as (
select row_number() over(partition by house_no, street_name order by len desc) as rn,
appl_cnt::varchar||' applications (applicant_ids: '||app_str||') already filed at '||house_no::varchar||' '||street_name audit_note   
from ji
    --where string_to_array(dup_app, ', ')
order by appl_cnt desc, 
         street_name,
         house_no
  
  )
  select audit_note from formatted
  where rn = 1 
;
