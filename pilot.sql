select  users.id,
        users.full_name,
        users.email_address,
        users.guardian_name,
        users.guardian_email_address,
        bfn.gender,
        bfn.grade,
        bfn.ethnicity,
        bfn.school_name,
        users.dob,
        users.claim_code,
        users.external_id,
        users.external_sys_id,
        users.token_id,
        users.username,
        users.uuid,
        users.school_name as users_table_school_name,
        bfn.pilot_claim_code as pilot_claim_code,
        bfn.pilot_flag as pilot_flag,
        bfn.pilot_roster_date
from    users   
        inner join 
        (
                select  cps.gender, cps.grade, cps.school_name, cps.ethnicity, pilot.pilot_claim_code, pilot.pilot_flag, pilot.pilot_roster_date,
                        case when cps.user_id is not null 
                        then cps.user_id 
                        when pilot.pilot_user_id is not null
                        then pilot.pilot_user_id
                        else ha.id 
                        end as bfn_user_id
                from
                        (
                        select  user_id, gender, grade, school_name, ethnicity 
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
                        Select  user_id as pilot_user_id, claim_code as pilot_claim_code, 1 as pilot_flag, created_at as pilot_roster_date 
                        from    user_registrations 
                        Where   claim_code in
                                ('P1ZW3'
                                ,'PSUBR'
                                ,'P0652'
                                ,'P17O9'
                                ,'PDDST'
                                ,'POGZX'
                                ,'P0EQ6'
                                ,'PA6X3'
                                )
                        ) pilot
                        on cps.user_id = pilot.pilot_user_id
                        full outer join
                        (
                        select  id
                        from    users
                        where   school_name ilike 'holy angels%'
                        ) ha
                        on cps.user_id = ha.id
                        
        ) bfn
        on bfn.bfn_user_id = users.id
        
where pilot_flag = 1