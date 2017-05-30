select *
from user_registrations
where claim_code = 'GROIX'
//returns the 34 students
//672006 113 406412
//726194  726214

GROIX
id 10
creator 264
org 519
site 2
6 activities

select us.*
from user_registrations ur, user_submissions us
where ur.claim_code = 'GROIX'
and ur.user_id = us.user_id
// contextid for cod60+

select uc.*
from user_registrations ur, user_challenges uc
where ur.claim_code = 'GROIX'
and ur.user_id = uc.user_id

select * 
from user_pathways
where pathway_id = '585aabf191069c695400012f'
//userid 192457


select * 
from user_submissions
where context_id = '585aabf191069c695400012f'
//userid 672006
//subcontext_id 585aabef91069c6997000115

select *
from user_challenges
where challenge_id = '585aabef91069c6997000115'
//userid 192457

select * from pathways where id = '585aabf191069c695400012f'

//where is the join between challenges and pathways?
//where is the join between playlist and pathway?
