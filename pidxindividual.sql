Select 'user_registrations' as psrc, ur.state as paction, s.name as ptitle, link_type as ptype, user_id, cast(min(ur.created_at) as timestamp)  as created, concat('https://chicagocityoflearning.org/workshop-detail?id=', s.id) as drilldownurl, date_trunc('month', cast(min(ur.created_at) as timestamp))) as pmonth, user_id as pidxuid
From user_registrations ur, (select distinct id, name from scheduled_programs) s
Where ur.link_type = 'ScheduledProgram'
And ur.link_id = s.id
Group by ur.state, ur.link_id, ur.link_type, ur.user_id, s.name, s.id


Union


select 'user_logs' as psrc, action as paction, (case action when 'search' then search_query when 'search_top_picks' then search_query else artifact_title end) as ptitle, (case action when 'search' then 'Search' when 'search_top_picks' then 'Search' else artifact_type end) as ptype, user_id, cast(min(created_at) as timestamp) as created, null as drilldownurl, date_trunc('month', created_at) as pmonth, user_id as pidxuid  
From user_logs 
group by action, artifact_title, search_query, artifact_type, user_id


	Union


Select 'issued_badges' as psrc, 'badge earned' as paction, b.name as ptitle, c.name as ptype, ib.user_id as user_id, cast(ib.created as timestamp) as created, concat('https://chicagocityoflearning.org/badge-details?id=', ib.badge_id) as drilldownurl, date_trunc('month', cast(ib.created as timestamp)) as pmonth,  ib.user_id as pidxuid
From 
(select badge_id, user_id, min(awarded_at) as created from Issued_badges group by badge_id, user_id) ib, 
(select distinct id, name from badges where site_id = '2') b, 
(select min(category_id) as cat_id, link_id, link_type from category_links group by link_id, link_type) cl, 
(select distinct id, name from categories) c
Where ib.badge_id = b.id
And b.id = cl.link_id
And cl.link_type = 'Badge'
And cl.cat_id = c.id


Union


Select 'user_registrations' as psrc, ur.state as paction, p.name as ptitle, link_type as ptype, user_id, min(ur.created_at) as created, concat('https://chicagocityoflearning.org/view-challenge?id=', p.id) as drilldownurl, date_trunc('month', min(ur.created_at)) as pmonth,  user_id as pidxuid
From user_registrations ur, (select distinct id, name from pathways) p
Where ur.link_type = 'Pathway'
And ur.link_id = p.id
Group by ur.state, ur.link_id, ur.link_type, ur.user_id, p.name, p.id