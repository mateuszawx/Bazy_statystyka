CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(60)
);

CREATE TABLE countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100),
    region_id INT,
    CONSTRAINT FK_countries_region_id FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    street_address VARCHAR(75),
    postal_code VARCHAR(20),
    city VARCHAR(50),
    state_province VARCHAR(40),
    country_id INT,
    CONSTRAINT FK_locations_country_id FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id INT,
    salary NUMBER,
    commission_pct NUMBER,
    manager_id INT,
    department_id INT,
    CONSTRAINT FK_employees_department_id FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT FK_employees_job_id FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    CONSTRAINT FK_employees_manager_id FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(75),
    manager_id INT,
    location_id INT,
    CONSTRAINT FK_departments_location_id FOREIGN KEY (location_id) REFERENCES locations(location_id),
    CONSTRAINT FK_departments_manager_id FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE jobs (
    job_id INT PRIMARY KEY,
    job_title VARCHAR(100),
    min_salary NUMBER,
    max_salary NUMBER,
    CHECK (max_salary - 2000 > min_salary)
);

CREATE TABLE job_history (
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id INT,
    department_id INT,
    CONSTRAINT PK_job_history PRIMARY KEY (employee_id, start_date),
    CONSTRAINT FK_job_history_job_id FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    CONSTRAINT FK_job_history_employee_id FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT FK_job_history_department_id FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

SELECT CONCAT(last_name, ', ', salary) AS Last_name_and_salary
FROM employees
WHERE (department_id = 20 OR department_id = 50) AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;
