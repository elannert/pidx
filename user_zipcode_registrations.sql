select  c.name, sp.id, sp.zipcode, u.id as user_id, ur.created_at
from    categories c, category_links cl, scheduled_programs sp, users u, user_registrations ur
where   u.id = ur.user_id
        and u.id = ur.user_id 
        and ur.link_id = sp.id
        and ur.link_type = 'ScheduledProgram'
        and sp.id = cl.link_id
        and cl.category_id = c.id