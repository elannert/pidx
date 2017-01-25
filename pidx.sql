Select users.id as pidxuid, users.dob, h.depth, w.breadth, r.duration, d.density, (h.depth* w.breadth*r.duration) as pvolume, badges.badge_count,
(h.depth* w.breadth *r.duration * d.density) as pmass, ntile (100) over (order by h.depth* w.breadth *r.duration * d.density asc ) as ntile,
h.depthcategoryname
From (
Select 
min(claim_code) as claim_code, 
min(created_at) as created_at, 
min(dob) as dob, 
min(email_address) as email_address, 
min(external_sys_id) as external_sys_id, 
min(first_name) as first_name, 
min(full_name) as full_name, 
min(guardian_email_address) as guardian_email_address, 
min(guardian_name) as guardian_name, 
min(last_name) as last_name, 
min(origin) as origin, 
id, 
min(school_name) as school_name, 
min(zipcode) as zipcode, 
min(external_id) as external_id
From users
Where id != 410 
And id != 525240
And id != 536192
Group by id
) users
inner join  
(
Select max(categorybadgecount) as depth, user_id, depthcategoryname
From
(
Select c.name as depthcategoryname, count(c.name) as categorybadgecount, ib.user_id
From 
(select distinct badge_id, user_id from Issued_badges) ib, 
(select distinct id from badges where site_id = '2') b, 
(select distinct category_id, link_id, link_type from category_links) cl, 
(select distinct id, name from categories) c
Where ib.badge_id = b.id
And b.id = cl.link_id
And cl.link_type = 'Badge'
And cl.category_id = c.id
Group by c.name, ib.user_id
) bc
Group by bc.user_id
) 
h on users.id = h.user_id
inner join 
(
Select count(distinct c.name) as breadth, u.id as user_id
From users u, Issued_badges ib, badges b, category_links cl, categories c
Where u.id = ib.user_id 
And ib.badge_id = b.id
And b.id = cl.link_id
And cl.link_type = 'Badge'
And cl.category_id = c.id
And b.badge_type != 'meta'
Group by u.id
) w on users.id = w.user_id
inner join 
(select cast(datediff(day, min(created_at), max(created_at)) as float)/365 as duration,
user_id from user_registrations 
group by user_id having datediff(day, min(created_at), max(created_at))>2) 
r
on users.id = r.user_id
Inner join
(Select count(distinct link_id) as density, user_id
From user_registrations
Where link_type = 'ScheduledProgram'
Group by user_id)
d
on users.id = d.user_id
Inner join 
(
select datediff(day, min(created_at), max(created_at)) as logduration, count(id) as logcount,
user_id from user_logs group by user_id having datediff(day, min(created_at), max(created_at))>2
) logs on users.id = logs.user_id
inner join
(
select count(distinct badge_id) as badge_count, user_id 
from issued_badges
group by user_id
) badges on users.id = badges.user_id