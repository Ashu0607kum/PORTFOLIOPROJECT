Select * from
portfolioProject..CovidDeaths$
where continent is not null;

--Select * from
----portfolioProject..CovidVaccination$;
 
 --Data that is using

 select location, date, total_cases, new_cases , total_deaths , population
 from PortfolioProject..CovidDeaths$
 order by 1,2;

 --Looking at total cases VS total Deaths 
 select location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
 from PortfolioProject..CovidDeaths$ where continent is not null
 Where location like '%India%'
 where continent is not null;
  order by 1,2;

  
 --Looking at total cases VS Population
 --shows what percentage of population got covid

 select location, date, Population, total_cases,  (total_cases/population)*100 as DeathPercentage
 from PortfolioProject..CovidDeaths$ where continent is not null
 --Where location like '%India%'
  order by 1,2;

  --Looking contries with Highest Infection rate compared with Population

  select location, Population, MAX(total_cases) as Highestinfectioncount,  MAX((total_cases/population))*100 as PercentagePopulationInfected
 from PortfolioProject..CovidDeaths$ where continent is not null
 --Where location like '%India%'
 group by population,location
  order by  PercentagePopulationInfected desc;

  --Showing countries with highest Death count per Population

  select location,MAX(cast(total_deaths as int)) as totaldeathcount
 from PortfolioProject..CovidDeaths$
 where continent is not null
 --Where location like '%India%'
 group by location
  order by totaldeathcount desc;

  --Break things down by  Continent

  select Continent ,MAX(cast(total_deaths as int)) as totaldeathcount
 from PortfolioProject..CovidDeaths$
 where continent is not null
 --Where location like '%India%'
 group by continent
  order by totaldeathcount desc;


  --Showing  continent with the highest death count per population 

  select continent, Max(cast(Total_deaths as int)) as totaldeathcount
  from portfolioProject..CovidDeaths$
  --Where continent is not null
  group by continent
  order by totaldeathcount desc

  --Global number

  select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
  FROM PortfolioProject..CovidDeaths$
  where continent is not null
  order by 1,2;

  -- join 2 table 

  select  *
   from portfolioProject..CovidDeaths$ dea
    Join portfolioProject..CovidVaccination$ vac
	on dea.location= vac.location
	and dea.date=vac.date
	  




  --looking Total population vs Vaccination

Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as Rollingpeoplevaccinated
From Portfolioproject..CovidDeaths$ dea
join Portfolioproject..CovidVaccination$ vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3;


--USE CTE--


With popvsVac (continent, location , date ,population,New_vaccinations, Rollingpeoplevaccinated)
as
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as Rollingpeoplevaccinated
From Portfolioproject..CovidDeaths$ dea
join Portfolioproject..CovidVaccination$ vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*, (Rollingpeoplevaccinated/population)*100
from popvsVac 

--Temp table

Drop table if exists PercentpopulationVaccinated
Create table PercentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into PercentpopulationVaccinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as Rollingpeoplevaccinated
From Portfolioproject..CovidDeaths$ dea
join Portfolioproject..CovidVaccination$ vac
On dea.location=vac.location
 and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *, (Rollingpeoplevaccinated/population)*100
from PercentpopulationVaccinated

--Creating view to store data for later visualizations

Create view PercentPopulationVaccination as
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
        SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as Rollingpeoplevaccinated
From Portfolioproject..CovidDeaths$ dea
join Portfolioproject..CovidVaccination$ vac
    on dea.location = vac.location
    and dea.date = vac.date
	where dea.continent is not null

	
	select * from PercentPopulationVaccination