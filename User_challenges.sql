select p.name, uc.user_id, pc.category_id
from user_challenges uc, pathways p, pathway_categories pc
where uc.state = 'completed'
and uc.pathway_id = p.id
and p.id = pc.pathway_id
190 or 186


select p.name, uc.user_id, c.name as category_name
from user_challenges uc, pathways p, pathway_categories pc, iremix_categories c
where uc.state = 'completed'
and uc.pathway_id = p.id
and p.id = pc.pathway_id
and pc.category_id = c.id