Select *
From PortfolioProject1..CovidDeaths
Where continent is not null
Order by 3,4




Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
Order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
Order by 1,2



Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
Where location like '%states%'
Order by 1,2




Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 
as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
Group by location, population
Order by PercentPopulationInfected desc



Select location, max(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by location
Order by TotalDeathCount desc




Select continent, max(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc




Select continent, max(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc



Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
where continent is not null
Group by date
Order by 1,2


Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
where continent is not null
Order by 1,2





Select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations,
sum(cast(vax.new_vaccinations as int)) over (partition by deaths.location order by deaths.location, 
deaths.date) as TotalPeopleVaccinated
From PortfolioProject1..CovidDeaths deaths
Join PortfolioProject1..CovidVaccinations vax
	ON deaths.location= vax.location
	and deaths.date= vax.date
where deaths.continent is not null
Order by 2,3





With PopvsVax (Continet, location, date, population, New_Vaccinations, TotalPeopleVaccinated)
as 
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations,
sum(cast(vax.new_vaccinations as int)) over (partition by deaths.location order by deaths.location, 
deaths.date) as TotalPeopleVaccinated
From PortfolioProject1..CovidDeaths deaths
Join PortfolioProject1..CovidVaccinations vax
	ON deaths.location= vax.location
	and deaths.date= vax.date
where deaths.continent is not null
)
Select *, (TotalPeopleVaccinated/population)*100
From PopvsVax




DROP table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar (255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
TotalPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations,
sum(cast(vax.new_vaccinations as int)) over (partition by deaths.location order by deaths.location, 
deaths.date) as TotalPeopleVaccinated
From PortfolioProject1..CovidDeaths deaths
Join PortfolioProject1..CovidVaccinations vax
	ON deaths.location= vax.location
	and deaths.date= vax.date
where deaths.continent is not null

Select *, (TotalPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated




CREATE View PercentPopulationVaccinated as
Select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations,
sum(cast(vax.new_vaccinations as int)) over (partition by deaths.location order by deaths.location, 
deaths.date) as TotalPeopleVaccinated
From PortfolioProject1..CovidDeaths deaths
Join PortfolioProject1..CovidVaccinations vax
	ON deaths.location= vax.location
	and deaths.date= vax.date
where deaths.continent is not null

Select *
FROM PercentPopulationVaccinated
