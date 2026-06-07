# Atlassian Stack Data Analytics 

A repository containing advanced, business-driven SQL scripts designed to simulate data analysis over Atlassian Jira relational database schemas. The project showcases the ability to transform raw issue-tracking records into actionable project management KPIs.

## Analyzed KPIs & Metrics

### 1. Resolution Time SLA Analysis
* **Technical Highlights:** `JOIN`, `ROUND`, `AVG`, `EXTRACT(EPOCH)`
* **Business Value:** Tracks the average time (in days) required to resolve 'Highest' priority bottlenecks. Helps teams monitor Service Level Agreements (SLAs) and detect underperforming project areas.

### 2. Team Velocity & Workload Distribution
* **Technical Highlights:** `SUM`, `COUNT`, `DENSE_RANK() OVER()`
* **Business Value:** Evaluates individual resource throughput by aggregating delivered Story Points. The inclusion of analytical window ranking (`DENSE_RANK`) allows management to identify top performers and balance team allocation during Agile sprints.

### 3. Monthly Bottleneck Detection Trend
* **Technical Highlights:** Common Table Expressions (`WITH`), Window Function (`LAG`)
* **Business Value:** Performs time-series analysis by comparing the volume of newly incoming tickets between the current and preceding months. Essential for predictive scaling and identifying seasonal workflow anomalies.

## Technology Stack
* **Database Dialect:** PostgreSQL (ANSI SQL Compliant)
* **Concepts Demonstrated:** Window Functions, Analytical Ranking, CTEs, Datetime Arithmetic, Relational Integrity.
