-- Substitute with your SQL


select s.id student_id,
       s.name,
       science.score - math.score score_difference
       from students s
        join courses science 
          on s.id = science.student_id 
          and science.course_name = 'Science'
        join courses math 
          on s.id = math.student_id 
          and math.course_name = 'Math'
        where science.score - math.score > 0 
order by score_difference desc, student_id
