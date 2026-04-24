# Architecture Overview

## System Design

Single-table design with a React frontend and Rails API backend.

## Key Decisions

### 1. Single employees table (no compensations table)
Assessment requires current salary only. A separate compensations table
would add join complexity for no benefit at this scope.
History tracking can be added in v2 via a compensations table.
NOTE: we are not doing it 

### 2. Service objects for insights
Business logic lives in `app/services/insights/salary_stats_service.rb`.
Controllers only handle HTTP — thin controllers, fat services.

### 3. Bulk insert for seed script
Used `insert_all` with batches of 1000 to seed 10k employees.
Avoids ActiveRecord instantiation overhead. Completes in under 10 seconds.
Performance: with batches it takes only 0.6700 seconds 

### 4. Kaminari for pagination
10k employees cannot be returned in a single API response.
Default 20 per page with total_count, current_page, total_pages in meta.

### 5. Indexed columns
country, department, job_title, email — all indexed for fast insight queries.

## Tech Stack

| Layer    | Technology                  |
|----------|-----------------------------|
| Backend  | Ruby on Rails 7.2 (API mode)|
| Database | PostgreSQL                  |
| Testing  | RSpec, FactoryBot, Faker    |

## API Endpoints

### Employees
GET    /api/v1/employees          paginated list
GET    /api/v1/employees/:id      single employee
POST   /api/v1/employees          create
PATCH  /api/v1/employees/:id      update
DELETE /api/v1/employees/:id      delete

### Insights
GET /api/v1/insights/salary_by_country    min, max, avg, count by country
GET /api/v1/insights/salary_by_job_title  avg, count by job title in country

### Key Points
- As per the given scope we only build this app with one table.
- Insights are also under given scope 
- We can add (by department) insights as well.