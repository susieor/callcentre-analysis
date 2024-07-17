select * from callcenter.info;

select distinct customer_name from callcenter.info
order by 1;

-- I want to check for duplicates- no duplicates
with cte_info as
(select *,
row_number() over(partition by id,customer_name,sentiment,csat_score,call_timestamp,reason,city,state,channel,response_time,`call duration in minutes`,call_center) as row_num
from callcenter.info)
select * from cte_info
where row_num >1;

-- Create a new table to make necessary changes

select * from callcenter.info;


-- create table callcenter.info2
-- select * from callcenter.info

select * from callcenter.info2; -- new table

select csat_score from callcenter.info2;

-- Changing blanks to nulls
UPDATE callcenter.info2
SET csat_score = NULL
WHERE TRIM(csat_score) = '';


-- Deleting the nulls
delete from callcenter.info2
where csat_score is null;


select * from callcenter.info2;

-- Creating another table

create table callcenter.info3 -- table 3 
select * from callcenter.info2;

select * from callcenter.info3;

-- Adding a new column to create abbreviation 
alter table callcenter.info3
add city_ab varchar(30);

-- Adding what was in one column to another
update callcenter.info3
set city_ab = call_center;

-- trimming it
SELECT city_ab, 
       Right(city_ab, LENGTH(city_ab) - 12) AS trimmed_call_center
FROM callcenter.info3
where city_ab like 'Los%';

-- adding the trim to the column 
UPDATE callcenter.info3
SET city_ab = RIGHT(city_ab, LENGTH(city_ab) - 12)
WHERE city_ab LIKE 'Los%';

SELECT city_ab, 
       Right(city_ab, LENGTH(city_ab) -10) AS trimmed_call_center
FROM callcenter.info3
where city_ab like 'Balt%';

UPDATE callcenter.info3
SET city_ab= Right(city_ab, LENGTH(city_ab) -10)
where city_ab like 'Balt%';

SELECT city_ab, 
       Right(city_ab, LENGTH(city_ab) - 7) AS trimmed_call_center
FROM callcenter.info3
where city_ab like 'Den%';

UPDATE callcenter.info3
SET city_ab= Right(city_ab, LENGTH(city_ab) -7)
where city_ab like 'Den%';

SELECT city_ab, 
       Right(city_ab, LENGTH(city_ab) - 8) AS trimmed_call_center
FROM callcenter.info3
where city_ab like 'Chi%';

UPDATE callcenter.info3
SET city_ab= Right(city_ab, LENGTH(city_ab) -8)
where city_ab like 'Chi%';


select * from callcenter.info3;
-- trimming off the last 3 letters in the call centre column as I have added them to a new column (city_ab)
update callcenter.info3
set call_center = LEFT(call_center, LENGTH(call_center) - 3);

-- renaming column 
alter table callcenter.info3
change city_ab state_ab varchar(10);

-- changing text column to date
SELECT 
    call_timestamp,
    STR_TO_DATE(call_timestamp, '%m/%d/%Y') AS formatted_call_timestamp
FROM 
    callcenter.info3;
    
    update callcenter.info3
    set call_timestamp=  STR_TO_DATE(call_timestamp, '%m/%d/%Y');
    
    select * from callcenter.info3;
    
alter table callcenter.info3
modify column call_timestamp DATE;

select * from callcenter.info3







