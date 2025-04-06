--Exploratory Data Analysis

select * from layoffs_staging

select max(total_laid_off) as maxx from layoffs_staging
select max(percentage_laid_off) as maxx from layoffs_staging
select * from layoffs_staging where percentage_laid_off < 1 order by funds_raised_millions desc
select company, sum(total_laid_off) as summ from layoffs_staging group by company
order by 2 desc
select min(layoff_date), max(layoff_date) from layoffs_staging
select industry, sum(total_laid_off) from layoffs_staging
group by industry order by 2 desc
select country, sum(total_laid_off) from layoffs_staging
group by country order by 2 desc
select year (layoff_date), sum(total_laid_off) from layoffs_staging
group by year(layoff_date) order by 1 desc
select stage, sum(total_laid_off) from layoffs_staging
group by stage order by 1 desc
select company, avg(percentage_laid_off) as summ from layoffs_staging group by company
order by 2 desc


select month(layoff_date) as monthh, sum(total_laid_off)
from layoffs_staging
group by month(layoff_date)

SELECT 
    FORMAT(layoff_date, 'yyyy-MM') AS year_month,
    sum(total_laid_off) AS total_layoffs
FROM layoffs_staging
WHERE layoff_date IS NOT NULL
GROUP BY FORMAT(layoff_date, 'yyyy-MM')
ORDER BY year_month;

--error
with rolling_total as (
SELECT 
    FORMAT(layoff_date, 'yyyy-MM') AS year_month,
    sum(total_laid_off) AS total_layoffs
FROM layoffs_staging
WHERE layoff_date IS NOT NULL
GROUP BY FORMAT(layoff_date, 'yyyy-MM')
--ORDER BY 1 asc
)
select year_month, sum(total_layoffs) over(order by year_month) as rolling_total
from rolling_total ORDER BY 1 asc




select company, year(layoff_date),  sum(total_laid_off) as summ from layoffs_staging group by company, year(layoff_date)
order by company asc

select company, year(layoff_date),  sum(total_laid_off) as summ from layoffs_staging group by company, year(layoff_date)
order by 3 desc



with company_year as
(
select
company, year(layoff_date) as years,  sum(total_laid_off) as total_laid_off from layoffs_staging group by company, year(layoff_date)
)
select *, DENSE_RANK() over(partition by years order by total_laid_off desc)
from company_year where years is not null;


with company_year as
(
select
company, year(layoff_date) as years,  sum(total_laid_off) as total_laid_off from layoffs_staging group by company, year(layoff_date)
)
select *, DENSE_RANK() over(partition by years order by total_laid_off desc) as ranking
from company_year where years is not null order by ranking


with company_year as
(
select
company, year(layoff_date) as years,  sum(total_laid_off) as total_laid_off from layoffs_staging group by company, year(layoff_date)
),company_year_rank as
(
select *, DENSE_RANK() over(partition by years order by total_laid_off desc) as ranking
from company_year where years is not null 
)
select * from company_year_rank where ranking<=5
;