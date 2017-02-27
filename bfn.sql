select  users.id,
        users.full_name,
        users.email_address,
        users.guardian_name,
        users.guardian_email_address,
        bfn.gender,
        bfn.grade,
        bfn.school_name,
        users.dob,
        users.claim_code,
        users.external_id,
        users.external_sys_id,
        users.token_id,
        users.username,
        users.uuid,
        users.school_name as users_table_school_name,
        bfn.claim_code as moc_claim_code
from    users   
        inner join 
        (
                select  cps.gender, cps.grade, cps.school_name, moc.claim_code,  
                        case when cps.user_id is not null 
                        then cps.user_id 
                        when moc.moc_user_id is not null
                        then moc.moc_user_id
                        else ha.id 
                        end as bfn_user_id
                from
                        (
                        select  user_id, gender, grade, school_name 
                        from    chicago_user_infos
                        where   grade >= 5 and
                                grade <= 8
                                and (
                                    school_name ilike 'reavis%'
                                    or school_name ilike 'kozminski%'
                                    or school_name ilike 'wells, I%'
                                    or school_name ilike 'UNIV OF CHGO CHTR-WOODSON%'
                                    or school_name ilike 'burke%'
                                )
                        ) cps
                        full outer join
                        (
                        Select  user_id as moc_user_id, claim_code 
                        from    user_registrations 
                        Where   claim_code in
                                ('BWL49'
                                ,'BKSEE'
                                ,'BLM8G'
                                ,'BJFIN'
                                ,'BHYJT'
                                ,'BQHF2'
                                )
                        ) moc
                        on cps.user_id = moc.moc_user_id
                        full outer join
                        (
                        select  id
                        from    users
                        where   school_name ilike 'holy angels%'
                        ) ha
                        on cps.user_id = ha.id
                        
        ) bfn
        on bfn.bfn_user_id = users.id
        
        /*723317*/