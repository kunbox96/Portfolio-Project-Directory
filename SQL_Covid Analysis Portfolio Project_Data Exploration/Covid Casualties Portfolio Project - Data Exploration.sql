-- Total case each continent
-- Top and bottom 5 countries have largest infection
-- Total death arround the world and each continent 
-- % of total
-- Countries with Highest Infection Rate compared to Population
-- Countries with Highest Death Count per Population


-- Number of country in dataset
SELECT count(distinct(location)) AS number_of_country
from useful_data;


-- Number of country except continent
SELECT count(distinct(location)) number_of_country_except_continent
FROM useful_data
WHERE location NOT IN(
	SELECT DISTINCT(continent)
	FROM useful_data
	WHERE continent IS NOT NULL
)

---------------------------------------------------------------------------

-- Showing contintents with the highest death count per population

SELECT continent, MAX(total_deaths) total_deaths
FROM useful_data
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY total_deaths;

---------------------------------------------------------------------------
-- Showing the highest deaths in a day of continent, and countries?

SELECT DISTINCT ON(continent, location)
	continent,
	location,
	date,
	MAX(new_deaths) total_deaths
FROM useful_data
WHERE new_deaths IS NOT NULL
GROUP BY 1,2,3
ORDER BY continent, location, total_deaths DESC

-- Window approach to this question
WITH tmp_table AS
	(SELECT continent,
		location, 
		date, 
		new_deaths,
		ROW_NUMBER() OVER(PARTITION BY continent, location ORDER BY new_deaths DESC) AS rn
	FROM useful_data
	WHERE new_deaths IS NOT NULL)

SELECT 
	continent,
	location,
	date,
	new_deaths
FROM tmp_table
WHERE rn = 1
ORDER BY 1,2


---------------------------------------------------------------------------


