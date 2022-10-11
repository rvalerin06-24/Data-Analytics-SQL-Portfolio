Select *

From

PortafolioProject. .CovidDeaths$
Where continent is not null
order by 3,4



Select  location, date, total_cases, new_cases, total_deaths, population
From PortafolioProject. .CovidDeaths$
Where continent is not null
Order by 1,2

-- Looking at Total cases vs Total Deaths in Honduras
-- This query shows the percenatge of the people who died from Covid-19 in Honduras 

Select  location, date, total_cases,  total_deaths, cast(total_deaths/total_cases*100 as varchar)+'%' as DeathPercentages  
From PortafolioProject. .CovidDeaths$
Where location like 'Honduras'
and continent is not null
order by 1,2



-- Looking at total Cases vs Population

Select location, date, total_cases, Population, cast(total_cases/Population*100 as varchar)+'%' as PeopleInfected
From PortafolioProject. .CovidDeaths$
Where location like 'Honduras'
and continent is not null
order by 1,2

-- Countries with Highest Infection Rate compared to their Population

Select Location, Population, MAX(total_cases) as HighestInfectionRate,  MAX(total_cases/population*100) as Percentpeopleinfected 
From PortafolioProject. .CovidDeaths$
group by location, population
order by Percentpeopleinfected desc

--Countries with Highest Death ratio to Population

Select Location, MAX (cast(total_deaths as int)) as TotalDeathCount
From PortafolioProject. .CovidDeaths$
Where continent is not null
Group by location
order by TotalDeathCount desc

-- Let's take a look at continent total deathcount

Select continent, MAX (cast(total_deaths as int)) as Deathcountbycontinent
From PortafolioProject. .CovidDeaths$
Where continent is not null
Group by continent
order by Deathcountbycontinent desc

-- Global calculations
Select SUM (new_cases) as Global_cases, SUM(cast(new_deaths as Int)) as TotalGlobalDeathCount, Sum(cast(new_deaths as int))/ SUM (new_cases)*100 as DeathPercentage
From PortafolioProject. .CovidDeaths$

order by 1,2

-- Looking at Total Population vs Vaccinations


Select death.continent, death.location, death.date, death.population, vacci.new_vaccinations, SUM(cast(vacci.new_vaccinations as int )) Over (Partition by death.location order by death.location, death.date) As PeopleVaccinated
From PortafolioProject..CovidVaccinations$ vacci
Join PortafolioProject. .CovidDeaths$ death
      On death.location = vacci.location
	  and death.date = vacci.date
Where death.continent is not null
Order by 2,3

-- Using CTE to perform a calculation.


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select death.continent, death.location, death.date, death.population, vacci.new_vaccinations, SUM(cast(vacci.new_vaccinations as int )) Over (Partition by death.location order by death.location, death.date) As PeopleVaccinated
From PortafolioProject..CovidVaccinations$ vacci
Join PortafolioProject. .CovidDeaths$ death
      On death.location = vacci.location
	  and death.date = vacci.date
Where death.continent is not null
)
Select*, cast(PeopleVaccinated/Population*100 as varchar)+'%' as PercentageofPeopleVaccinated
From PopvsVac 


-- Creating a view for visualizations

--View #1

Create View PeopleVaccinated as
Select death.continent, death.location, death.date, death.population, vacci.new_vaccinations, SUM(cast(vacci.new_vaccinations as int )) Over (Partition by death.location order by death.location, death.date) As PeopleVaccinated
From PortafolioProject..CovidVaccinations$ vacci
Join PortafolioProject. .CovidDeaths$ death
      On death.location = vacci.location
	  and death.date = vacci.date
Where death.continent is not null


--View #2

Create view Percentage_of_People_Vaccinated as
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select death.continent, death.location, death.date, death.population, vacci.new_vaccinations, SUM(cast(vacci.new_vaccinations as int )) Over (Partition by death.location order by death.location, death.date) As PeopleVaccinated
From PortafolioProject..CovidVaccinations$ vacci
Join PortafolioProject. .CovidDeaths$ death
      On death.location = vacci.location
	  and death.date = vacci.date
Where death.continent is not null
)
Select*, cast(PeopleVaccinated/Population*100 as varchar)+'%' as PercentageofPeopleVaccinated
From PopvsVac 


--View #3
Create view Death_Percentages_in_Honduras as
Select  location, date, total_cases,  total_deaths, cast(total_deaths/total_cases*100 as varchar)+'%' as DeathPercentages  
From PortafolioProject. .CovidDeaths$
Where location like 'Honduras'
and continent is not null



--View #4

Create view People_Infectd__in_Honduras_Percentage as
Select location, date, total_cases, Population, cast(total_cases/Population*100 as varchar)+'%' as PeopleInfected
From PortafolioProject. .CovidDeaths$
Where location like 'Honduras'
and continent is not null
