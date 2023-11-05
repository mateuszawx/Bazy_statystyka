-- ZAD 1
SET SERVEROUTPUT ON;
DECLARE
  numer_max departments.department_id%TYPE;
  nowy_numer NUMBER;
  nowa_nazwa departments.department_name%TYPE := 'EDUCATION';

BEGIN
  SELECT MAX(Department_ID) INTO numer_max FROM departments;
  nowy_numer := numer_max + 10;
  INSERT INTO departments (Department_ID, Department_Name)
  VALUES (nowy_numer, nowa_nazwa);

DBMS_OUTPUT.PUT_LINE('Nowy departament dodany: Numer=' || nowy_numer || ', Nazwa=' || nowa_nazwa);
END;


-- ZAD 2
SET SERVEROUTPUT ON;
DECLARE
  numer_max departments.department_id%TYPE;
  nowy_numer NUMBER;
  nowa_nazwa departments.department_name%TYPE := 'EDUCATION';
  nowy_location_id NUMBER := 3000;
BEGIN

  SELECT MAX(Department_ID) INTO numer_max FROM departments;


  nowy_numer := numer_max + 10;


  INSERT INTO departments (Department_ID, Department_Name)
  VALUES (nowy_numer, nowa_nazwa);


  UPDATE departments
  SET Location_ID = nowy_location_id
  WHERE Department_ID = nowy_numer;


  DBMS_OUTPUT.PUT_LINE('Nowy departament dodany: Numer=' || nowy_numer || ', Nazwa=' || nowa_nazwa || ', Location_ID=' || nowy_location_id);
END;


-- ZAD 3
CREATE TABLE nowa (
    pole_varchar VARCHAR(10)
);

DECLARE
    liczba NUMBER;
BEGIN
    FOR liczba IN 1..10 LOOP
        IF liczba NOT IN (4, 6) THEN
            INSERT INTO nowa (pole_varchar) VALUES (TO_CHAR(liczba));
        END IF;
    END LOOP;
END;


-- ZAD 4
SET SERVEROUTPUT ON;
DECLARE
    v_country countries%ROWTYPE;
BEGIN
    SELECT *
    INTO v_country
    FROM countries
    WHERE country_id = 'CA';

    DBMS_OUTPUT.PUT_LINE('Nazwa kraju: ' || v_country.country_name);
    DBMS_OUTPUT.PUT_LINE('Region ID: ' || v_country.region_id);
END;


-- ZAD 5
SET SERVEROUTPUT ON;
DECLARE
    TYPE DepartmentNamesTable IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    v_department_names DepartmentNamesTable;

BEGIN

    FOR r IN (SELECT department_id, department_name FROM departments) LOOP
        v_department_names(r.department_id) := r.department_name;
    END LOOP;


    FOR i IN 10..100 LOOP
        IF v_department_names.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE('Numer ' || i || ': ' || v_department_names(i));
        END IF;
    END LOOP;
END;

-- ZAD 6
SET SERVEROUTPUT ON;
DECLARE
    TYPE DepartmentTable IS TABLE OF departments%ROWTYPE INDEX BY PLS_INTEGER;
    v_departments DepartmentTable;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT * INTO v_departments(i)
        FROM departments
        WHERE department_id = i * 10;
    END LOOP;

    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Informacje o departamencie o ID ' || v_departments(i).department_id);
        DBMS_OUTPUT.PUT_LINE('Nazwa departamentu: ' || v_departments(i).department_name);
        DBMS_OUTPUT.PUT_LINE('ID menedżera: ' || v_departments(i).manager_id);
        DBMS_OUTPUT.PUT_LINE('ID lokalizacji: ' || v_departments(i).location_id);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;

-- ZAD 7
SET SERVEROUTPUT ON;
DECLARE
    CURSOR WynagrodzenieCur IS
    SELECT e.last_name, e.salary
    FROM employees e
    WHERE e.department_id = 50;

    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    FOR rekord IN WynagrodzenieCur LOOP
        v_last_name := rekord.last_name;
        v_salary := rekord.salary;
        
        IF v_salary > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' - nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' - dać podwyżkę');
        END IF;
    END LOOP;
