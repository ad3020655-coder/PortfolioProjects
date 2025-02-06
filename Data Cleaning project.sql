-- Data Cleaning

select *
from layoffs;
 -- 1. Remove duplicates
 -- 2. Standardize the data
 -- 3. Look at null values or blank values
 -- 4. Remove any columns 
 
 -- in the real work setting you will often have datasets that will datasets that are constantly importing data
 -- this dataset would be called the raw dataset and to removeordelete anything fromthe raw datset will cause big problems
 -- we will create some staging and copy allof the data from the raw data tothe staging table
 
Create table layoffs_staging
like layoffs; 

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

 -- in a real job do not work on the raw data
 
 -- here we will start removing duplicates
 -- first we identify duplicates
 select *,
 row_number() over(
 partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
 from layoffs_staging;
 
 -- we need to filter this to find any row num greater than two
 with duplicate_cte as
 (
 select *,
 row_number() over(
 partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
 from layoffs_staging
 )
 select *
 from duplicate_cte 
 where row_num > 1;
 
 -- we get results with row numbers that are the same
 -- we need to make sure these are really duplicates
 
 -- lets take a look at one of our companies with the row number greater than one just to make sue they are really duplicates
 select * 
 from layoffs_staging
 where company = 'Oda';
 
 -- we can see that not all oda company rows are duplicates
 -- we realize we need to make a cte that partitions by all of the columns
 -- this will give us more accurate data
 
  with duplicate_cte as
 (
 select *,
 row_number() over(
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging
 )
 select *
 from duplicate_cte 
 where row_num > 1;
 
 select * 
 from layoffs_staging
 where company = 'Casper';
 
 -- here we will delete the duplicates from the cte
 
   with duplicate_cte as
 (
 select *,
 row_number() over(
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging
 )
 delete
 from duplicate_cte 
 where row_num > 1;
 
 -- we run this and get an erro saying the target table duplicate_cte of the DELETE is not updatable
 -- to fix this we run the following
 -- we will create another table that includes the repeated columns and delete them from there
 -- we create the table by right clicking layoffs_staging and copying a create statement to the clipboard
 -- paste it in and add the row_num column as an int
 
 select *,
 row_number() over(
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
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

select * 
from layoffs_staging2;

-- we now have an empty table 
-- we will insert the information here
insert into layoffs_staging2
 select *,
 row_number() over(
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
-- here we have all of our duplicates
select * 
from layoffs_staging2
where row_num > 1;

-- now we will delete them
delete 
from layoffs_staging2
where row_num > 1;

select * 
from layoffs_staging2
where row_num > 1;


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

