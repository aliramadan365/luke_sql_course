select 
    s.skill_id,
    s.skills,
    round(avg(j.salary_year_avg),0) as avg_salary,
    count(j.job_id) as demand_count
from job_postings_fact j
join skills_job_dim sj on sj.job_id = j.job_id
JOIN skills_dim s on sj.skill_id = s.skill_id

WHERE
    j.job_work_from_home = True AND
    j.salary_year_avg IS NOT NULL AND
    j.job_title_short = 'Data Analyst'
GROUP BY
    s.skill_id    
HAVING
    count(j.job_id) > 10
ORDER BY
    demand_count DESC,    
    avg_salary DESC
    

limit 25
 



