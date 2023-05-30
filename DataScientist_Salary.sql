select * from ds_salaries;

-- 1. Apakah ada data yang Null?
select * from ds_salaries
	where work_year is null
	or experience_level is null
    or employment_type is null
    or job_title is null
    or salary is null
    or salary_currency is null
    or salary_in_usd is null
    or employee_residence is null
    or remote_ratio is null
    or company_location is null
    or company_size is null;
    
-- 2. List job title
select distinct job_title
	from ds_salaries
    order by job_title;
    
-- 3. Melihat job title yang berkaitan dengan Data Analyst
select distinct job_title from ds_salaries
	where job_title like '%Data Analyst%'
    order by job_title;

-- 4. Berapa rata-rata gaji data analyst?
select (avg(salary_in_usd) * 15000)/12 as avg_sal_rp_monthly
    from ds_salaries;
-- 4.1 Rata-rata gaji data analyst berdasarkan experience
select experience_level, 
	(avg(salary_in_usd) * 15000)/12 as avg_sal_rp_monthly
    from ds_salaries
    group by experience_level;
-- 4.2 Rata-rata gaji data analyst berdasarkan experience dan jenis employment
select experience_level, employment_type,
	(avg(salary_in_usd) * 15000)/12 as avg_sal_rp_monthly
    from ds_salaries
    group by experience_level, employment_type
    order by experience_level, employment_type;
    
-- 5. Negara dengan gaji data analyst tertinggi untuk kategori full time dengan pengalaman pemula sampai menengah?
select company_location,
		avg(salary_in_usd) as avg_sal_in_usd
	from ds_salaries
	where job_title like '%Data Analyst%'
		and employment_type = 'FT'
        and experience_level in ('EN', 'MI')
	group by company_location;
-- 5.1 Standar gaji dengan nominal => 20000 usd
select company_location,
		avg(salary_in_usd) as avg_sal_in_usd
	from ds_salaries
	where job_title like '%Data Analyst%'
		and employment_type = 'FT'
        and experience_level in ('EN', 'MI')
	group by company_location
    having avg_sal_in_usd >= 20000;
    
-- 6. Fluktuasi gaji data analyst tiap tahunnya untuk full time bagi tipe MI dan EX
with ds_1 as (
	select work_year, 
		avg(salary_in_usd) sal_in_usd_EX
	from ds_salaries
	where
		employment_type = 'FT'
		and experience_level = 'EX'
		and job_title like '%Data Analyst%'
	group by work_year
), ds_2 as (
	select work_year, 
		avg(salary_in_usd) sal_in_usd_MI
	from ds_salaries
	where
		employment_type = 'FT'
		and experience_level = 'MI'
		and job_title like '%Data Analyst%'
	group by work_year
), t_year as (
	select distinct work_year
    from ds_salaries
) select t_year.work_year,
	ds_1.sal_in_usd_EX,
    ds_2.sal_in_usd_MI,
    ds_1.sal_in_usd_EX - ds_2.sal_in_usd_MI differences
from t_year
left join ds_1 on ds_1.work_year = t_year.work_year
left join ds_2 on ds_2.work_year = t_year.work_year;