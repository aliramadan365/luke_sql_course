# 📊 Data Analytics Job Postings (2023)

This project explores and analyzes job postings for **Data Analytics roles in 2023** to uncover trends in **skills demand, salaries, and job availability** across different regions and companies.
Check out the SQL queries here: [final_project folder](/final_project/)

---

## 🧠 Objective
The goal of this project is to identify:
- The most in-demand skills for data analysts  
- The top-paying roles and companies 
- The relationship between skills and salary levels  
- The optimal skills to learn
---

## 🛠 Tools & Technologies
- **SQL** – for data cleaning, transformation, and analysis  
- **PostgreSQL / SQLite** – to build and manage the database   
- **Visual Studio Code** - as the development environment 
- **Git & GitHub** - for version control and sharing my SQL scripts and analysis, ensuring collaborationa and project tracking

---

## 📁 Dataset
The dataset contains job postings for data-related roles in 2023.  
It includes details such as:
- Job title  
- Company name  
- Location  
- Required skills  
- Salary information  

> [Link to dataset](https://huggingface.co/datasets/lukebarousse/data_jobs/blob/main/data_jobs.csv)


---

# 📑 The Analysis

## 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles. I filtered data analyst job postings by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
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
```


- **Top-paying role:** *Data Analyst* at **Mantys**, offering an impressive **$650,000 per year** — significantly higher than others.  

- **High-ranking companies:** **Meta**, **AT&T**, and **SmartAsset** also appear with strong salaries ranging between **$180K–$330K**.  

- **All jobs** are listed as *Anywhere*, meaning they support remote or flexible work.  

- **Salary range:** from **$184K** up to **$650K**, with a clear drop after the top entry.



![Top Paying Roles](assets\Top_Paying_Roles.png)
*this bar chart visualizes the salary for the top 10 roles for data analysts, showing how Mantys stands far above the rest.*


## 2. Skill for Top Paying Jobs
To identify skills that are essential to get a highly paying role, I joined the job postings table with the skills table to find which skills appeared most frequently in the top 10 highest-paying roles.

```sql
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
```
Analyzing the top 10 highest-paying data analytics roles showed a clear trend in the skills employers value most. **SQL** led as the most frequently mentioned skill, followed closely by **Python** and **Tableau**. This highlights the importance of combining strong data manipulation, programming, and visualization skills to excel in high-paying analytics positions.

![Skills for top paying jobs](assets\Skill_for_top_paying_jobs.png)


## 3. Top In-demand Skills
Analyzed job postings to identify the most sought-after skills for data analyst roles, helping aspiring analysts understand which tools and technologies to prioritize.

```sql
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
```
| Rank | Skill     | Demand Count |
|------|------------|---------------|
| 1    | SQL        | 92,628        |
| 2    | Excel      | 67,031        |
| 3    | Python     | 57,326        |
| 4    | Tableau    | 46,554        |
| 5    | Power BI   | 39,468        |



```sql
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
``` 

| Rank | Skill     | Number of Remote Jobs |
|------|------------|-----------------------|
| 1    | SQL        | 7,291                 |
| 2    | Excel      | 4,611                 |
| 3    | Python     | 4,330                 |
| 4    | Tableau    | 3,745                 |
| 5    | Power BI   | 2,609                 |


The analysis shows a consistent pattern across remote roles and overall job postings: **SQL, Excel, Python, Tableau, and Power BI** are the top in-demand skills for data analysts.

- In **remote data analyst roles**, SQL leads by a wide margin with 7,291 mentions, followed by Excel and Python.  
- When looking at **all job postings**, the same skills dominate at a much larger scale, with SQL appearing over 92,000 times, far surpassing every other tool.  

Overall, the findings highlight that **SQL is the most essential skill**, with Excel and Python close behind, while Tableau and Power BI remain highly valuable for data visualization and business intelligence. This makes them the core skill set aspiring data analysts should focus on.

## 4. Top Paying Skills
I joined the skills table with the job postings table to identify which skills are associated with the highest average salaries. These high-paying skills are considered elite and are often required for senior or specialized data analytics roles.

```sql
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
```

This analysis highlights the top-paying technical skills in the job market. The results show that **SVN** leads by a wide margin with an average salary of **$400,000**, likely due to its niche use in specialized roles. Other highly paid skills include **Solidity**, **Couchbase**, **DataRobot**, and **Golang**, each exceeding **$150,000** on average.

Overall, the data reveals strong salary potential for professionals skilled in **AI/ML frameworks** (like *PyTorch*, *TensorFlow*, and *Keras*), **DevOps tools** (such as *Terraform*, *Ansible*, and *Puppet*), and **data infrastructure technologies** (like *Kafka*, *Airflow*, and *Cassandra*).  

These findings suggest that advanced, domain-specific skills are particularly valuable for senior and specialized positions.

![Top Paying Skills](assets\Top_Paying_Skills.png)



## 🧩 What I Learned

Through this project, I strengthened my SQL expertise — advancing from basic queries to complex operations involving subqueries, CTEs, and advanced joins. I became more confident handling large datasets and transforming raw information into actionable insights. This experience also deepened my analytical mindset, teaching me how to frame the right questions and approach problems strategically to uncover meaningful patterns in data.

# Conclusions

## 🔍 Key Insights

1. **Core Skills:** Across over **90,000 job postings**, **SQL**, **Python**, and **Excel** emerged as the most in-demand skills, while **Tableau** and **Power BI** stood out as the leading tools for data visualization and reporting.  

2. **Top-Paying Role:** The highest-paying *Data Analyst* job was offered by **Mantys** at a remarkable **$650,000 per year**, far surpassing other high offers around **$180K–$330K**.  

3. **High-Value Skills:** Specialized tools like **SVN ($400K)**, **Solidity**, and AI/ML frameworks such as **PyTorch** and **TensorFlow** command top salaries, reflecting their niche expertise value.  

4. **Job Title Diversity:** The data showed a wide variety of analyst-related roles — from *Data Analyst* and *Business Analyst* to *Data Engineer* and *Data Scientist* — emphasizing the expanding scope and specialization within the analytics field.  


## 📬 Contact
**Ali Ramadan**  
🔗 [LinkedIn](https://www.linkedin.com/in/ali-ramadan-8599b4337/) <br>
 [<img src="https://cdn-icons-png.flaticon.com/16/732/732200.png" />]()
[Gmail](mailto:aliramadan7073@gmail.com)

