CREATE TABLE regions(region_id INT PRIMARY KEY,
    region_name VARCHAR(100));
    
CREATE TABLE countries(country_id INT PRIMARY KEY,
    country_name VARCHAR(100),
    region_id INT);
    
CREATE TABLE locations(location_id INT PRIMARY KEY,
    street_address VARCHAR(100),
    postal_code VARCHAR(30),
    city VARCHAR(50),
    state_province VARCHAR(40),
    country_id INT);
    
CREATE TABLE departments(department_id INT PRIMARY KEY,
    department_name VARCHAR(75),
    manager_id INT,
    location_id INT);
                                              
CREATE TABLE employees(employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(15),
    hire_date DATE,
    job_id INT,
    salary NUMBER,
    commission_pct NUMBER,
    manager_id INT,
    department_id INT);
                        
CREATE TABLE jobs(job_id INT PRIMARY KEY,
    job_title VARCHAR(100),
    min_salary NUMBER,
    max_salary NUMBER);

CREATE TABLE job_history(employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id INT,
    department_id INT);
    
ALTER TABLE jobs ADD ( CONSTRAINT check_min_salary CHECK (max_salary - 2000 > min_salary));
