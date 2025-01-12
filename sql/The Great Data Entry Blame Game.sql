
select distinct cert.entered_by specialist_id,
       count(*) over(partition by cert.entered_by)  error_count,
       round((count(*) over(partition by cert.entered_by) * 100.0/
       count(*) over()), 2)::varchar error_percentage
from employees emp join certifications cert
         on  emp.id =  cert.employee_id 
where 
  levenshtein(emp.name, cert.cert_name) between 1 and 3
order by error_count desc,
         specialist_id
