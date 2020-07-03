use agri;
-- Quantities are in Metric Ton(MT) and values are in Rs. Crore
CREATE TABLE prod_quantity (
  commodities VARCHAR(40) PRIMARY KEY ,
  Prod_quan_2010 float,
  Prod_quan_2011 float,
  Prod_quan_2012 float,
  Prod_quan_2013 float,
  Prod_quan_2014 float,
  Prod_quan_2015 float,
  Prod_quan_2016 float,
  Prod_quan_2017 float,
  Prod_quan_2018 float
        );
   
        
CREATE TABLE organic_ex (
  category VARCHAR(80) PRIMARY key,
  organic_ex_quantity FLOAT,
  organic_ex_value FLOAT
);


CREATE TABLE agri_import (
  commodities VARCHAR(80) PRIMARY key,
  value2014 FLOAT,
  value2015 FLOAT,
  value2016 FLOAT,
  value2017 FLOAT,
  value2018 FLOAT 
);


CREATE TABLE agri_export (
  commodities VARCHAR(80) PRIMARY key,
  value2014 FLOAT,
  value2015 FLOAT,
  value2016 FLOAT,
  value2017 FLOAT,
  value2018 FLOAT
);

CREATE TABLE countries_export_old (
  commodities VARCHAR(80) ,
  Countries VARCHAR(80),
  qty2011 FLOAT,
  value2011 FLOAT,
  qty2012 FLOAT,
  value2012 FLOAT,
  qty2013 FLOAT,
  value2013 FLOAT,
  PRIMARY key(commodities,countries)
);

-- All Table values have been inserted from csv files using import wizard tool of Mysql workbench-----------------------------------------
SELECT * FROM agri_export;
SELECT * FROM agri_import;
SELECT * FROM organic_ex;
SELECT * FROM countries_export_old;
DELETE FROM countries_export_old
where countries='Total';
SELECT * FROM prod_quantity;

-- From which export commodity did we fetch the highest values in 2018?
Select commodities
From agri_export
where value2018= (Select max(value2018)
                  from agri_export);
  #ans Rice basmati   
  
  
-- Which import commodity costed us the most?
Select commodities
From agri_import
where value2018= (Select max(value2018)
                  from agri_import);
   #ans Vegetable oils     
   
   
-- Mention commodities with average export value and average import value during 2014-2018
Select agri_export.commodities, (agri_export.value2014+agri_export.value2015+agri_export.value2016+agri_export.value2017+agri_export.value2018)/4 as average_export,
(agri_import.value2014+agri_import.value2015+agri_import.value2016+agri_import.value2017+agri_import.value2018)/4 as average_import
from agri_export
join agri_import
on agri_export.commodities=agri_import.commodities 
;

-- Mention the commodities records for which export value has only been increasing during 2014-2018
SELECT *
FROM agri_import
where value2014 < value2015 and value2015< value2016 and value2016< value2017 and value2017< value2018;

-- Mention the commodities exported that are some or the other form of oil
Select commodities
from agri_export
where commodities like '%oil%';

-- What were the top(by value) three organic categories that were exported in 2018-19
Select category
from organic_ex
order by organic_ex_value
limit 3;

-- Out of the commodities exported, what all categories were exported in organic form in 2018-19 in what quantity and value
Select organic_ex.category, agri_export.commodities
from organic_ex
join agri_export
on organic_ex.category LIKE CONCAT('%', agri_export.commodities ,"%");

-- Sort the countries_export_old table first by commodities and then by countries
SELECT * 
FROM countries_export_old
order by commodities, countries;
-- What all agri commodities were exported into Iran during 2011-2013? ( assuming we have complete data of agri exports)
SELECT commodities
FROM countries_export_old
where countries='Iran';
# oil meals, Rice Basmati,Sugar
-- In which countries were pulses exported during 2011-2013 and in what quantity and value?

SELECT * 
FROM countries_export_old
where commodities='Pulses';

-- In which country was the Rice Basmati exported the most in 2013?
SELECT  countries
FROM countries_export_old
where commodities='Rice Basmati'
order by qty2013
limit 1;
#ans U Arab emits

-- What is the total value of agri import carried by pakistan from India during 2011-2013.( assuming we have complete data of agri exports)
SELECT countries,sum(value2011) as India_agri_importvalue2011,sum(value2012) as India_agri_importvalue2012,sum(value2013) as India_agri_importvalue2013
FROM countries_export_old
where countries='Pakistan'
group by countries;
;

-- -- find the export and import value of the commodity (in 2018) that was exported in highest value in 2013.

Select agri_export.value2018
from agri_export
where commodities=
(Select commodities 
from countries_export_old
order by value2013 DESC
limit 1);
-- Returning no value

Select commodities
from agri_export
where commodities like '%Rice%';

#Issue: Rice basmati is written as Rice-Basmoti in commodities column of agri_export.
#Action: I am going to update that
UPDATE agri_export
SET commodities='Rice Basmati'
where commodities='Rice-Basmoti';
 
Select *
from agri_export
where commodities=
(Select commodities 
from countries_export_old
order by value2013 DESC
limit 1);


