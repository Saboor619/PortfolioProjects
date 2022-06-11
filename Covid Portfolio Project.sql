-- Shows death percentage of covid in pakistan
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From Portfolioproject..CovidDeaths$
Where Location like '%Pakistan%'
order by 1,2


-- Shows max total cases all around the world
Select Location, max(total_cases) as HighestInfectioncount
From Portfolioproject..CovidDeaths$
Group by Location, Population



--Shows Total death counts up until april 24 all around the world
Select Location, max(total_deaths) as Totaldeathcount
From Portfolioproject..CovidDeaths$
Where continent is null
Group by location
order by Totaldeathcount desc


--Shows Total death counts up until april 24 for continents


Select continent, max(total_cases) as HighestInfectioncount
From Portfolioproject..CovidDeaths$
Where continent is not null
Group by continent



-- Shows Total cases in Pakistan in relation with time
Select date, total_cases
From Portfolioproject..CovidDeaths$
Where location like '%Pakistan%'
Group by date, total_cases



--Shows total deaths in pakistan with dates
Select date, total_deaths
From Portfolioproject..CovidDeaths$
Where location like '%Pakistan%'
Group by total_deaths, date



--looking at Total population vs Vaccinations  creating a join
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Portfolioproject..CovidDeaths$ dea
Join Portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null


-- Showing Rolling count of new vaccinations of all countries 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolioproject..CovidDeaths$ dea
Join Portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null


--Use CTE

With PopvsVac (Continent, Location, Date, popultaion, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolioproject..CovidDeaths$ dea
Join Portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3
)

Select *, 
From PopvsVac


--temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continet nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolioproject..CovidDeaths$ dea
Join Portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating view to store date later
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolioproject..CovidDeaths$ dea
Join Portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null








