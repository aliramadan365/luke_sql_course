select 
    job_id,
    job_title,
    job_location,
    c.name as company_name,
    c.link,
    c.link_google,
    job_schedule_type,
    to_char (round(salary_year_avg,0),'9,999,999') as salary_year_avg,
    job_posted_date
from job_postings_fact j
left join company_dim c on j.company_id = c.company_id
where   job_title_short = 'Data Analyst' AND 
        salary_year_avg is not NULL AND
        job_location = 'Anywhere'
order by salary_year_avg desc
limit 10;


/* select 
    *
from job_postings_fact 
where   job_title_short = 'Data Analyst' AND 
        salary_year_avg is NULL AND(
        job_location like 'Cairo%' OR
        job_location like '%Egypt')
order by salary_year_avg desc





