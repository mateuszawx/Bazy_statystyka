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
        DBMS_OUTPUT.PUT_LINE('ID mened¿era: ' || v_departments(i).manager_id);
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
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' - nie dawaæ podwy¿ki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' - daæ podwy¿kê');
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
    DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 1000-5000 i imieniem zawieraj¹cym "a" lub "A":');
    FOR emp_rec IN c_employee_salary(1000, 5000, 'a') LOOP
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 5000-20000 i imieniem zawieraj¹cym "u" lub "U":');
    FOR emp_rec IN c_employee_salary(5000, 20000, 'u') LOOP
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
    END LOOP;
END;








