-- Select pmonth, user_id, 
-- 		case when breadth is Null then 
-- 				lag(breadth) ignore nulls 
-- 				over (partition by users_dates.user_id order by pmonth asc) 
-- 		else breadth 
-- 		end as breadth,
-- 		case when depth is Null then 
-- 				lag(depth) ignore nulls 
-- 				over (partition by users_dates.user_id order by pmonth asc) 
-- 		else depth 
-- 		end as depth

Select	users_dates.pmonth, users_dates.user_id, breadth, depth, duration 
from	(
		Select	dates.pmonth, u.user_id 
		From	(
				Select	1 as explodekey, pmonth 
				from	(
						select dateadd('month', -1, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -2, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -3, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -4, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -5, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -6, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -7, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -8, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -9, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -10, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -11, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -12, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -13, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -14, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -15, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -16, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -17, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -18, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -19, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -20, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -21, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -22, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -23, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -24, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -25, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -26, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -27, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -28, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -29, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -30, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -31, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -32, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -33, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -34, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -35, date_trunc('month', current_date)) as pmonth union
						select dateadd('month', -36, date_trunc('month', current_date)) as pmonth 
						)
				) dates 
				Full outer join 
				(
				select	min(created_at) as created_at, 
						min(1) as explodekey, 
						min(users.id) as user_id 
				from	users 
				where	last_sign_in_at is not null 
				and 	email_address is not null
				group by email_address
				) u
				On dates.explodekey = u.explodekey 
				where u.created_at <= dates.pmonth
		) users_dates
			
		Left outer join
		(
			Select	user_id, monthending, 
					sum(categoryusedbit) as breadth
			From	(
					Select	breadthcategoryname, user_id, monthending, 
							max(badge_category_flag) 
							over (partition by user_id, breadthcategoryname order by monthending asc rows unbounded preceding) as categoryusedbit
					From	(
							Select	matrix.category_name as breadthcategoryname, ib.user_id, monthending, 
									max(matrix.badge_category_flag) as badge_category_flag
							from	(
									select	badge_id, user_id, 
											min(date_trunc('month', awarded_at)) as monthending 
									from	Issued_badges 
									group by badge_id, user_id
									) ib, 
									(
									Select	badge_categories.*, 
											case 
											when cl.category_links_catid is null then 0 
											else 1 
											end as badge_category_flag
									From	(
											Select	b.badge_id, c.category_name, c.category_id
											From 
													(
													select	distinct 1 as explodekey, badges.id as badge_id 
													from	badges 
													where	badges.site_id = '2'  
													and 	badges.badge_type != 'meta'
													) b 
													full outer join 
													(
													select	distinct categories.id as category_id, categories.name as category_name, 1 as explodekey 
													from	categories 
													where	categories.site_id = 2
													) c 
													on b.explodekey = c.explodekey
											) badge_categories
											left outer join
											(
											select	distinct link_id, category_links.category_id as category_links_catid 
											from	category_links 
											where	link_type = 'Badge'
											) cl
											on badge_categories.badge_id = cl.link_id 
											and badge_categories.category_id = cl.category_links_catid
											order by badge_categories.badge_id
									) matrix
							Where	ib.badge_id = matrix.badge_id
							Group by monthending, ib.user_id, matrix.category_name
							)
					)
			Group by monthending, user_id
		
		) breadthsql

		On users_dates.pmonth = breadthsql.monthending 
		and users_dates.user_id = breadthsql.user_id

		Left outer join

		(
		Select	max(categorybadgecount) as depth, 
				monthending, user_id
		from	(
				Select	depthcategoryname, user_id, monthending, 
						sum(thismonth) 
						over (partition by depthcategoryname, user_id order by monthending asc rows unbounded preceding) as categorybadgecount
				from	(
						Select matrix.category_name as depthcategoryname, ib.user_id as user_id, monthending, sum(matrix.badge_category_flag) as thismonth
						from	(
								select	badge_id, user_id, 
										min(date_trunc('month', awarded_at)) as monthending 
								from Issued_badges 
								group by badge_id, user_id
								) ib, 
								(
								Select	badge_categories.*, 
										case when cl.category_links_catid is null then 0 
										else 1 
										end as badge_category_flag
								From	(
										Select	b.badge_id, c.category_name, c.category_id
										From	(
												select	distinct 1 as explodekey, badges.id as badge_id 
												from badges 
												where badges.site_id = '2'  
												and badges.badge_type != 'meta'
												) b 
												full outer join 
												(
												select distinct categories.id as category_id, categories.name as category_name, 1 as explodekey 
												from categories 
												where categories.site_id = 2
												) c 
												on b.explodekey = c.explodekey
										) badge_categories
										left outer join
										(
										select distinct link_id, category_links.category_id as category_links_catid 
										from category_links 
										where link_type = 'Badge'
										) cl
										on badge_categories.badge_id = cl.link_id 
										and badge_categories.category_id = cl.category_links_catid
										order by badge_categories.badge_id
								) matrix
						Where ib.badge_id = matrix.badge_id
						Group by matrix.category_name, ib.user_id, monthending
						)
				)
		Group by user_id, monthending
		) depthsql
		On users_dates.pmonth = depthsql.monthending 
		and users_dates.user_id = depthsql.user_id
		
		left outer join 
		(
        select max(cast(datediff(day, first_registration, created_at) as float)/365) as duration, user_id, monthending
        from    (
                select user_id, created_at, date_trunc('month', created_at) as monthending, min(created_at) over (partition by user_id order by id  asc rows unbounded preceding) as first_registration
                from user_registrations
                )
        group by user_id, monthending
        ) durationsql
		on users_dates.pmonth = durationsql.monthending
		and users_dates.user_id = durationsql.user_id

        left outer join
        (
        select  max(density) as density, user_id, monthending
        from    (
                Select  count(link_id) over (partition by user_id order by created_at asc rows unbounded preceding) as density, user_id, date_trunc('month', created_at) as monthending 
                From    (
                        select min(created_at) as created_at, user_id, link_id 
                        from user_registrations 
                        group by link_id, user_id 
                        Where link_type = 'ScheduledProgram'
                        )
                )
        group by user_id, monthending        
        ) densitysql
        on users_dates.pmonth = densitysql.monthending
		and users_dates.user_id = densitysql.user_id
