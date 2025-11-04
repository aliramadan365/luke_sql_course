-- joins solution to find the top in-demand 5 skills in data analysis jobs (remote and on-site)
select 
    row_number() OVER (ORDER BY(count(j.job_id)) DESC) as row_number,
    d.skills,
    count(j.job_id) as demand_count
from 
    job_postings_fact j
join
      skills_job_dim s  on j.job_id = s.job_id 
join
    skills_dim d on s.skill_id = d.skill_id
where
    job_title_short = 'Data Analyst'
group by 
 d.skills 
order by 
    demand_count desc
limit 5;    

-- CTE solution to find the top in-demand 5 skills in remote data analysis jobs
with remote_jobs as (
    select    
    job_id
    from
    job_postings_fact
    WHERE       
    job_location = 'Anywhere'  AND job_title_short = 'Data Analyst'
      
)

select
    row_number() OVER (ORDER BY(count(r.job_id)) DESC) as row_number,
    d.skills,
    count(*) as num_of_remote_jobs
from
    remote_jobs r
join
    skills_job_dim s
    on s.job_id = r.job_id
join    
    skills_dim d on d.skill_id = s.skill_id    
group BY
d.skills
order BY
    num_of_remote_jobs desc    
limit 5;