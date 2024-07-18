-- Exploratory Analysis of the Call Centre Data

use callcenter;

-- Checking the dataset

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
select * from csat_cte
where csat_score > 5;

-- Percentage of sentiment for each channel.

select sentiment, channel,
   ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY channel)), 2) AS pct
FROM
callcenter.info3
GROUP BY
    channel, sentiment
ORDER BY
    channel, pct DESC;


-- Identifying the day with the highest call volume (Friday).

SELECT 
    Day, no_of_calls
FROM
    (SELECT 
        DATE_FORMAT(call_timestamp, '%W') AS Day,
            COUNT(id) AS no_of_calls
    FROM
        callcenter.info3
    GROUP BY DATE_FORMAT(call_timestamp, '%W')) AS subquery
ORDER BY FIELD(Day,
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday');

-- Finding the earliest and latest dates.

SELECT 
    MIN(call_timestamp) AS min_date,
    MAX(call_timestamp) AS max_date
FROM
    callcenter.info3;

-- Calculating average call duration for each center.

SELECT 
    channel,
    ROUND(AVG(`call duration in minutes`), 2) AS avg_call_duration
FROM
    callcenter.info3
GROUP BY channel;

-- Calculating average call duration and customer satisfaction by state.

SELECT 
    state,
    ROUND(AVG(`call duration in minutes`), 2) AS avg_duration,
    ROUND(AVG(csat_score), 2) AS avg_score
FROM
    callcenter.info3
GROUP BY state
ORDER BY avg_duration DESC
