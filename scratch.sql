Select categorybadgecount as depth, user_id, depthcategoryname
From
(
Select top 1 c.name as depthcategoryname, count(c.name) as categorybadgecount, ib.user_id
From 
(select distinct badge_id, user_id from Issued_badges) ib, 
(select distinct id from badges where site_id = '2') b, 
(select distinct category_id, link_id, link_type from category_links) cl, 
(select distinct id, name from categories) c
Where ib.badge_id = b.id
And b.id = cl.link_id
And cl.link_type = 'Badge'
And cl.category_id = c.id
and ib.user_id = '415417'
Group by c.name, ib.user_id
order by count(c.name) asc
) bc
Group by bc.user_id

