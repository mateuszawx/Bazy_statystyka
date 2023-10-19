/*CREATE TABLE regions AS (SELECT * FROM "HR"."REGIONS")
CREATE TABLE countries AS (SELECT * FROM "HR"."COUNTRIES");
CREATE TABLE locations AS (SELECT * FROM "HR"."LOCATIONS");
CREATE TABLE jobs AS (SELECT * FROM "HR"."JOBS");
CREATE TABLE departments AS (SELECT * FROM "HR"."DEPARTMENTS");
CREATE TABLE employees AS (SELECT * FROM "HR"."EMPLOYEES");
CREATE TABLE job_history AS (SELECT * FROM "HR"."JOB_HISTORY");
CREATE TABLE job_grades AS (SELECT * FROM "HR"."JOB_GRADES");*/


ALTER TABLE job_grades
ADD CONSTRAINT pk_job_grades PRIMARY KEY (grade);

ALTER TABLE regions
ADD CONSTRAINT pk_regions PRIMARY KEY (region_id);

ALTER TABLE countries
ADD CONSTRAINT pk_countries PRIMARY KEY (country_id);

ALTER TABLE countries
ADD CONSTRAINT fk_countries_region FOREIGN KEY (region_id) REFERENCES regions(region_id);

ALTER TABLE locations
ADD CONSTRAINT pk_locations PRIMARY KEY (location_id);

ALTER TABLE locations
ADD CONSTRAINT fk_locations_country FOREIGN KEY (country_id) REFERENCES countries(country_id);

ALTER TABLE jobs
ADD CONSTRAINT pk_jobs PRIMARY KEY (job_id);

ALTER TABLE jobs
ADD CONSTRAINT chk_jobs_salary CHECK (max_salary - min_salary >= 2000);

ALTER TABLE departments
ADD CONSTRAINT pk_departments PRIMARY KEY (department_id);

ALTER TABLE departments
ADD CONSTRAINT fk_departments_location FOREIGN KEY (location_id) REFERENCES locations(location_id);

ALTER TABLE employees
ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);

ALTER TABLE employees
ADD CONSTRAINT fk_employees_job FOREIGN KEY (job_id) REFERENCES jobs(job_id);

ALTER TABLE job_history
ADD CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date);

ALTER TABLE job_history
ADD CONSTRAINT fk_job_history_department FOREIGN KEY (department_id) REFERENCES departments(department_id);

ALTER TABLE job_history
ADD CONSTRAINT fk_job_history_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE job_history
ADD CONSTRAINT fk_job_history_job FOREIGN KEY (job_id) REFERENCES jobs(job_id);

ALTER TABLE departments
ADD CONSTRAINT fk_departments_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

ALTER TABLE employees
ADD CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

ALTER TABLE employees
ADD CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES departments(department_id);


