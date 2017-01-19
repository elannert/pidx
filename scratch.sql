select max(cast(datediff(day, first_registration, created_at) as float)/365) as duration, user_id, monthending
from    (
        select user_id, created_at, date_trunc('month', created_at) as monthending, min(created_at) over (partition by user_id order by id  asc rows unbounded preceding) as first_registration
        from user_registrations
        )
group by user_id, monthending