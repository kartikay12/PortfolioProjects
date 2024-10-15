Select *
From CovidDeath
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeath
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeath
Where location like '%india%'
and continent is not null  and total_deaths >0
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeath
where total_cases > 0
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeath
WHERE total_cases > 0
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeath
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeath
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--Showing countries with highest deathcount


SELECT continent,MAX(cast(total_deaths as int)) as total_death_count
from CovidDeath
WHERE continent is not null
GROUP BY continent
order by total_death_count desc


--GLobalNumbers

Select    sum(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_deaths , (SUM(new_deaths)/SUM(new_cases)*100) as percentage
from CovidDeath
where continent is not null  and total_cases > 0 and  new_deaths > 0 and new_cases > 0
ORDER BY 1,2


--Looking at Total population vs Vaccination

SELECT 
    death.continent, 
    death.location, 
    death.date, 
    death.population, 
    vacci.new_vaccinations,
    SUM(CONVERT(bigint, vacci.new_vaccinations)) OVER (Partition by death.Location ORDER BY death.location, death.Date) as RollingPeopleVaccinated
   --, (RollingPeopleVaccinated/population)*100
FROM 
    Portfolio..CovidDeath death
JOIN 
    Portfolio..CovidVaccination vacci
    ON death.location = vacci.location
    AND death.date = vacci.date
WHERE 
    death.continent IS NOT NULL 
ORDER BY 
    2, 3;

--USE CTE

--with pops vs vaccii
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT 
    death.continent, 
    death.location, 
    death.date, 
    death.population, 
    vacci.new_vaccinations,
    SUM(CONVERT(bigint, vacci.new_vaccinations)) OVER (Partition by death.Location ORDER BY death.location, death.Date) as RollingPeopleVaccinated
   --, (RollingPeopleVaccinated/population)*100
FROM 
    Portfolio..CovidDeath death
JOIN 
    Portfolio..CovidVaccination vacci
    ON death.location = vacci.location
    AND death.date = vacci.date
WHERE 
    death.continent IS NOT NULL 

)
Select *, (RollingPeopleVaccinated/Population)*100 as percentage
From PopvsVac

-- TEMP TABLE

DROP TABLE IF EXIStS #PercentPopulation
create table #PercentPopulation
(continent nvarchar (250),
location nvarchar(250),
date datetime,
population bigint,
New_vaccinations bigint,
RollingPeopleVaccinated bigint)
insert into #PercentPopulation
SELECT 
    death.continent, 
    death.location, 
    death.date, 
    death.population, 
    vacci.new_vaccinations,
    SUM(CONVERT(bigint, vacci.new_vaccinations)) OVER (Partition by death.Location ORDER BY death.location, death.Date) as RollingPeopleVaccinated
   --, (RollingPeopleVaccinated/population)*100
FROM 
    Portfolio..CovidDeath death
JOIN 
    Portfolio..CovidVaccination vacci
    ON death.location = vacci.location
    AND death.date = vacci.date
WHERE 
    death.continent IS NOT NULL 

Select *, (RollingPeopleVaccinated/Population)*100 as percentage
From #PercentPopulation

----CREATING VIEW TO STORE DATA FOR LATER

create view PercentPopulationVaccinated as 

SELECT 
    death.continent, 
    death.location, 
    death.date, 
    death.population, 
    vacci.new_vaccinations,
    SUM(CONVERT(bigint, vacci.new_vaccinations)) OVER (Partition by death.Location ORDER BY death.location, death.Date) as RollingPeopleVaccinated
   --, (RollingPeopleVaccinated/population)*100
FROM 
    Portfolio..CovidDeath death
JOIN 
    Portfolio..CovidVaccination vacci
    ON death.location = vacci.location
    AND death.date = vacci.date
WHERE 
    death.continent IS NOT NULL 

	SELECT *
	FROM PercentPopulationVaccinated 




