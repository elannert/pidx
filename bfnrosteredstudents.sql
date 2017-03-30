select  users.id as ccolid,
        users.full_name,
        users.email_address,
        users.guardian_name,
        users.guardian_email_address,
        bfn.gender,
        bfn.grade,
        bfn.ethnicity,
        bfn.school_name,
        bfn.roster_date,
        users.dob,
        users.external_id as remixid,
        users.external_sys_id as cpsid,
        users.username,
        users.school_name as users_table_school_name
from    users   
        inner join 
        (
                select  cps.gender, cps.grade, cps.school_name, cps.ethnicity, pilot.roster_date,
                        case when cps.user_id is not null 
                        then cps.user_id 
                        else pilot.pilot_user_id 
                        end as bfn_user_id
                from
                        (
                        select  user_id, gender, grade, school_name, ethnicity 
                        from    chicago_user_infos
                        ) cps
                        right join
                        (
                        Select  user_id as pilot_user_id, min(created_at) as roster_date
                        from    user_registrations 
                        Where   link_type = 'ScheduledProgram' and
                                link_id in
                                (
                               '42110',
                                '41951',
                                '41978',
                                '41980',
                                '41901',
                                '41902',
                                '41903',
                                '41904',
                                '42016',
                                '42017',
                                '41981',
                                '41982',
                                '41983',
                                '41984',
                                '41999',
                                '42107',
                                '42106',
                                '42109',
                                '42096'
                                )
                        Group by user_id
                        ) pilot
                        on cps.user_id = pilot.pilot_user_id
        ) bfn
        on bfn.bfn_user_id = users.id
order by bfn.roster_date asc