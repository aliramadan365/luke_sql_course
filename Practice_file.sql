CREATE TABLE job_applied (
    job_id INT, 
    application_sent_date DATE, 
    custom_resume boolean, 
    resume_file_name varchar(225), 
    cover_letter_sent boolean, 
    cover_letter_file_name varchar(225), 
    status varchar(50)
);

SELECT * from job_applied
order by 
    job_id

insert into job_applied (
             job_id,
            application_sent_date,
            custom_resume,
            resume_file_name,
            cover_letter_file_name,
            status)
values      (1,
        '2024-02-01' ,
        true ,
        'resume_01.pdf' ,'cover_letter_01.pdf'
        ' submitted ') ,
        (2, 
        '2024-02-01',
        true,
        'resume_02.pdf',
        false,
        null

        );


delete from job_applied
where job_id in 
    (SELECT
        job_id from job_applied 
    GROUP BY 
        job_id
    having count(job_id) >1    
    )


    DELETE FROM job_applied
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM job_applied
    GROUP BY job_id
);


alter TABLE job_applied 
add contact varchar(50)

update job_applied
set cover_letter_file_name = case
    when cover_letter_file_name = 'true' then 'True'
    when cover_letter_file_name = 'false' then 'False'
    else cover_letter_file_name
End
 

SELECT * from job_applied

update job_applied
set contact = 'Ali Ramadan'
where job_id = 1

alter table job_applied
rename column contact to contact_name;

alter table job_applied
alter column contact_name type text

alter table job_applied
drop column contact_name;

drop table job_applied;
 
select link_google from company_dim

select
    job_title_short as title, job_location as location, job_posted_date as date 
from 
    job_postings_fact
where job_title_short = 'Data Analyst' AND (job_location like '%Egypt'  or job_location like 'Cairo%')
order by 
    date desc
--------------------------------------------------------------------------------------------------------------------------------

select 
     
     extract (Month from job_posted_date) as Month, 
      count(*) as num_of_job_postings
from job_postings_fact
group by 
    Month, job_title_short 
having 
    job_title_short = 'Data Analyst'    
order by 
    num_of_job_postings    desc




-- Create table for January jobs
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- Create table for February jobs
CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- Create table for March jobs
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

 select * from january_jobs
 limit 5

 select * from february_jobs
 limit 5

select * from march_jobs
 limit 5

select 
    distinct job_title_short,
    
    case    
        when job_location = 'Anywhere' then 'Remote'
        when job_location LIKE 'Cairo%' or job_location like'%Egypt' then 'Local'
        else 'Onsite'
        End as location_category,
     count(*) as job_count
from 
    job_postings_fact       
where 
    job_title_short like '%Analyst'     
group by 
  job_title_short, location_category


select  job_title_short, job_location 

from 
    job_postings_fact
where 
    (job_location LIKE 'Cairo%' or job_location like'%Egypt' 
    )AND job_title_short like '%Analyst' 


select          
    job_title_short, count(*) as num_of_jobs
from      
    job_postings_fact
where 
    job_location like  'Cairo%' or job_location like'%Egypt'
group by 
    job_title_short
order by 
    num_of_jobs desc;

-- a good way to join tables using subqueries
select 
    company_id, name
from 
    company_dim    
where company_id in (
    select 
    company_id
from 
    job_postings_fact
where 
    job_no_degree_mention = True
)
order by
    company_id;

-- here is the same solution using joins
select distinct
    company_dim.company_id, company_dim.name
from
    company_dim
join 
    job_postings_fact on company_dim.company_id = job_postings_fact.company_id
WHERE
    job_postings_fact.job_no_degree_mention = True
order by
    company_dim.company_id;    


    select skills, type from skills_dim
-- joins solution to find the top 5 skills per job postings
select 
    s.skill_id,
    d.skills,
    count(j.job_id) as num_of_job_postings
from 
    job_postings_fact j
join
      skills_job_dim s  on j.job_id = s.job_id 
join
    skills_dim d on s.skill_id = d.skill_id
where
    j.job_location = 'Anywhere'    
group by 
    s.skill_id, d.skills 
order by 
    num_of_job_postings desc
limit 5;    

-- CTE solution to find the top 5 skills per job postings
with remote_jobs as (
    select
        
        job_id
    from
        job_postings_fact
    WHERE       
        job_location = 'Anywhere'  AND job_title_short = 'Data Analyst'
      
)

select
    s.skill_id,
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
    s.skill_id, d.skills
order BY
    num_of_remote_jobs desc    
limit 5;




select * 
from job_postings_fact
limit 1000

select j.job_title_short, j.salary_year_avg, j.company_id, d.name
from job_postings_fact j
join
    company_dim d on d.company_id = j.company_id
where (job_location like 'Cairo%' or job_location like '%Egypt') and salary_year_avg is not null
order BY
    salary_year_avg desc;
-- CTE solution to find job_postings of >70k salary that were posted in the first quarter of the year

with first_quarter as (


select *    
from january_jobs

UNION

select *    
from february_jobs

UNION

select *    
from march_jobs

)

select *
from first_quarter
where salary_year_avg > 70000
order BY salary_year_avg desc;


-- subquery solution to find job_postings of >70k salary that were posted in the first quarter of the year

select
 job_title_short,
 job_location,
 job_via,
 salary_year_avg,
 extract(year from job_posted_date ) as Year,
 extract(Month from job_posted_date ) as Month
       
from (
    select *    
    from january_jobs

    UNION all   

    select *    
    from february_jobs

    UNION all 

    select *    
    from march_jobs

) as first_quarter

where salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
order BY salary_year_avg desc







