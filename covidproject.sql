--select *
--from dbo.CovidVaccinations
--order by location, date

select * 
From dbo.CovidDeaths
where continent is not null
order by location, date;

-- Select the data we are going to be using.

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    dbo.CovidDeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- looking at the Total Cases versus Total Deaths
-- shows likelihood of dying if you contract COVID

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    dbo.CovidDeaths
WHERE
    location LIKE '%states%'
        AND continent IS NOT NULL
ORDER BY 1 , 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

SELECT location, date, total_cases, Population, (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
--where location = 'United States'
order by 1, 2;

--What countries have the highest infection rates relative to population

SELECT location, Population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
--where location = 'United States'
GROUP BY location, population
order by PercentPopulationInfected desc;


-- Showing the countries with Highest Death Count Per Population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
where continent is not null
--where location = 'United States'
GROUP BY location
order by TotalDeathCount desc;


-- Breaking down by continent

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
where continent is null
GROUP BY location
order by TotalDeathCount desc;



-- GLOBAL NUMBERS

SELECT date, sum(new_cases) as total_deaths, sum(cast(new_deaths as int)) as total_deaths, 
	sum(cast(new_deaths as int))/SUM(New_cases) * 100 as DeathPercentage
FROM dbo.CovidDeaths
where continent is not null
group by date
order by 1, 2;

SELECT sum(new_cases) as total_deaths, sum(cast(new_deaths as int)) as total_deaths, 
	sum(cast(new_deaths as int))/SUM(New_cases) * 100 as DeathPercentage
FROM dbo.CovidDeaths
where continent is not null
order by 1, 2;


-- Joining the covid deaths and covid vaccination tables together using location and date. 

select * 
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date =vac.date

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2, 3

-- USE CTE

WITH PopvsVac (Continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeopleVaccinated/population) * 100
FROM popvsvac

-- TEMP TABLE 
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
loation nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location order by dea.location, dea.date) as RolliingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
--order by 2, 3
SELECT *, (RollingPeopleVaccinated/population) * 100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.Location order by dea.location, dea.date) as RolliingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