END;

-- ZAD 8
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_employee_salary (min_salary NUMBER, max_salary NUMBER, name_part VARCHAR2)
    IS SELECT first_name, last_name, salary
    FROM employees
    WHERE salary BETWEEN min_salary AND max_salary
    AND UPPER(first_name) LIKE '%' || UPPER(name_part) || '%';
  
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 1000-5000 i imieniem zawierającym "a" lub "A":');
    FOR emp_rec IN c_employee_salary(1000, 5000, 'a') LOOP
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 5000-20000 i imieniem zawierającym "u" lub "U":');
    FOR emp_rec IN c_employee_salary(5000, 20000, 'u') LOOP
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
    END LOOP;
END;

-- ZAD 9 a
CREATE OR REPLACE PROCEDURE AddJob (
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

Call AddJob ('DEV','Sql_DEV');
Call AddJob ('HR','HR_Manager');

-- ZAD 9 b
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE EditJobTitle(
    p_JOB_id JOBS.job_id%TYPE,
    p_JOB_title JOBS.job_title%TYPE
)
AS
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

CALL EditJobTitle('HR','HR_Main');
CALL EditJobTitle('TEST_Test', 'TEST_notfound');

-- ZAD 9 c
CREATE OR REPLACE PROCEDURE DeleteJob(
    p_job_id JOBS.job_id%TYPE
)
AS
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
/
CALL DeleteJob('DEV');
CALL DeleteJob('DEV');

-- ZAD 9 d
CREATE OR REPLACE PROCEDURE EmployeeSalary(
    p_employee_id Employees.employee_id%TYPE,
    o_Zarobki OUT employees.salary%TYPE,
    o_Nazwisko OUT employees.last_name%TYPE
)
AS
BEGIN
    SELECT salary, last_name INTO o_zarobki, o_Nazwisko FROM employees
    WHERE employees.employee_id = p_employee_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak pracownika o podanym ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd podczas pobierania danych pracownika: ' || SQLERRM);
END EmployeeSalary;
/
DECLARE
  v_Zarobki NUMBER;
  v_Nazwisko VARCHAR2(50);
BEGIN
    EmployeeSalary(132, v_Zarobki, v_Nazwisko);
    IF v_Zarobki IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Zarobki pracownika: ' || v_Zarobki);
        DBMS_OUTPUT.PUT_LINE('Nazwisko pracownika: ' || v_Nazwisko);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Brak pracownika o podanym ID lub wystąpił błąd: ' || v_Nazwisko);
    END IF;
END;


-- ZAD 9 e
CREATE OR REPLACE PROCEDURE AddEmployee(
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
)
AS
BEGIN
    -- Sprawdź, czy wynagrodzenie jest większe niż 20000
    IF p_Salary > 20000 THEN
        DBMS_OUTPUT.PUT_LINE('Wynagrodzenie przekracza 20000, nie można dodać pracownika.');
    ELSE
        -- Wstaw nowego pracownika do tabeli employees
        INSERT INTO employees (
            employee_id, first_name, last_name, email, phone_number,
            hire_date, job_id, salary, commission_pct, manager_id, department_id
        )
        VALUES (
            (SELECT MAX(employee_id) + 1 FROM employees), p_First_name, p_Last_name, p_email, p_phone_number,
            p_hire_date, p_job_id, p_Salary, p_commission_pct, p_manager_id, p_department_id
        );

        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd podczas dodawania pracownika: ' || SQLERRM);
END AddEmployee;

CALL AddEmployee('Carl', 'Johnson', 6900);
CALL AddEmployee('Tommy', 'Vercetti', 21000);
CALL AddEmployee('Xin', 'Zhao', 5000, 'xinzhao@gmail.com');







