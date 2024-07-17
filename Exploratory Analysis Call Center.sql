-- Exploratory Analysis of the Call Centre Data

use callcenter;

SELECT 
    *
FROM
    callcenter.info3;

-- Checking if there are any customers who called more than once (none found).
SELECT DISTINCT
    id
FROM
    callcenter.info3;

-- Analysing sentiment distribution (Most calls exhibit negative sentiment).

SELECT 
    sentiment, COUNT(id) AS totals
FROM
    callcenter.info3
GROUP BY sentiment
ORDER BY totals DESC;

-- Calculating average CSAT score.

SELECT 
    AVG(csat_score) AS avg_csat_score
FROM
    callcenter.info3;

-- Determining main reasons for calls.
SELECT 
    reason, COUNT(id) AS totals
FROM
    callcenter.info3
GROUP BY reason
ORDER BY totals DESC;

SELECT 
    *
FROM
    callcenter.info3;

-- Identifying top 3 days with the highest call volume.
SELECT DISTINCT
    DAY(call_timestamp) AS Day, COUNT(id) AS no_of_calls
FROM
    callcenter.info3
GROUP BY Day
ORDER BY no_of_calls DESC
LIMIT 3;

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
SELECT 
    csat_score, COUNT(id) AS count
FROM
    callcenter.info3
GROUP BY csat_score
ORDER BY CAST(csat_score AS UNSIGNED) ASC;

-- Assessing the impact of higher CSAT scores.
WITH csat_cte as (
SELECT csat_score, COUNT(id) as count
FROM callcenter.info3
GROUP BY csat_score
ORDER BY CAST(csat_score AS UNSIGNED) ASC)
SELECT * 
FROM csat_cte
WHERE csat_score > 5

