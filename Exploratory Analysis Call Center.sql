-- Exploratory Analysis of the Call Centre Data

use callcenter;

SELECT *
FROM callcenter.info3;

-- Checking if there are any customers who called more than once (none found).
select distinct id
from callcenter.info3;

-- Analysing sentiment distribution (Most calls exhibit negative sentiment).

select sentiment, count(id) as totals
from callcenter.info3
group by sentiment
order by totals desc;

-- Calculating average CSAT score.

select avg(csat_score) as avg_csat_score
from callcenter.info3;

-- Determining main reasons for calls.
select reason, count(id) as totals
from callcenter.info3
group by reason
order by totals desc;

select * 
from callcenter.info3;

-- Identifying top 3 days with the highest call volume.
select distinct day(call_timestamp) as Day, count(id) as no_of_calls
from callcenter.info3
group by Day
order by no_of_calls desc
limit 3;

-- Checking for a lower count of calls below SLA (yes, there is).
WITH info_cte2 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY call_center, channel, response_time, reason ORDER BY call_center) AS row_num
    FROM callcenter.info3
)
SELECT count(id) as count
FROM info_cte2
where response_time = 'Below SLA' AND csat_score <= 5;

-- Checking for a higher count of calls Above and Within SLA (yes, there is).
WITH info_cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY call_center, channel, response_time, reason ORDER BY call_center) AS row_num
    FROM callcenter.info3
)
SELECT count(id) as count
FROM info_cte
where response_time IN ('Above SLA', 'Within SLA') AND csat_score > 5;

-- Analysing distribution of CSAT scores.
SELECT csat_score, COUNT(id) as count
FROM callcenter.info3
GROUP BY csat_score
ORDER BY CAST(csat_score AS UNSIGNED) ASC;

-- Assessing the impact of higher CSAT scores.
with csat_cte as (
SELECT csat_score, COUNT(id) as count
FROM callcenter.info3
GROUP BY csat_score
ORDER BY CAST(csat_score AS UNSIGNED) ASC)
select * from csat_cte
where csat_score > 5

