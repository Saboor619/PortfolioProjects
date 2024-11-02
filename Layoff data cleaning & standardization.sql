--Data Cleaning
SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
row_number() over( Partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS  row_num
FROM layoffs_staging;

WITH CTE_duplicate AS 
(SELECT *,
row_number() over( Partition by company, location, industry, total_laid_off, percentage_laid_off, 'date') AS  row_num
FROM layoffs_staging)
SELECT *
FROM CTE_duplicate
Where row_num > 1;
 
SELECT *
FROM layoffs_staging
WHERE company = 'Casper' ;
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
row_number() over( Partition by company, location, industry, total_laid_off, percentage_laid_off, 'date') AS  row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1
;
SET SQL_SAFE_UPDATES = 0;
SELECT *
FROM layoffs_staging2;

-- STANDARDIZING DATA

SELECT DISTINCT(company), trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company) ;


SELECT *
FROM layoffs_staging2
WHERE industry Like 'CRYPTO%';

Update layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
Order BY 1;

SELECT distinct country, trim(Trailing '.' FROM country)
FROM layoffs_staging2
Order by 1;

Update layoffs_staging2
Set country = trim(Trailing '.' FROM country)
WHERE country like 'United states%';

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FRom layoffs_staging2 ;

Update layoffs_staging2
Set `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2 ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` date;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_Staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL OR t1.industry = ''
AND t2.industry IS NOT NULL;

Update layoffs_staging2
SET industry = NUll
WHERE industry = '';

Update layoffs_Staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL  
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2
WHere company  LIKE 'BAlly%';

DELETE
FROM layoffs_Staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
Drop column row_num;

