/*
1.
List each country name where the population is larger than that of 'Russia'.
world(name, continent, area, population, gdp)
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Romania')
*/

SELECT
  x.name
FROM world x
WHERE
  (x.population > (SELECT
                     y.population
                   FROM world y
                   WHERE
                     (y.name = 'Russia')));

/*
2.
Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
Per Capita GDP
The per capita GDP is the gdp/population.
*/

SELECT
  x.name
FROM world x
WHERE
  (x.continent = 'Europe')
AND
  ((x.gdp/x.population) > (SELECT
                             (y.gdp/y.population)
                           FROM world y
                           WHERE
                             (y.name = 'United Kingdom')));

/*
3.
List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
*/

SELECT
  x.name,
  x.continent
FROM world x
WHERE
  (x.continent = (SELECT
                    y.continent
                  FROM world y
                  WHERE
                    (y.name = 'Argentina')))
OR
  (x.continent = (SELECT
                    y.continent
                  FROM world y
                  WHERE
                  (y.name = 'Australia')))
ORDER BY x.name;

/*
4.
Which country has a population that is more than Canada but less than Poland? Show the name and the population.
*/

SELECT
  x.name,
  x.population
FROM world x
WHERE
  (x.population > (SELECT
                     y.population
                   FROM world y
                   WHERE
                     (y.name = 'Canada')))
AND
  (x.population < (SELECT
                     y.population
                   FROM world y
                   WHERE
                     (y.name = 'Poland')));

/*
5.
Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
Decimal places
You can use the function ROUND to remove the decimal places.
https://sqlzoo.net/wiki/ROUND
Percent symbol %
You can use the function CONCAT to add the percentage symbol.
https://sqlzoo.net/wiki/CONCAT
*/

SELECT
  x.name,
  concat(
    round(100 * (x.population / (SELECT
                                   y.population
                                 FROM world y
                                 WHERE
                                 (y.name = 'Germany'))))
         , '%')
FROM world x
WHERE
  (x.continent = 'Europe');

/*
6.
Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
*/

SELECT
  x.name
FROM world x
WHERE
  (x.continent != 'Europe')
AND
  (x.gdp > (SELECT
              max(y.gdp)
            FROM world y
            WHERE
              (y.continent = 'Europe')));

/*
7.
Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, population FROM world x
  WHERE population >= ALL
    (SELECT population FROM world y
        WHERE y.continent=x.continent
          AND population>0)
          The above example is known as a correlated or synchronized sub-query.
          Using correlated subqueries
          A correlated subquery works like a nested loop: the subquery only has access to rows related to a single record at a time in the outer query. The technique relies on table aliases to identify two different uses of the same table, one in the outer query and the other in the subquery.
          One way to interpret the line in the WHERE clause that references the two table is “… where the correlated values are the same”.
          In the example provided, you would say “select the country details from world where the population is greater than or equal to the population of all countries where the continent is the same”.
*/

SELECT
  x.continent,
  x.name,
  x.area
FROM world x
WHERE
  (x.area >= ALL
             (SELECT
                y.area
              FROM world y
              WHERE
                (y.continent = x.continent)
              AND
                (y.area > 0)));

/*
8.
List each continent and the name of the country that comes first alphabetically.
*/

SELECT
  x.continent,
  x.name
FROM world x
WHERE
  (x.name <= ALL
             (SELECT
                y.name
              FROM world y
              WHERE
                (y.continent = x.continent)))
ORDER BY x.continent;

/*
9.
Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
*/

SELECT
  x.name,
  x.continent,
  x.population
FROM world x
WHERE
  (x.continent NOT IN (SELECT
                         y.continent
                       FROM world y
                       WHERE
                         (y.population > 25000000)
                       GROUP BY y.continent))
ORDER BY x.name;

/*
10.
Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
*/

SELECT
  x.name,
  x.continent
FROM world x
WHERE
  (x.population > ALL
                  (SELECT
                     (y.population * 3)
                   FROM world y
                   WHERE
                     (y.population > 0)
                   AND
                     (y.continent = x.continent)
                   AND
                     (y.name != x.name)));
© 2020 GitHub, Inc.