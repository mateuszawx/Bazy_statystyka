--ZAD 1
-- 1
CREATE OR REPLACE FUNCTION GetJobName(job_id_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_job_name VARCHAR2(50);
BEGIN
    SELECT job_title INTO v_job_name FROM jobs WHERE job_id = job_id_param;
    
    IF v_job_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Praca o podanym ID nie istnieje');
    END IF;

    RETURN v_job_name;
END GetJobName;

SET SERVEROUTPUT ON;
DECLARE
    v_job_title VARCHAR2(50);
BEGIN
    v_job_title := GetJobName('AD_VP');
    DBMS_OUTPUT.PUT_LINE('Nazwa pracy: ' || v_job_title);
END;

--ZAD 1
-- 2
CREATE OR REPLACE FUNCTION AnnualEarnings(employee_id_param IN NUMBER) RETURN NUMBER
IS
    v_annual_earnings NUMBER;
BEGIN
    SELECT (salary * 12) + NVL((salary * 12 * commission_pct), 0)
    INTO v_annual_earnings
    FROM employees
    WHERE employee_id = employee_id_param;

    RETURN v_annual_earnings;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Pracownik o podanym ID nie istnieje');
END AnnualEarnings;

SET SERVEROUTPUT ON;
DECLARE
    v_earnings NUMBER;
BEGIN
    v_earnings := AnnualEarnings(115); -- Przyk�adowe ID pracownika
    DBMS_OUTPUT.PUT_LINE('Roczne zarobki pracownika: ' || v_earnings);
END;
/

--ZAD 1
-- 3
CREATE OR REPLACE FUNCTION ExtractAreaCode(phone_number_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_area_code VARCHAR2(10);
BEGIN
    -- Wyodr�bnij numer kierunkowy z numeru telefonu (pierwsze trzy znaki)
    v_area_code := SUBSTR(phone_number_param, 1, 3);
    
    RETURN v_area_code;
END ExtractAreaCode;

DECLARE
    v_area_code VARCHAR2(10);
BEGIN
    v_area_code := ExtractAreaCode('590.423.4569'); -- Przyk�adowy numer telefonu
    DBMS_OUTPUT.PUT_LINE('Numer kierunkowy: ' || v_area_code);
END;
/
SELECT phone_number FROM employees

--ZAD 1
-- 4
CREATE OR REPLACE FUNCTION ChangeCase(input_string_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_result_string VARCHAR2(4000);
BEGIN
    -- Konwertuj ca�y ci�g na ma�e litery
    v_result_string := LOWER(input_string_param);
    
    -- Zmie� pierwsz� liter� na wielk�
    v_result_string := INITCAP(v_result_string);
    
    -- Zmie� ostatni� liter� na wielk�
    v_result_string := SUBSTR(v_result_string, 1, LENGTH(v_result_string) - 1) || UPPER(SUBSTR(v_result_string, -1));
    
    RETURN v_result_string;
END ChangeCase;

DECLARE
    v_result VARCHAR2(4000);
BEGIN
    v_result := ChangeCase('aAAAAAAAa'); -- Przyk�adowy ci�g znak�w
    DBMS_OUTPUT.PUT_LINE('Wynik: ' || v_result);
END;
/

--ZAD 1
-- 5
CREATE OR REPLACE FUNCTION PeselToDate(pesel_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_year NUMBER;
    v_month NUMBER;
    v_day NUMBER;
BEGIN
    IF LENGTH(pesel_param) <> 11 THEN
        RETURN 'Nieprawid�owy PESEL';
    END IF;
    
    v_year := TO_NUMBER(SUBSTR(pesel_param, 1, 2));
    v_month := TO_NUMBER(SUBSTR(pesel_param, 3, 2));
    v_day := TO_NUMBER(SUBSTR(pesel_param, 5, 2));

    IF v_month > 20 THEN
        v_month := v_month - 20;
        v_year := v_year + 2000;
    ELSE
        v_year := v_year + 1900;
    END IF;

    RETURN TO_CHAR(TO_DATE(v_year || '-' || v_month || '-' || v_day, 'YYYY-MM-DD'), 'YYYY-MM-DD');
END PeselToDate;

DECLARE
    v_date_of_birth VARCHAR2(10);
BEGIN
    v_date_of_birth := PeselToDate('89012512345'); -- Przyk�adowy numer PESEL
    DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || v_date_of_birth);
END;
/


--ZAD 1
-- 6
CREATE OR REPLACE FUNCTION CountEmployeesAndDepartmentsInCountry(country_name_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_employee_count NUMBER;
    v_department_count NUMBER;
BEGIN
    -- Zlicz pracowników w danym kraju
    SELECT COUNT(*) INTO v_employee_count
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = country_name_param;

    -- Zlicz departamenty w danym kraju
    SELECT COUNT(*) INTO v_department_count
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = country_name_param;

    IF v_employee_count = 0 AND v_department_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak danych dla podanego kraju');
    END IF;

    RETURN 'Liczba pracowników: ' || TO_CHAR(v_employee_count) || ', Liczba departamentów: ' || TO_CHAR(v_department_count);
END CountEmployeesAndDepartmentsInCountry;


SET SERVEROUTPUT ON;
DECLARE
    v_count_info VARCHAR2(100);
BEGIN
    v_count_info := CountEmployeesAndDepartmentsInCountry('United Kingdom'); -- Zmień kraj na dowolny, dla którego istnieją dane w bazie.
    DBMS_OUTPUT.PUT_LINE(v_count_info);
END;

DECLARE
    v_count_info VARCHAR2(100);
BEGIN
    v_count_info := CountEmployeesAndDepartmentsInCountry('United States of America'); -- Zmień kraj na dowolny, dla którego istnieją dane w bazie.
    DBMS_OUTPUT.PUT_LINE(v_count_info);
END;



-- ZAD2
--1
CREATE TABLE archiwum_departamentow (
    id NUMBER,
    nazwa VARCHAR2(50),
    data_zamkniecia DATE,
    ostatni_manager VARCHAR2(50)
);

CREATE SEQUENCE seq_department_archive START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER department_archive
AFTER DELETE ON departments
FOR EACH ROW
DECLARE
    v_id NUMBER;
BEGIN
    -- Pobranie kolejnej wartości z sekwencji
    SELECT seq_department_archive.NEXTVAL INTO v_id FROM dual;

    -- Dodanie rekordu do archiwum_departamentow
    INSERT INTO archiwum_departamentow (id, nazwa, data_zamkniecia, ostatni_manager)
    VALUES (v_id, :old.department_name, SYSDATE, :old.manager_id);
END department_archive;

CREATE SEQUENCE seq_departments
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;


-- TEST1
INSERT INTO departments (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (seq_departments.NEXTVAL, 'Nowy Departament 1', '103', '1700');

-- TEST2
INSERT INTO departments (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (seq_departments.NEXTVAL, 'Nowy Departament 2 test', '100', '1700');

-- Jeszcze jeden dla pewności
INSERT INTO departments (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (seq_departments.NEXTVAL, 'UWU', '205', '2500');

DELETE FROM departments WHERE department_id = 4;
SELECT * FROM archiwum_departamentow;
SELECT seq_department_archive.CURRVAL FROM dual;





-- ZAD2
--2
CREATE TABLE zlodziej (
    id NUMBER PRIMARY KEY,
    username VARCHAR2(50),
    czas_zmiany TIMESTAMP
);

CREATE SEQUENCE sequence_zlodziej;

CREATE OR REPLACE TRIGGER TRIGGER_CHECK_SALARY_RANGE
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
DECLARE
    v_min_salary NUMBER := 2000;
    v_max_salary NUMBER := 26000;
BEGIN
    IF :NEW.salary < v_min_salary OR :NEW.salary > v_max_salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'Zarobki muszą się mieścić w widełkach ' || v_min_salary || ' - ' || v_max_salary);
    ELSE
        INSERT INTO zlodziej (id, username, czas_zmiany)
        VALUES (sequence_zlodziej.NEXTVAL, USER, SYSTIMESTAMP);
    END IF;
END;
/

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, job_id)
VALUES (sequence_zlodziej.NEXTVAL, 'Diego', 'Maradona', 'diego@example.com', TO_DATE('2023-11-07', 'YYYY-MM-DD'), 15000, 'SA_REP');

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, job_id)
VALUES (sequence_zlodziej.NEXTVAL, 'Roberto', 'Carlos', 'roberto@example.com', TO_DATE('2023-11-05', 'YYYY-MM-DD'), 1000, 'SH_CLERK');

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, job_id)
VALUES (sequence_zlodziej.NEXTVAL, 'Roberto', 'Carlos', 'roberto@example.com', TO_DATE('2023-11-05', 'YYYY-MM-DD'), 27000, 'SH_CLERK');

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, job_id)
VALUES (sequence_zlodziej.NEXTVAL, 'Stefan', 'Bąk', 'stefan@example.com', TO_DATE('2023-11-08', 'YYYY-MM-DD'), 77000, 'ST_MAN');

UPDATE employees SET salary = 18000 WHERE employee_id = 207;
UPDATE employees SET salary = 30000 WHERE employee_id = 208;
UPDATE employees SET salary = 1000 WHERE employee_id = 15;
SELECT * FROM zlodziej;
--Działa ale czy dobrze to nie wiem

--ZAD2
--3
CREATE SEQUENCE sequence_employees
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRIGGER_AUTO_INCREMENT_EMPLOYEES
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF :NEW.employee_id IS NULL THEN
        SELECT sequence_employees.NEXTVAL INTO :NEW.employee_id FROM DUAL;
    END IF;
END;
/

INSERT INTO employees (first_name, last_name, email, hire_date, job_id, salary)
VALUES ('John', 'Doe', 'john.doe@example.com', TO_DATE('2023-08-23', 'YYYY-MM-DD'), 'IT_PROG', 5000);
SELECT * FROM employees WHERE last_name = 'Doe';
-- Dostał employee_id = 1 więc chyba działa 

--ZAD2
--4
CREATE OR REPLACE TRIGGER Trigger_Prevent_Job_Grades_Update
BEFORE UPDATE ON JOB_GRADES
BEGIN
  RAISE_APPLICATION_ERROR(-20001, 'Aktualizacja tabeli JOB_GRADES jest zabroniona.');
END;
/
UPDATE JOB_GRADES SET MIN_SALARY = 3000 WHERE GRADE = 'A';
--INSERT INTO JOB_GRADES (GRADE, MIN_SALARY, MAX_SALARY) VALUES ('X', 69000, 82000);
--DELETE FROM JOB_GRADES WHERE GRADE = 'X';


-- ZAD2
--5
CREATE OR REPLACE TRIGGER Trigger_Preserve_Jobs_Salary
BEFORE UPDATE ON jobs
FOR EACH ROW
BEGIN
    IF :NEW.min_salary <> :OLD.min_salary OR :NEW.max_salary <> :OLD.max_salary THEN
        :NEW.min_salary := :OLD.min_salary;
        :NEW.max_salary := :OLD.max_salary;
    END IF;
END;
/
UPDATE jobs
SET min_salary = 4000
WHERE job_id = 'AD_PRES';

SELECT job_id, job_title, min_salary, max_salary
FROM jobs
WHERE job_id = 'AD_PRES';


-- ZAD3
--1


