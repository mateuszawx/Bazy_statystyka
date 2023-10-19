SELECT last_name AS nazwisko, salary AS wynagrodzenie
FROM employees
WHERE department_id IN (20, 50)
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;



SELECT hire_date AS data_zatrudnienia, last_name AS nazwisko, salary AS wybrana_kolumna
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE EXTRACT(YEAR FROM hire_date) = 2005
)
ORDER BY last_name;



SELECT first_name || ' ' || last_name AS imie_i_nazwisko, salary AS zarobki, phone_number AS numer_telefonu
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e'
AND SUBSTR(first_name, 1, 2) = 'Na'
ORDER BY imie_i_nazwisko DESC, zarobki ASC;



SELECT first_name AS imie, last_name AS nazwisko,
  ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS liczba_miesiecy,
  CASE
    WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) <= 150 THEN salary * 0.10
    WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) <= 200 THEN salary * 0.20
    ELSE salary * 0.30
  END AS wysokosc_dodatku
FROM employees
ORDER BY liczba_miesiecy;



SELECT e.department_id AS numer_dzialu,
       SUM(e.salary) AS suma_zarobkow,
       ROUND(AVG(e.salary)) AS srednia_zarobkow
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
WHERE j.min_salary > 5000
GROUP BY e.department_id
HAVING MIN(j.min_salary) > 5000;



SELECT e.LAST_NAME, e.department_id, d.department_name, e.job_id
FROM Employees e
INNER JOIN Departments d ON e.department_id = d.department_id
INNER JOIN Locations l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';



SELECT e1.first_name AS imie_pracownika, e1.last_name AS nazwisko_pracownika, e2.first_name AS imie_wspolpracownika, e2.last_name AS nazwisko_wspolpracownika
FROM employees e1
INNER JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.first_name = 'Jennifer'
AND e1.employee_id != e2.employee_id;



SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.department_id IS NULL;



SELECT e.First_Name || ' ' || e.Last_Name AS Imie_i_Nazwisko,
       dep.Department_name AS Nazwa_Departamentu,
       e.salary AS Zarobki,
       (
           SELECT jg.Grade
           FROM JOB_GRADES jg
           WHERE e.salary BETWEEN jg.min_salary AND jg.max_salary
       ) AS Grade
FROM employees e
JOIN departments dep ON e.department_id = dep.department_id
ORDER BY e.salary;



SELECT e.First_Name, e.Last_Name, e.Salary
FROM employees e
WHERE e.Salary > (SELECT AVG(Salary) FROM employees)
ORDER BY e.Salary DESC;



SELECT e.Employee_ID, e.First_Name, e.Last_Name
FROM employees e
WHERE e.Department_ID IN (
    SELECT Department_ID
    FROM employees
    WHERE Last_Name LIKE '%u%'
);




