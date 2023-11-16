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
/


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
    v_earnings := AnnualEarnings(115); -- Przyk?adowe ID pracownika
    DBMS_OUTPUT.PUT_LINE('Roczne zarobki pracownika: ' || v_earnings);
END;
/

--ZAD 1
-- 3
CREATE OR REPLACE FUNCTION ExtractAreaCode(phone_number_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_area_code VARCHAR2(10);
BEGIN
    -- Wyodr?bnij numer kierunkowy z numeru telefonu (pierwsze trzy znaki)
    v_area_code := SUBSTR(phone_number_param, 1, 3);
    
    RETURN v_area_code;
END ExtractAreaCode;

DECLARE
    v_area_code VARCHAR2(10);
BEGIN
    v_area_code := ExtractAreaCode('590.423.4569'); -- Przyk?adowy numer telefonu
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
    -- Konwertuj cały ciąg na małe litery
    v_result_string := LOWER(input_string_param);
    
    -- Zmień pierwszą literę na wielką
    v_result_string := INITCAP(v_result_string);
    
    -- Zmień ostatnią literę na wielką
    v_result_string := SUBSTR(v_result_string, 1, LENGTH(v_result_string) - 1) || UPPER(SUBSTR(v_result_string, -1));
    
    RETURN v_result_string;
END ChangeCase;

DECLARE
    v_result VARCHAR2(4000);
BEGIN
    v_result := ChangeCase('aAAAAAAAa'); -- Przykładowy ciąg znaków
    DBMS_OUTPUT.PUT_LINE('Wynik: ' || v_result);
END;
/


DECLARE
    v_result VARCHAR2(4000);
BEGIN
    v_result := ChangeCase('aAAAAAAAa'); -- Przyk?adowy ci?g znak?w
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
        RETURN 'Nieprawid?owy PESEL';
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
    v_date_of_birth := PeselToDate('89012512345'); -- Przyk?adowy numer PESEL
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
CREATE OR REPLACE PACKAGE Paczka_1 AS
    PROCEDURE AddJob(
        p_job_id IN jobs.job_id%TYPE,
        p_job_title IN jobs.job_title%TYPE
    );

    PROCEDURE EditJobTitle(
        p_JOB_id JOBS.job_id%TYPE,
        p_JOB_title JOBS.job_title%TYPE
    );

    PROCEDURE DeleteJob(
        p_job_id JOBS.job_id%TYPE
    );

    PROCEDURE EmployeeSalary(
        p_employee_id Employees.employee_id%TYPE,
        o_Zarobki OUT employees.salary%TYPE,
        o_Nazwisko OUT employees.last_name%TYPE
    );

    PROCEDURE AddEmployee(
        p_First_name employees.first_name%TYPE,
        p_Last_name employees.last_name%TYPE,
        p_Salary employees.salary%TYPE DEFAULT 1000,
        p_email employees.email%TYPE DEFAULT 'example@mail.com',
        p_phone_number employees.phone_number%TYPE DEFAULT NULL,
        p_hire_date employees.hire_date%TYPE DEFAULT SYSDATE,
        p_job_id employees.job_id%TYPE DEFAULT 'IT_PROG',
        p_commission_pct employees.commission_pct%TYPE DEFAULT NULL,
        p_manager_id employees.manager_id%TYPE DEFAULT NULL,
        p_department_id employees.department_id%TYPE DEFAULT 60
    );
END Paczka_1;

CREATE OR REPLACE PACKAGE BODY Paczka_1 AS
    PROCEDURE AddJob(
        p_job_id IN jobs.job_id%TYPE,
        p_job_title IN jobs.job_title%TYPE
    ) AS
    BEGIN
       
        INSERT INTO Jobs (job_id, job_title)
        VALUES (p_job_id, p_job_title);

        DBMS_OUTPUT.PUT_LINE('Dodano nową pozycję do tabeli Jobs.');
    EXCEPTION
        WHEN OTHERS THEN
            
            DBMS_OUTPUT.PUT_LINE('Wystąpił nieoczekiwany błąd: ' || SQLERRM);
    END AddJob;

PROCEDURE AddEmployee(
        p_First_name employees.first_name%TYPE,
        p_Last_name employees.last_name%TYPE,
        p_Salary employees.salary%TYPE DEFAULT 1000,
        p_email employees.email%TYPE DEFAULT 'example@mail.com',
        p_phone_number employees.phone_number%TYPE DEFAULT NULL,
        p_hire_date employees.hire_date%TYPE DEFAULT SYSDATE,
        p_job_id employees.job_id%TYPE DEFAULT 'IT_PROG',
        p_commission_pct employees.commission_pct%TYPE DEFAULT NULL,
        p_manager_id employees.manager_id%TYPE DEFAULT NULL,
        p_department_id employees.department_id%TYPE DEFAULT 60
    ) AS
    BEGIN
    
        IF p_Salary > 20000 THEN
            DBMS_OUTPUT.PUT_LINE('Wynagrodzenie przekracza 20000, nie można dodać pracownika.');
        ELSE
            INSERT INTO employees (
                employee_id, first_name, last_name, email, phone_number,
                hire_date, job_id, salary, commission_pct, manager_id, department_id
            )
            VALUES (
                (SELECT MAX(employee_id) + 1 FROM employees),
                p_First_name, p_Last_name, p_email, p_phone_number,
                p_hire_date, p_job_id, p_Salary, p_commission_pct, p_manager_id, p_department_id
            );

            COMMIT;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Błąd podczas dodawania pracownika: ' || SQLERRM);
    END AddEmployee;


    PROCEDURE EditJobTitle(
        p_JOB_id JOBS.job_id%TYPE,
        p_JOB_title JOBS.job_title%TYPE
    ) AS
        no_jobs_updated EXCEPTION;
        PRAGMA EXCEPTION_INIT(no_jobs_updated, -20000);
    BEGIN
       
        UPDATE JOBS SET job_title = p_JOB_title WHERE job_id = p_JOB_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Brak zaktualizowanych wierszy w tabeli Jobs.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Zaktualizowano ' || SQL%ROWCOUNT || ' wierszy w tabeli Jobs.');
        END IF;
    EXCEPTION
        WHEN no_jobs_updated THEN
            DBMS_OUTPUT.PUT_LINE('Brak zaktualizowanych wierszy w tabeli Jobs.');
    END EditJobTitle;

    

    PROCEDURE DeleteJob(
        p_job_id JOBS.job_id%TYPE
    ) AS
        no_jobs_deleted EXCEPTION;
        PRAGMA EXCEPTION_INIT(no_jobs_deleted, -20001);
    BEGIN
        
        DELETE FROM Jobs WHERE job_id = p_job_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE no_jobs_deleted;
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Usunięto ' || SQL%ROWCOUNT || ' wiersz(y) z tabeli Jobs.');
        END IF;
    EXCEPTION
        WHEN no_jobs_deleted THEN
            DBMS_OUTPUT.PUT_LINE('Brak usuniętych wierszy w tabeli Jobs.');
    END DeleteJob;

    

    PROCEDURE EmployeeSalary(
        p_employee_id Employees.employee_id%TYPE,
        o_Zarobki OUT employees.salary%TYPE,
        o_Nazwisko OUT employees.last_name%TYPE
    ) AS
    BEGIN
       
        SELECT salary, last_name INTO o_zarobki, o_Nazwisko FROM employees
        WHERE employees.employee_id = p_employee_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak pracownika o podanym ID.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Błąd podczas pobierania danych pracownika: ' || SQLERRM);
    END EmployeeSalary;

    
END Paczka_1;

DECLARE
    v_salary employees.salary%TYPE;
    v_last_name employees.last_name%TYPE;
BEGIN
    Paczka_1.EmployeeSalary(101, v_salary, v_last_name);
    DBMS_OUTPUT.PUT_LINE('Zarobki: ' || v_salary || ', Nazwisko: ' || v_last_name);
END;
/

CREATE OR REPLACE PACKAGE Paczka_2 AS
    
    PROCEDURE AddRegion(
        p_region_id IN regions.region_id%TYPE,
        p_region_name IN regions.region_name%TYPE
    );

   
    PROCEDURE EditRegionName(
        p_region_id IN regions.region_id%TYPE,
        p_new_region_name IN regions.region_name%TYPE
    );

   
    PROCEDURE DeleteRegion(
        p_region_id IN regions.region_id%TYPE
    );

    
    FUNCTION GetRegionInfo(
        p_region_id IN regions.region_id%TYPE
    ) RETURN VARCHAR2;
END Paczka_2;
/

CREATE OR REPLACE PACKAGE BODY Paczka_2 AS
    PROCEDURE AddRegion(
        p_region_id IN regions.region_id%TYPE,
        p_region_name IN regions.region_name%TYPE
    ) AS
    BEGIN
        INSERT INTO regions (region_id, region_name)
        VALUES (p_region_id, p_region_name);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano nowy region.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wystąpił nieoczekiwany błąd: ' || SQLERRM);
    END AddRegion;

    PROCEDURE EditRegionName(
        p_region_id IN regions.region_id%TYPE,
        p_new_region_name IN regions.region_name%TYPE
    ) AS
        no_regions_updated EXCEPTION;
        PRAGMA EXCEPTION_INIT(no_regions_updated, -20000);
    BEGIN
        UPDATE regions SET region_name = p_new_region_name WHERE region_id = p_region_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Brak zaktualizowanych wierszy w tabeli Regions.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Zaktualizowano ' || SQL%ROWCOUNT || ' wierszy w tabeli Regions.');
        END IF;
    EXCEPTION
        WHEN no_regions_updated THEN
            DBMS_OUTPUT.PUT_LINE('Brak zaktualizowanych wierszy w tabeli Regions.');
    END EditRegionName;

    PROCEDURE DeleteRegion(
        p_region_id IN regions.region_id%TYPE
    ) AS
        no_regions_deleted EXCEPTION;
        PRAGMA EXCEPTION_INIT(no_regions_deleted, -20001);
    BEGIN
        DELETE FROM regions WHERE region_id = p_region_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE no_regions_deleted;
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Usunięto ' || SQL%ROWCOUNT || ' wiersz(y) z tabeli Regions.');
        END IF;
    EXCEPTION
        WHEN no_regions_deleted THEN
            DBMS_OUTPUT.PUT_LINE('Brak usuniętych wierszy w tabeli Regions.');
    END DeleteRegion;

    FUNCTION GetRegionInfo(
        p_region_id IN regions.region_id%TYPE
    ) RETURN VARCHAR2 AS
        v_info VARCHAR2(100);
    BEGIN
        SELECT 'Region ID: ' || TO_CHAR(region_id) || ', Region Name: ' || region_name
        INTO v_info
        FROM regions
        WHERE region_id = p_region_id;

        RETURN v_info;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Brak regionu o podanym ID.';
        WHEN OTHERS THEN
            RETURN 'Błąd podczas pobierania danych regionu: ' || SQLERRM;
    END GetRegionInfo;

END Paczka_2;
/

-- Dodawanie nowego regionu
DECLARE
    v_region_id regions.region_id%TYPE := 5; 
    v_region_name regions.region_name%TYPE := 'TestRegion';
BEGIN
    Paczka_2.AddRegion(v_region_id, v_region_name);
END;
/

-- Edytowanie nazwy regionu
DECLARE
    v_region_id_to_edit regions.region_id%TYPE := 5; 
    v_new_region_name regions.region_name%TYPE := 'UpdatedRegionName';
BEGIN
    Paczka_2.EditRegionName(v_region_id_to_edit, v_new_region_name);
END;
/

-- Pobieranie informacji o regionie
DECLARE
    v_region_id_to_get_info regions.region_id%TYPE := 5; 
    v_region_info VARCHAR2(100);
BEGIN
    v_region_info := Paczka_2.GetRegionInfo(v_region_id_to_get_info);
    DBMS_OUTPUT.PUT_LINE(v_region_info);
END;
/

-- Usuwanie regionu
DECLARE
    v_region_id_to_delete regions.region_id%TYPE := 5;
BEGIN
    Paczka_2.DeleteRegion(v_region_id_to_delete);
END;
/


