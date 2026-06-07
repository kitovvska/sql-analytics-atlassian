-- ====================================================================
-- PROJECT: Atlassian Stack Data Analytics Simulation
-- AUTHOR: Kinga K.
-- DESCRIPTION: Advanced SQL scripts for extracting project management 
--              KPIs directly from Jira relational database schemas.
-- ====================================================================

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    role VARCHAR(50)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_key VARCHAR(10),
    project_name VARCHAR(100)
);

CREATE TABLE jira_issues (
    issue_id SERIAL PRIMARY KEY,
    issue_key VARCHAR(15),
    project_id INT REFERENCES projects(project_id),
    reporter_id INT REFERENCES users(user_id),
    assignee_id INT REFERENCES users(user_id),
    priority VARCHAR(20),
    status VARCHAR(30),
    created_at TIMESTAMP,
    resolved_at TIMESTAMP,
    story_points INT
);

-- KPI 1: Resolution Time SLA Analysis
SELECT 
    p.project_key,
    p.project_name,
    COUNT(i.issue_id) AS total_critical_bugs,
    ROUND(AVG(EXTRACT(EPOCH FROM (i.resolved_at - i.created_at))/86400)::numeric, 2) AS avg_resolution_days
FROM jira_issues i
JOIN projects p ON i.project_id = p.project_id
WHERE i.priority = 'Highest' AND i.status = 'Done'
GROUP BY p.project_id, p.project_key, p.project_name
ORDER BY avg_resolution_days DESC;

-- KPI 2: Team Velocity & Workload Distribution
SELECT 
    u.username,
    u.role,
    SUM(i.story_points) AS total_story_points_delivered,
    COUNT(i.issue_id) AS total_tasks_completed,
    DENSE_RANK() OVER (ORDER BY SUM(i.story_points) DESC) as velocity_rank
FROM jira_issues i
JOIN users u ON i.assignee_id = u.user_id
WHERE i.status = 'Done'
GROUP BY u.user_id, u.username, u.role;

-- KPI 3: Monthly Bottleneck Detection
WITH MonthlyStats AS (
    SELECT 
        p.project_key,
        EXTRACT(MONTH FROM i.created_at) AS report_month,
        COUNT(i.issue_id) AS current_month_volume
    FROM jira_issues i
    JOIN projects p ON i.project_id = p.project_id
    GROUP BY p.project_key, EXTRACT(MONTH FROM i.created_at)
)
SELECT 
    project_key,
    report_month,
    current_month_volume,
    LAG(current_month_volume, 1) OVER (PARTITION BY project_key ORDER BY report_month) AS previous_month_volume,
    (current_month_volume - LAG(current_month_volume, 1) OVER (PARTITION BY project_key ORDER BY report_month)) AS volume_growth
FROM MonthlyStats;
