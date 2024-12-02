SELECT *
FROM `CovidProject.CovidProject_covid_deaths`
ORDER BY 3,4;

select *
from `CovidProject.CovidProject-covid-vaccinations`
order by 3,4;

--select the data that we are going to be using

SELECT 
  location, date, total_cases, new_cases, total_deaths, population
FROM `CovidProject.CovidProject_covid_deaths`
ORDER BY 1,2;


-- looking at total cases vs total deaths
SELECT 
  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM `CovidProject.CovidProject_covid_deaths`
WHERE continent is not null
ORDER BY 1,2;



SELECT 
  location, date, total_cases, new_cases, total_deaths, population, continent
FROM `CovidProject.CovidProject_covid_deaths`
WHERE continent is not null
ORDER BY 1,2;

-- looking at total cases vs total deaths
-- we calculate death percentage using this code (total_deaths/total_cases)*100 as DeathPercentage
-- shows the chance of dying if you contract covid in your country
-- we can see data from any country using a WHERE clause

SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage,
FROM `CovidProject.CovidProject_covid_deaths`
WHERE location like '%States%' and continent is not null
ORDER BY 1,2;

-- looking at total cases vs population
-- shows what percentage of the population got covid
-- shows liklehood of dying in your country if you got covid
SELECT Location, date, Population,total_cases,(total_cases/population)*100 as PercentagePopulationInfected
FROM `CovidProject.CovidProject_covid_deaths`
WHERE location like '%States%'
ORDER BY 1,2;

-- looking at total cases vs population
-- shows what percentage of population got covid
SELECT Location, date, total_cases, Population,(total_cases/population)*100 as DeathPercentage
FROM `CovidProject.CovidProject_covid_deaths`
WHERE location like '%States%'
AND continent is not null
ORDER BY 1,2;

--Looking at countries with highest infection rate compared to population

SELECT Location, Population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected,
FROM `CovidProject.CovidProject_covid_deaths`
--WHERE location like '%United States%'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentagePopulationInfected desc;

--Showing the countries with the highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM `CovidProject.CovidProject_covid_deaths`
--WHERE location like '%United States%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc;

--lets break things down by continent

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM `CovidProject.CovidProject_covid_deaths`
--WHERE location like '%United States%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;

--lets break things down by continent 
--this time we will change the where clause to is null and we will select location
--the first time we looked into continent numbers they were not counting canada in north america
--this is actually the correct code, it returns more accurate numbers
--for the sake of the data visualization we will just use the code that returns skewed data
--this returns the actual correct numbers

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM `CovidProject.CovidProject_covid_deaths`
--WHERE location like '%United States%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc;


--for the sake of the data visualization we will just use the code that returns skewed data
--show continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM `CovidProject.CovidProject_covid_deaths`
--WHERE location like '%United States%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;

--any other code can be grouped by continent to analyze deaths by continent, we can scroll back up and change the code to do this, just group by continent

-- Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage,
FROM `CovidProject.CovidProject_covid_deaths`
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;

--now we can remove the date and see global total cases, total deaths, and death percentage

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM `CovidProject.CovidProject_covid_deaths`
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2;

--now we will take a look at covid vaccinations
--we will join the tables

SELECT *
FROM `CovidProject.CovidProject_covid_deaths`
JOIN `CovidProject.CovidProject-covid-vaccinations`
  ON `CovidProject.CovidProject_covid_deaths`.location = `CovidProject.CovidProject-covid-vaccinations`.location
  AND `CovidProject.CovidProject_covid_deaths`.date = `CovidProject.CovidProject-covid-vaccinations`.date;

--looking at Total Population vs Vaccination

SELECT 
  `CovidProject.CovidProject_covid_deaths`.continent,
  `CovidProject.CovidProject_covid_deaths`.location,
  `CovidProject.CovidProject_covid_deaths`.date,
  `CovidProject.CovidProject_covid_deaths`.population,
  `CovidProject.CovidProject-covid-vaccinations`.new_vaccinations,
  SUM(cast(`CovidProject.CovidProject-covid-vaccinations`.new_vaccinations as int)) OVER (PARTITION BY `CovidProject.CovidProject_covid_deaths`.location ORDER BY `CovidProject.CovidProject_covid_deaths`.location, `CovidProject.CovidProject_covid_deaths`.date) AS RollingPeopleVaccinated, 
    --(RollingPeopleVaccinated/`CovidProject.CovidProject_covid_deaths`.population)
FROM `CovidProject.CovidProject_covid_deaths`
JOIN `CovidProject.CovidProject-covid-vaccinations`
  ON `CovidProject.CovidProject_covid_deaths`.location = `CovidProject.CovidProject-covid-vaccinations`.location
  AND `CovidProject.CovidProject_covid_deaths`.date = `CovidProject.CovidProject-covid-vaccinations`.date
