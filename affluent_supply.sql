select max(name), id
from orgs
where id not in
(
519,
390,
458,
191,
151,
531,
286,
385,
1,
338,
284,
457,
341

)
group by id
order by max(name) asc
