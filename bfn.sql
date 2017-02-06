select  users.id,
        full_name,
        email_address,
        guardian_name,
        guardian_email_address,
        cps.gender,
        cps.grade,
        cps.school_name
from    users, chicago_user_infos cps
where   users.id = cps.user_id and
        cps.grade >= 5 and
        cps.grade <= 8
        and (
            cps.school_name ilike 'reavis%'
            or cps.school_name ilike 'holy angels%'
            or cps.school_name ilike 'kozminski%'
            or cps.school_name ilike 'wells, I%'
            or cps.school_name ilike 'UNIV OF CHGO CHTR-WOODSON%'
            or cps.school_name ilike 'burke%'
        )