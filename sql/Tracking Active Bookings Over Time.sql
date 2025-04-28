select booking_date,
       array_length((select array_agg(cbi.id) from course_bookings cbi
                 where cbi.booking_date <= cbo.booking_date
                  and cbi.course_start_date >= cbo.booking_date     
       ), 1) active_bookings 
from course_bookings cbo
group by 1 
order by 1
