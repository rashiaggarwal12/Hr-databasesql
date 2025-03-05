-- Drop tables if they already exist (for resetting the database)
-- DROP TABLE IF EXISTS job_history;
-- DROP TABLE IF EXISTS employees;
-- DROP TABLE IF EXISTS jobs;
-- DROP TABLE IF EXISTS departments;
-- DROP TABLE IF EXISTS locations;

CREATE DATABASE HR_Database;
USE HR_Database;

-- Creating the jobs table
CREATE TABLE jobs (
    job_id VARCHAR(10) PRIMARY KEY,
    job_title VARCHAR(50),
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2)
);

-- Creating the locations table
CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    state_province VARCHAR(50),
    country VARCHAR(50)
);

-- Creating the departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Creating the employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(10),
    salary DECIMAL(10,2),
    commission_pct DECIMAL(5,2),
    manager_id INT,
    department_id INT,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Creating the job history table
CREATE TABLE job_history (
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(10),
    department_id INT,
    PRIMARY KEY (employee_id, start_date),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Inserting sample data into jobs
INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES
('J001', 'Software Engineer', 4000, 9000),
('J002', 'Manager', 6000, 12000),
('J003', 'HR Specialist', 3500, 7000),
('J004', 'Sales Representative', 3000, 6000);

-- Inserting sample data into locations
INSERT INTO locations (location_id, city, state_province, country) VALUES
(1, 'New York', 'NY', 'USA'),
(2, 'Los Angeles', 'CA', 'USA'),
(3, 'Chicago', 'IL', 'USA');

-- Inserting sample data into departments
INSERT INTO departments (department_id, department_name, location_id) VALUES
(10, 'Engineering', 1),
(20, 'Human Resources', 2),
(30, 'Sales', 3);

-- Inserting sample data into employees
INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES
('Alice', 'Johnson', 'alice.johnson@email.com', '123-456-7890', '2018-06-15', 'J001', 7500, NULL, NULL, 10),
('Bob', 'Smith', 'bob.smith@email.com', '234-567-8901', '2016-09-10', 'J002', 11000, NULL, NULL, 10),
('Charlie', 'Brown', 'charlie.brown@email.com', '345-678-9012', '2019-03-22', 'J003', 5000, NULL, 2, 20),
('Diana', 'Garcia', 'diana.garcia@email.com', '456-789-0123', '2021-07-01', 'J004', 4200, 0.05, 2, 30),
('Ethan', 'Wright', 'ethan.wright@email.com', '567-890-1234', '2017-11-15', 'J001', 8300, NULL, 1, 10),
('Fiona', 'Adams', 'fiona.adams@email.com', '678-901-2345', '2015-12-01', 'J002', 9700, NULL, 2, 10);

-- Inserting sample data into job_history
INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id) VALUES
(1, '2015-01-01', '2018-06-14', 'J003', 20),
(3, '2017-05-10', '2019-03-21', 'J004', 30),
(5, '2014-02-20', '2017-11-14', 'J002', 10);

-- Fundamentals of Structured Query Language - 1

-- 1. Retrieve all details of employees.
SELECT * FROM employees;

-- 2. Display the first name, last name, and email of all employees.
SELECT first_name, last_name, email FROM employees;

-- 3. Retrieve the distinct job titles from the jobs table.
SELECT DISTINCT job_title FROM jobs;

-- 4. Find the total number of employees in the company.
SELECT COUNT(*) AS total_employees FROM employees;

-- 5. Retrieve the employees who were hired after January 1, 2015.
SELECT * FROM employees WHERE hire_date > '2015-01-01';

-- Fundamentals of Structured Query Language - 2

-- 6. List all employees who have a salary greater than 5000.
SELECT * FROM employees WHERE salary > 5000;

-- 7. Retrieve employees with job titles containing the word ‘Manager.’
SELECT e.employee_id, e.first_name, e.last_name, j.job_title
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE j.job_title LIKE '%Manager%';

-- 8. Retrieve all employees whose first name starts with ‘A’ and ends with ‘n.’
SELECT * FROM employees WHERE first_name LIKE 'A%n';

-- 9. Display the employees who do not have a commission.
SELECT * FROM employees WHERE commission_pct IS NULL OR commission_pct = 0;

-- 10. Retrieve the top 5 highest-paid employees.
SELECT * FROM employees ORDER BY salary DESC LIMIT 5;

-- SQL Functions

-- 11. Find the average salary of all employees.
SELECT AVG(salary) AS avg_salary FROM employees;

-- 12. Retrieve the total number of employees working in each department.
SELECT department_id, COUNT(*) AS total_employees FROM employees GROUP BY department_id;

-- 13. Display the employee's first name and the length of their first name.
SELECT first_name, LENGTH(first_name) AS name_length FROM employees;

-- 14. Convert the hire_date of employees to display only the year.
SELECT first_name, last_name, YEAR(hire_date) AS hire_year FROM employees;

-- 15. Retrieve the minimum and maximum salary for each job title.
SELECT job_id, MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees GROUP BY job_id;

-- SQL Tables, Joins

-- 16. Retrieve the employee names along with their department names.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 17. List the employees along with their job titles and the location of their department.
SELECT e.first_name, e.last_name, j.job_title, l.city, l.state_province
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

-- 18. Retrieve the department names along with the count of employees in each department.
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 19. Find employees who have the same job as their manager.
SELECT e.first_name, e.last_name, e.job_id
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.job_id = m.job_id;

-- 20. Display the names of employees who worked in different jobs in the past (use job_history).
SELECT e.first_name, e.last_name, jh.job_id
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE jh.job_id <> e.job_id;
