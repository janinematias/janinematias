use covid_data;
SELECT * 
FROM coviddeaths
WHERE continent is not null;

-- converting empty strings to null values
UPDATE coviddeaths
SET total_deaths = NULL where total_deaths = '';
UPDATE coviddeaths
SET continent = NULL where continent = '';


-- converting columns into integer type
ALTER TABLE coviddeaths
CHANGE total_deaths total_deaths INT;



-- countries over 5m population with highest death percentage in 2022

SELECT 
    location, population, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,3) as death_percentage
FROM
    coviddeaths
WHERE date > '2022-01-01' and population > 5000000 and continent IS NOT NULL
GROUP BY location
ORDER BY death_percentage DESC;

-- population vs total covid cases in AUSTRALIA/ progression of COVID in australia

SELECT 
    location,
    date,
    population,
    total_cases,
    ROUND((total_cases / population) * 100, 3) AS percent_covid
FROM
    coviddeaths
WHERE
    location = 'Australia'
ORDER BY location , percent_covid;

    
CREATE VIEW v_covid_aus as
SELECT 
    location,
    date,
    population,
    total_cases,
    ROUND((total_cases / population) * 100, 3) AS percent_covid
FROM
    coviddeaths
WHERE
    location = 'Australia'
ORDER BY location , percent_covid;


-- highest covid infection rate per country

SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases / population) * 100) AS highest_infection_percent
FROM
    coviddeaths
GROUP BY location , population
ORDER BY highest_infection_percent DESC;

CREATE VIEW v_infection_rate as
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases / population) * 100) AS highest_infection_percent
FROM
    coviddeaths
GROUP BY location , population
ORDER BY highest_infection_percent DESC;

-- highest death count per population
SELECT 
    location,
    population,
    MAX(total_deaths) AS highest_death_count,
    MAX((total_deaths / population) * 100) AS population_death_percent
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY population_death_percent DESC;

CREATE VIEW v_high_death_c as
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases / population) * 100) AS highest_infection_percent
FROM
    coviddeaths
GROUP BY location , population
ORDER BY highest_infection_percent DESC;

-- by continents
SELECT 
    continent, MAX(total_deaths) AS total_death_count
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- global numbers

SELECT 
    SUM(new_cases) AS global_cases,
    SUM(new_deaths) AS global_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 as global_death_percent
FROM
    coviddeaths
WHERE
    continent IS NOT NULL;

-- vaccinations data set exploration and cleaning

SELECT * from covidvaccinations;

UPDATE covidvaccinations
SET new_vaccinations = NULL where new_vaccinations = '';

UPDATE covidvaccinations
SET total_vaccinations = NULL where total_vaccinations = '';

UPDATE covidvaccinations
SET people_vaccinated = NULL where people_vaccinated = '';

UPDATE covidvaccinations
SET people_fully_vaccinated = NULL where people_fully_vaccinated = '';

ALTER TABLE covidvaccinations
CHANGE total_vaccinations total_vaccinations BIGINT;

ALTER TABLE covidvaccinations
CHANGE new_vaccinations new_vaccinations BIGINT;

ALTER TABLE covidvaccinations
CHANGE people_vaccinated people_vaccinated BIGINT;

ALTER TABLE covidvaccinations
CHANGE people_fully_vaccinated people_fully_vaccinated BIGINT;

-- joint exploration
SELECT 
    *
FROM
    coviddeaths cd
        JOIN
    covidvaccinations cv ON cd.location = cv.location
        AND cd.date = cv.date;

SELECT 
cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.people_vaccinated, ROUND((people_vaccinated/population)*100, 3) as percent_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv ON cd.location = cv.location and cd.date = cv.date
WHERE cd.continent is NOT NULL
ORDER BY cd.location, cd.date;

-- Creating views to store data for later visualisation

CREATE VIEW v_percent_vaccinated AS
    SELECT 
        cd.continent,
        cd.location,
        cd.date,
        cd.population,
        cv.people_vaccinated,
        ROUND((people_vaccinated / population) * 100,
                3) AS percent_vaccinated
    FROM
        coviddeaths cd
            JOIN
        covidvaccinations cv ON cd.location = cv.location
            AND cd.date = cv.date
    WHERE
        cd.continent IS NOT NULL
    ORDER BY cd.location , cd.date;

