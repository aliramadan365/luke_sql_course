
with top_paying_jobs AS (
        select 
        job_id,
        job_title,
        c.name as company_name,
        to_char (round(salary_year_avg,0),'9,999,999') as salary_year_avg
    from job_postings_fact j
    left join company_dim c on j.company_id = c.company_id
    where   job_title_short = 'Data Analyst' AND 
            salary_year_avg is not NULL AND
            job_location = 'Anywhere'
    order by salary_year_avg desc
    limit 10
)

select
t.*,
s.skills
from top_paying_jobs t
inner join skills_job_dim sj on t.job_id = sj.job_id
inner join skills_dim s on sj.skill_id = s.skill_id 
order by salary_year_avg desc

