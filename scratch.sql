select  max(density) as density, user_id, monthending
from    (
        Select  count(link_id) over (partition by user_id order by created_at asc rows unbounded preceding) as density, user_id, date_trunc('month', created_at) as monthending 
        From    (
                select min(created_at) as created_at, user_id, link_id 
                from user_registrations 
                group by link_id, user_id 
                Where link_type = 'ScheduledProgram'
                )
        )
group by user_id, monthending