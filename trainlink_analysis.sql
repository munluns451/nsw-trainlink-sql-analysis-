{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- ================================================\
-- NSW TrainLink Patronage SQL Analysis\
-- Author: Munna Naharki\
-- Data: Transport for NSW (Jul 2021 - Aug 2026)\
-- Tool: SQLite / DB Browser\
-- ================================================\
\
\
-- QUERY 1: Which train route has the most total passengers?\
SELECT service_description,\
       SUM(trips) AS total_trips\
FROM trainlink_journeys\
WHERE transport_type = 'Train'\
AND service_description IS NOT NULL\
GROUP BY service_description\
ORDER BY total_trips DESC\
LIMIT 10;\
-- Finding: Sydney\uc0\u8594 Melbourne XPT is busiest with 499,380 trips\
\
\
-- QUERY 2: How has total ridership changed year by year?\
SELECT financial_year,\
       SUM(trips) AS total_trips\
FROM trainlink_journeys\
WHERE trips IS NOT NULL\
GROUP BY financial_year\
ORDER BY financial_year;\
-- Finding: Ridership doubled from 2,085,203 (2021/22) to 5,043,120 (2023/24)\
\
\
-- QUERY 3: Which ticket type is most popular?\
SELECT ticket_type,\
       SUM(trips) AS total_trips\
FROM passenger_type\
WHERE ticket_type != 'Grand Total'\
GROUP BY ticket_type\
ORDER BY total_trips DESC;\
-- Finding: Full FARE dominates at 55%, pensioners/seniors = 30%\
\
\
-- QUERY 4: Which month is the busiest?\
SELECT month,\
       SUM(trips) AS total_trips\
FROM trainlink_journeys\
WHERE trips IS NOT NULL\
GROUP BY month\
ORDER BY total_trips DESC;\
-- Finding: April (Easter) is busiest with 2,142,118 trips\
\
\
-- QUERY 5: Coach vs Train - which carries more passengers?\
SELECT transport_type,\
       SUM(trips) AS total_trips\
FROM trainlink_journeys\
WHERE trips IS NOT NULL\
GROUP BY transport_type;\
-- Finding: Train 54% vs Coach 46% - coaches carry more than expected\
\
\
-- QUERY 6: Which is the busiest coach route?\
SELECT service_description,\
       SUM(trips) AS total_trips\
FROM trainlink_journeys\
WHERE transport_type = 'Coach'\
AND trips IS NOT NULL\
AND service_description IS NOT NULL\
GROUP BY service_description\
ORDER BY total_trips DESC\
LIMIT 10;\
-- Finding: Orange\uc0\u8596 Lithgow is busiest coach corridor (67,062 trips)\
\
\
-- QUERY 7: COVID Recovery by Route (CASE WHEN)\
-- Compares 2021/22 (COVID) vs 2023/24 (peak recovery)\
SELECT service_description,\
       SUM(CASE WHEN financial_year = '2021/22' THEN trips ELSE 0 END) AS covid_year,\
       SUM(CASE WHEN financial_year = '2023/24' THEN trips ELSE 0 END) AS peak_year,\
       ROUND((SUM(CASE WHEN financial_year = '2023/24' THEN trips ELSE 0 END) -\
              SUM(CASE WHEN financial_year = '2021/22' THEN trips ELSE 0 END)) * 100.0 /\
              NULLIF(SUM(CASE WHEN financial_year = '2021/22' THEN trips ELSE 0 END), 0), 1) AS growth_pct\
FROM trainlink_journeys\
WHERE transport_type = 'Train'\
AND service_description IS NOT NULL\
GROUP BY service_description\
ORDER BY peak_year DESC;\
-- Finding: Night trains recovered fastest - Melbourne\uc0\u8596 Sydney Night grew 243%\
\
\
-- QUERY 8: Average trips per route per year\
-- Smarter than total - shows genuine demand growth per route\
SELECT financial_year,\
       ROUND(AVG(trips), 0) AS avg_trips_per_route\
FROM trainlink_journeys\
WHERE trips IS NOT NULL\
AND service_description IS NOT NULL\
GROUP BY financial_year\
ORDER BY avg_trips_per_route DESC;\
-- Finding: Average nearly doubled from 395 (COVID) to 885 (peak 2023/24)}