select  cps.external_sys_id, cps.gender, cps.grade, cps.school_name, users.full_name
from    chicago_user_infos cps, users
where   grade >= 5 and
        grade <= 8
        and (
            cps.school_name ilike 'reavis%'
            or cps.school_name ilike 'kozminski%'
            or cps.school_name ilike 'UNIV OF CHGO CHTR-WOODSON%'
            or cps.school_name ilike 'burke%'
        )
        and users.id = cps.user_id
order by cps.school_name, users.full_name asc