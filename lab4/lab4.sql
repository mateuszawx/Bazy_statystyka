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
    v_earnings := AnnualEarnings(115); -- Przyk³adowe ID pracownika
    DBMS_OUTPUT.PUT_LINE('Roczne zarobki pracownika: ' || v_earnings);
END;
/

--ZAD 1
-- 3
CREATE OR REPLACE FUNCTION ExtractAreaCode(phone_number_param IN VARCHAR2) RETURN VARCHAR2
IS
    v_area_code VARCHAR2(10);
BEGIN
    -- Wyodrêbnij numer kierunkowy z numeru telefonu (pierwsze trzy znaki)
    v_area_code := SUBSTR(phone_number_param, 1, 3);
    
    RETURN v_area_code;
END ExtractAreaCode;

DECLARE
    v_area_code VARCHAR2(10);
BEGIN
    v_area_code := ExtractAreaCode('590.423.4569'); -- Przyk³adowy numer telefonu
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
    -- Konwertuj ca³y ci¹g na ma³e litery
    v_result_string := LOWER(input_string_param);
    
    -- Zmieñ pierwsz¹ literê na wielk¹
    v_result_string := INITCAP(v_result_string);
    
    -- Zmieñ ostatni¹ literê na wielk¹
    v_result_string := SUBSTR(v_result_string, 1, LENGTH(v_result_string) - 1) || UPPER(SUBSTR(v_result_string, -1));
    
    RETURN v_result_string;
END ChangeCase;

DECLARE
    v_result VARCHAR2(4000);
BEGIN
    v_result := ChangeCase('aAAAAAAAa'); -- Przyk³adowy ci¹g znaków
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
        RETURN 'Nieprawid³owy PESEL';
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
    v_date_of_birth := PeselToDate('89012512345'); -- Przyk³adowy numer PESEL
    DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || v_date_of_birth);
END;
/


--ZAD 1
-- 6
/*CREATE OR REPLACE FUNCTION CountEmployeesAndDepartmentsInCountry(country_name_param IN VARCHAR2) RETURN VARCHAR2
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

    RETURN 'Liczba pracowników: ' || v_employee_count || ', Liczba departamentów: ' || v_department_count;
END CountEmployeesAndDepartmentsInCountry;

DECLARE
    v_count_info VARCHAR2(100);
BEGIN
    v_count_info := CountEmployeesAndDepartmentsInCountry('Italy'); -- Przyk³adowa nazwa kraju
    DBMS_OUTPUT.PUT_LINE(v_count_info);
END;
*/ -- NIE DZIA£A NIE WIEM CZEMU ++++++++++++++++POPRAWIÆ

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
