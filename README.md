# NSW TrainLink Patronage SQL Analysis

Real NSW Government train and coach patronage data (July 2021 – August 2026)  
analysed using Python (pandas), SQL and DB Browser for SQLite.

## Project Overview
This project analyses COVID and peak years of real NSW TrainLink data 
to explore all journeys and passenger types across train and coach 
services in regional NSW.

**Data Source:** Transport for NSW — TrainLink Patronage Dataset  
**Records:** 21,744 rows | **Period:** 2021/22 – 2026/27  
**Tools:** Python · SQL · SQLite · DB Browser

---

## Key Findings

### 1. Massive Post-COVID Recovery
Ridership more than **doubled** after COVID — from **2,085,203** trips 
in 2021/22 to **5,043,120** in 2023/24 (+142% growth).
Average trips per route also nearly doubled from 395 to 885, 
proving growth was driven by genuine demand — not just more routes.

### 2. Sydney↔Melbourne is King
The busiest train route was **Sydney → Melbourne XPT** with 
**499,380 total trips**. Sydney↔Melbourne combined (both directions) 
accounted for nearly 870,000 trips — by far the most travelled 
corridor on the TrainLink network.

### 3. Night Trains Recovered Fastest
**Melbourne → Sydney XPT Night** grew by **243%** from COVID lows, 
and Sydney → Melbourne Night by **273%** — the fastest recovering 
services on the entire network.

### 4. Coach Carries More Than People Think
Coach services account for **46% of all TrainLink trips** — 
nearly equal to trains (54%). The busiest coach route was 
**Orange ↔ Lithgow** with 67,062 trips.

### 5. Pensioners Depend on TrainLink
After Full FARE passengers (55%), pensioners and seniors represent 
**30% of all ticket types** — highlighting TrainLink's critical 
role for elderly communities in regional NSW.

### 6. Holiday Travel Drives Demand
April (Easter) is the busiest month with **2,142,118 trips**, 
followed by December (Christmas) and July (school holidays) — 
confirming TrainLink serves leisure and family travel, 
not daily commuters.

---

## SQL Queries

| # | Question | Key Finding |
|---|----------|-------------|
| 1 | Busiest train route? | Sydney→Melbourne XPT (499,380 trips) |
| 2 | Ridership by year? | Doubled post-COVID |
| 3 | Most popular ticket? | Full FARE (55%) |
| 4 | Busiest month? | April — Easter effect |
| 5 | Coach vs Train? | Train 54%, Coach 46% |
| 6 | Busiest coach route? | Orange↔Lithgow (67,062 trips) |
| 7 | COVID recovery by route? | Night trains grew 243-273% |
| 8 | Avg trips per route/year? | Peak 885 vs COVID low 395 |

---

## Files
- `trainlink_analysis.sql` — all 8 SQL queries with comments
- `trainlink_journeys.csv` — cleaned long-format journey data
- `passenger_type.csv` — cleaned passenger type data
- `data_cleaning.py` — Python script used to reshape Excel to CSV

---

## Data Cleaning
Original data was in **wide format** (months as column headers).  
Python pandas was used to reshape to **long format** for SQL analysis.  
Privacy codes (values 1–10) replaced with midpoint value of 5.
