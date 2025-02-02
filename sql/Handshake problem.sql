
--# write your SQL statement here: 
-- you are given a table 'participants' with column 'n' (number of handshakes).
-- return a table with this column and your result in a column named 'res'.


create or replace function min_people(n_handshakes int) returns int
as $$
  
    select case when n_handshakes = 0 
    then 0 else ceil( (sqrt(1 + 8 * n_handshakes) + 1) * 1.0/ (2) ) end
    $$ language sql;
    
    
select n, min_people(n) as res from participants
