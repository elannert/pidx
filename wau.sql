select date_trunc('week', created_at), count(distinct name)
from actions
where site_id = '214'
group by date_trunc('week', created_at)