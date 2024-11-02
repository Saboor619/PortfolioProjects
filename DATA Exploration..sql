SELECT max(total_laid_off)
From layoffs_staging2;

SELECT * 
FROM layoffs_staging2
Where percentage_laid_off = 1
Order By total_laid_off DESC;

SELECT * 
FROM layoffs_staging2
Where percentage_laid_off = 1
Order By funds_raised_millions DESC;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
group by company
order by 2 desc;

SELECT country, sum(total_laid_off)
FROM layoffs_staging2
group by country
Order by 2 DESC;

SELECT YEAR (`date`), sum(total_laid_off)
FROm layoffs_staging2
Group by YEAR (`date`)
ORder by 1 DESC;

SELECT stage, sum(total_laid_off)
FROm layoffs_staging2
Group by stage
ORder by 2 DESC;

SELECT substring(`Date` ,1,7) AS `MONTH`, sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(`Date` ,1,7) is NOT NULL
Group BY `MONTH`
Order by 1 ASC;

WITH Rolling_Total AS 
(SELECT substring(`Date` ,1,7) AS `MONTH`, sum(total_laid_off) AS total_off 
FROM layoffs_staging2
WHERE substring(`Date` ,1,7) is NOT NULL
Group BY `MONTH`
Order by 1 ASC)
SELECT `MONTH`, total_off, sum(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR (`date`), sum(total_laid_off)
FROm layoffs_staging2
Group by company, YEAR (`date`)
ORder by 3 DESC;

WITH Company_YEAR (company, years, total_laid_off) AS 
(SELECT company, YEAR (`date`), sum(total_laid_off)
FROm layoffs_staging2
Group by company, YEAR (`date`)
ORder by 3 DESC), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(partition by years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;