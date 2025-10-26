select 
    s.skills as top_paying_skills,
    round(avg(j.salary_year_avg),0) as avg_salary 
from skills_job_dim sj
JOIN job_postings_fact j on j.job_id = sj.job_id
JOIN skills_dim s on sj.skill_id = s.skill_id
where j.salary_year_avg  is NOT NULL 
AND j.job_title_short = 'Data Analyst'
GROUP BY s.skills
ORDER BY avg_salary DESC
limit 25



select 
    row_number() OVER (ORDER BY round(avg(j.salary_year_avg),0) DESC) as row_number,
    d.skills,
    round(avg(j.salary_year_avg),0) as avg_salary
from 
    job_postings_fact j
join
      skills_job_dim s  on j.job_id = s.job_id 
join
    skills_dim d on s.skill_id = d.skill_id
where
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL
group by 
 d.skills 
order by 
   avg_salary desc
limit 25;    
