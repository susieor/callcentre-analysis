SELECT 
    *
FROM
    callcenter.info;

SELECT DISTINCT
    customer_name
FROM
    callcenter.info
ORDER BY 1;

with cte_info as
(select *,
row_number() over(partition by id,customer_name,sentiment,csat_score,call_timestamp,reason,city,state,channel,response_time,`call duration in minutes`,call_center) as row_num
from callcenter.info)
select * from cte_info
where row_num >1;

-- Create a new table to make necessary changes

SELECT 
    *
FROM
    callcenter.info;

SELECT 
    *
FROM
    callcenter.info2;-- new table

SELECT 
    csat_score
FROM
    callcenter.info2;

UPDATE callcenter.info2 
SET 
    csat_score = NULL
WHERE
    TRIM(csat_score) = '';


DELETE FROM callcenter.info2 
WHERE
    csat_score IS NULL;


SELECT 
    *
FROM
    callcenter.info2;


CREATE TABLE callcenter.info3 SELECT * FROM
    callcenter.info2;

SELECT 
    *
FROM
    callcenter.info3;

alter table callcenter.info3
add city_ab varchar(30);


UPDATE callcenter.info3 
SET 
    city_ab = call_center;


SELECT 
    city_ab,
    RIGHT(city_ab, LENGTH(city_ab) - 12) AS trimmed_call_center
FROM
    callcenter.info3
WHERE
    city_ab LIKE 'Los%';


UPDATE callcenter.info3 
SET 
    city_ab = RIGHT(city_ab, LENGTH(city_ab) - 12)
WHERE
    city_ab LIKE 'Los%';

SELECT 
    city_ab,
    RIGHT(city_ab, LENGTH(city_ab) - 10) AS trimmed_call_center
FROM
    callcenter.info3
WHERE
    city_ab LIKE 'Balt%';

UPDATE callcenter.info3 
SET 
    city_ab = RIGHT(city_ab, LENGTH(city_ab) - 10)
WHERE
    city_ab LIKE 'Balt%';

SELECT 
    city_ab,
    RIGHT(city_ab, LENGTH(city_ab) - 7) AS trimmed_call_center
FROM
    callcenter.info3
WHERE
    city_ab LIKE 'Den%';

UPDATE callcenter.info3 
SET 
    city_ab = RIGHT(city_ab, LENGTH(city_ab) - 7)
WHERE
    city_ab LIKE 'Den%';

SELECT 
    city_ab,
    RIGHT(city_ab, LENGTH(city_ab) - 8) AS trimmed_call_center
FROM
    callcenter.info3
WHERE
    city_ab LIKE 'Chi%';

UPDATE callcenter.info3 
SET 
    city_ab = RIGHT(city_ab, LENGTH(city_ab) - 8)
WHERE
    city_ab LIKE 'Chi%';


SELECT 
    *
FROM
    callcenter.info3;

UPDATE callcenter.info3 
SET 
    call_center = LEFT(call_center,
        LENGTH(call_center) - 3);

alter table callcenter.info3
change city_ab state_ab varchar(10);


SELECT 
    call_timestamp,
    STR_TO_DATE(call_timestamp, '%m/%d/%Y') AS formatted_call_timestamp
FROM
    callcenter.info3;
    
UPDATE callcenter.info3 
SET 
    call_timestamp = STR_TO_DATE(call_timestamp, '%m/%d/%Y');
    
SELECT 
    *
FROM
    callcenter.info3;
    
alter table callcenter.info3
modify column call_timestamp DATE;

SELECT 
    *
FROM
    callcenter.info3


### SQL File Summary

-- Data Inspection: Retrieved all data to understand its structure and content.

-- Duplicate Check: Ensured no duplicate customer names existed to maintain data integrity. 

-- CTE for Duplicates: Used a Common Table Expression (CTE) to identify and handle any duplicate rows based on multiple columns. 

-- Table Creation for Modifications: Created a new table to apply necessary changes without altering the original dataset. 

-- Handling Missing Values: Converted blank `csat_score` entries to NULL and removed those NULL entries to clean the data.

-- Additional Table Creation: Created another table to continue further modifications. 

-- New Column for Abbreviation: Added a new column for city abbreviations and transferred relevant data to this column. 

-- Data Trimming and Updates: Trimmed specific parts of the `call_center` data to standardize it and updated the new column accordingly. 

-- Final Data Adjustments: Adjusted the `call_center` column by trimming it and renamed the new column to `state_ab`.

-- Date Format Conversion: Converted `call_timestamp` from text to date format for accurate date handling and sorting. 





