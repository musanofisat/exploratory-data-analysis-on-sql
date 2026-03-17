 create database international_breweries;

USE INTERNATIONAL_BREWERIES;

create table int_Breweries(
SALES_ID VARCHAR(100),
SALES_REP VARCHAR(225),
EMAILS VARCHAR(100),
BRANDS VARCHAR(225),
PLANT_COST NUMERIC,
UNIT_PRICE NUMERIC,
QUANTITY NUMERIC,
COSTS NUMERIC,
PROFITS NUMERIC,
COUNTRIES VARCHAR(100),
REGION VARCHAR(100),
MONTHS VARCHAR(100),
YEARS VARCHAR(50)
);

select * from int_breweries;

-- PROFIT ANALYSIS
-- Within the space of the last three years, what was the profit worth of the breweries,inclusive of the anglophone and the francophone territories?

select distinct countries from int_breweries;

with cte as(
	select  *,
	case 
	when countries = "Ghana" then "anglophone"
	when countries =  "Nigeria" then "Anglophone"
	else "Francophone" 
	end as "Territory"
	from int_breweries
    )
select territory, sum(profits) as total_profits
from cte
Group by territory;

-- Compare the total profit between these two territories in order for the territory manager, Mr. Stone made a strategic decision that will aid profit maximization in 2020.
with cte as(select  *,
	case 
	when countries = "Ghana" then "anglophone"
	when countries =  "Nigeria" then "Anglophone"
	else "Francophone" 
	end as "Territory",
case
when years = '2017' then 'profit_2017'
when years = '2018' then 'profit_2018'
else 'profit_2019' end as 'yearly_profits'
from int_breweries)
    select territory, yearly_profits, sum(profits) as total_profits 
    from cte
    group by territory, yearly_profits
    order by total_profits;
    
    

-- Country that generated the highest profit in 2019
select countries, sum(profits) as highest_profits
from int_breweries
where years = "2019"
group by countries
order by sum(profits) desc
limit 1;


-- Help him find the year with the highest profit.
select years, sum(profits) as highest_profits
from int_breweries
group by years
order by sum(profits) desc
limit 1;

-- Which month in the three years was the least profit generated?
select months, sum(profits)
from int_breweries
group by months
order by sum(profits) 
limit 1;

-- What was the minimum profit in the month of December 2018?
select months, max(profits)
from int_breweries
where months = "December"
and years = "2018"
group by months;

-- Compare the profit in percentage for each of the month in 2019
SELECT 
    months, SUM(profits * 100) AS profit_percent
FROM
    int_breweries
WHERE
    years = '2019'
GROUP BY months
ORDER BY profit_percent;


-- Which particular brand generated the highest profit in Senegal?
select brands, sum(profits)
from int_breweries
where countries = "Senegal"
group by brands
order by sum(profits) desc
limit 1;

-- BRAND ANALYSIS
-- Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
with cte as(
    select *,
case when countries = "Senegal" then "Francophone"
	when countries = "Togo" then "Francophone"
	when countries = "benin" then "Francophone"
	else "Anglophone" end as "Territory"
	from int_breweries
    ) 
select years, brands, sum(profits) as total_profits
from cte
where years in ('2018', '2019')
group by years, brands
order by total_profits desc;

-- Find out the top two choice of consumer brands in Ghana
select brands, sum(profits)
from int_breweries
where countries = 'Ghana'
group by brands
order by sum(profits) desc
limit 2;

-- Find out the details of beers consumed in the past three years in the most oil rich country in West Africa.
select * from int_breweries;

select brands, years, sum(quantity)
from int_breweries
where countries = 'Nigeria' 
group by brands, years
order by years;

-- Favorites malt brand in Anglophone region between 2018 and 2019
with cte as(
select *,
case 
    when countries = "Senegal" then "Francophone"
	when countries = "Togo" then "Francophone"
	when countries = "benin" then "Francophone"
	else "Anglophone" end as "Territory",
case
	when brands = 'beta malt' then 'beta malt'
	when brands = 'grand malt' then 'grand malt'
	else 'beer' end as 'malt_brands'
from int_breweries)
select malt_brands, sum(quantity)
from cte
where Territory = 'Anglophone' and years in('2018', '2019') and malt_brands not in('beer')
group by malt_brands;


-- Which brands sold the highest in 2019 in Nigeria?
SELECT 
    brands, sum(profits) as total_quantity
FROM
    int_breweries
WHERE
    years = '2019' AND countries = 'Nigeria'
group by brands
ORDER BY total_quantity DESC
LIMIT 1;

-- Favorites brand in South South region in Nigeria
select brands, sum(quantity) as total_quantity
from int_breweries
where countries = 'Nigeria' and region = 'southsouth'
group by brands
order by total_quantity desc;

-- Bear consumption in Nigeria
select brands as beer_brands, sum(quantity) as total_quantity 
from int_breweries
where countries = 'Nigeria' and brands not in('beta malt', 'grand malt')
group by brands;

-- Level of consumption of Budweiser in the regions in Nigeria
select * from int_breweries; 

select region, sum(quantity) as consumption_level
from int_breweries
where countries = 'Nigeria' and brands = 'Budweiser'
group by region
order by consumption_level desc;   

-- Level of consumption of Budweiser in the regions in Nigeria in 2019 (Demand on promo)
select region, sum(quantity) as consumption_level 
from int_breweries
where countries = 'Nigeria' and brands = 'Budweiser' and years = '2019'
group by region
order by consumption_level desc;   


-- GEO-LOCATION ANALYSIS
-- Country with the highest consumption of beer.
SELECT COUNTRIES, sum(QUANTITY) as total_quantity
FROM INT_BREWERIES
group by countries
ORDER BY total_quantity DESC;

-- Highest sales personnel of Budweiser in Senegal
SELECT SALES_REP, sum(quantity) as total_quantity, sum(profits) as total_profits
FROM INT_BREWERIES
WHERE COUNTRIES = 'Senegal' and brands = 'Budweiser'
group by sales_rep
order by total_quantity desc, total_profits desc
limit 1;

select * from int_breweries;
-- Country with the highest profit of the fourth quarter in 2019
with cte as(
select *,
case 
when months = 'January' then 'First Quarter'
when months = 'February' then 'First Quarter'
when months = 'March' then 'First Quarter'
when months = 'April' then ' Second Quarter'
when months = 'May' then 'Second Quarter'
when months = 'June' then 'Second Quarter'
when months = 'July' then 'Third Quarter'
when months = 'August' then 'Third Quarter'
when months = 'September' then 'Third Quarter'
else 'Fourth Quarter' end as 'Month_Quarter'
from int_breweries
) 
select sum(profits) as total_profits, countries, month_quarter
from cte
where month_quarter = 'Fourth Quarter' and years = '2019'
group by countries, month_quarter
order by total_profits desc
limit 1;




