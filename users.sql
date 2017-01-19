select  *     
From    (
        Select  min(claim_code) as claim_code, 
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
                id as pidxuid, 
                min(school_name) as school_name, 
                min(zipcode) as zipcode, 
                min(external_id) as external_id
        From    users
        Where   id != 410 
        And     id != 525240
        And     id != 536192
        Group by id
        ) u
        
        left outer join 
        
        (
        Select  case when count(id)>0 then 1 else 0 end as fusion, user_id as pidxuid 
        from    user_registrations 
        Where   claim_code in
                ('BWL49'
                ,'BKSEE'
                ,'BLM8G'
                ,'BJFIN'
                ,'BHYJT'
                ,'BQHF2'
                )
        Group by user_id
        ) fusion
        on u.pidxuid = fusion.pidxuid
        
        left outer join 
        
        (
        select  distinct user_id as pidxuid, 1 as asmflag 
        from    user_registrations 
        where   org_id = 18
        ) asm
        on u.pidxuid = asm.user_id
        
        left outer join 
        
        (
        Select  case when count(id)>0 then 1 else 0 end as divas, user_id as pidxuid 
        from    user_registrations 
        Where   claim_code in
                ('PV4N4'
                ,'PTVXT'
                ,'P8IJH'
                )
        Group by user_id
        ) divas
        on u.pidxuid = divas.pidxuid
