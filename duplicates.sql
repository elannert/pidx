select  u.full_name as unclaimed_full_name, c.full_name as user_full_name, u.created_at  as unclaimed_created, c.created_at  as user_created, c.username, u.id, c.id as user_id, u.dob
from
        (
        select  full_name, uu.created_at, username, id, dob, split_part(full_name, ' ', 1) as first_name
        from    users uu
        where   state = 'unclaimed' and origin = 'import'
        ) u, 
        (
        select  full_name, cu.created_at, username, id, dob, split_part(full_name, ' ', 1) as first_name
        from    users cu
        ) c
where   u.dob = c.dob 
        and u.first_name = c.first_name
        and u.id != c.id        
        
        
select regexp_count(trim(full_name), ' ') + 1 as name_count, count(*), state
from users
where origin='import'
group by regexp_count(trim(full_name), ' '), state

