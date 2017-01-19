select user_id, date_trunc('month', created_at) as monthending, min(created_at) over (partition by user_id order by id  asc rows unbounded preceding) as first_registration
from user_registrations
where user_id = '391516'