WHERE `CovidProject.CovidProject_covid_deaths`.continent is not null
ORDER BY 2,3;


-- use cte
with PopvsVac  as
(
SELECT 
  `CovidProject.CovidProject_covid_deaths`.continent,
  `CovidProject.CovidProject_covid_deaths`.location,
  `CovidProject.CovidProject_covid_deaths`.date,
  `CovidProject.CovidProject_covid_deaths`.population,
  `CovidProject.CovidProject-covid-vaccinations`.new_vaccinations,
  SUM(cast(`CovidProject.CovidProject-covid-vaccinations`.new_vaccinations as int)) OVER (PARTITION BY `CovidProject.CovidProject_covid_deaths`.location ORDER BY `CovidProject.CovidProject_covid_deaths`.location, `CovidProject.CovidProject_covid_deaths`.date) AS RollingPeopleVaccinated, 
    --(RollingPeopleVaccinated/`CovidProject.CovidProject_covid_deaths`.population)
FROM `CovidProject.CovidProject_covid_deaths`
JOIN `CovidProject.CovidProject-covid-vaccinations`
  ON `CovidProject.CovidProject_covid_deaths`.location = `CovidProject.CovidProject-covid-vaccinations`.location
  AND `CovidProject.CovidProject_covid_deaths`.date = `CovidProject.CovidProject-covid-vaccinations`.date
WHERE `CovidProject.CovidProject_covid_deaths`.continent is not null

)
select *
from PopvsVac;

-- now we can use the cte to run further calculations
with PopvsVac  as
(
SELECT 
  `CovidProject.CovidProject_covid_deaths`.continent,
  `CovidProject.CovidProject_covid_deaths`.location,
  `CovidProject.CovidProject_covid_deaths`.date,
  `CovidProject.CovidProject_covid_deaths`.population,
  `CovidProject.CovidProject-covid-vaccinations`.new_vaccinations,
  SUM(cast(`CovidProject.CovidProject-covid-vaccinations`.new_vaccinations as int)) OVER (PARTITION BY `CovidProject.CovidProject_covid_deaths`.location ORDER BY `CovidProject.CovidProject_covid_deaths`.location, `CovidProject.CovidProject_covid_deaths`.date) AS RollingPeopleVaccinated, 
    --(RollingPeopleVaccinated/`CovidProject.CovidProject_covid_deaths`.population)
FROM `CovidProject.CovidProject_covid_deaths`
JOIN `CovidProject.CovidProject-covid-vaccinations`
  ON `CovidProject.CovidProject_covid_deaths`.location = `CovidProject.CovidProject-covid-vaccinations`.location
  AND `CovidProject.CovidProject_covid_deaths`.date = `CovidProject.CovidProject-covid-vaccinations`.date
WHERE `CovidProject.CovidProject_covid_deaths`.continent is not null

)
select *, (RollingPeopleVaccinated/population) * 100
from PopvsVac;


-- temp table
drop table if exists #PercentPopulationVaccinated
create temporary table #PercentPopulationVaccinated
(
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vaccinations numeric,
  RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
  `CovidProject.CovidProject_covid_deaths`.continent,
  `CovidProject.CovidProject_covid_deaths`.location,
  `CovidProject.CovidProject_covid_deaths`.date,
  `CovidProject.CovidProject_covid_deaths`.population,
  `CovidProject.CovidProject-covid-vaccinations`.new_vaccinations,
  SUM(cast(`CovidProject.CovidProject-covid-vaccinations`.new_vaccinations as int)) OVER (PARTITION BY `CovidProject.CovidProject_covid_deaths`.location ORDER BY `CovidProject.CovidProject_covid_deaths`.location, `CovidProject.CovidProject_covid_deaths`.date) AS RollingPeopleVaccinated, 
    --(RollingPeopleVaccinated/`CovidProject.CovidProject_covid_deaths`.population)
FROM `CovidProject.CovidProject_covid_deaths`
JOIN `CovidProject.CovidProject-covid-vaccinations`
  ON `CovidProject.CovidProject_covid_deaths`.location = `CovidProject.CovidProject-covid-vaccinations`.location
  AND `CovidProject.CovidProject_covid_deaths`.date = `CovidProject.CovidProject-covid-vaccinations`.date
WHERE `CovidProject.CovidProject_covid_deaths`.continent is not null

select *, (RollingPeopleVaccinated/population) * 100
from #PercentPopulationVaccinated


-- creating view to store data for later visualizations

Create View totalDeathCountByContinent as
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM `CovidProject.CovidProject_covid_deaths`
--WHERE location like '%United States%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;


