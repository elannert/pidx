select count(id) as student_count, zipcode
from chicago_user_infos
group by zipcode

select count(id) as program_count, zipcode
from scheduled_programs
group by zipcode


IF
[Median] < 37100 THEN "1) Bottom third"
ELSEIF
[Median] < 47700 THEN "2) Middle third"
ELSE "3) Highest third"
END
