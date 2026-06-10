COMMIT;
--DROP VIEW VIEW_CHK;

-- 데이터 딕셔너리 USER_VIEWS에 사용자가 생성한 모든 뷰에 대한 정의가 저장
SELECT VIEW_name,TEXT FROM USER_VIEWS;

--View
--뷰 권한 부여
--1.뷰의 개념
--여러 테이블을 조인or조건이 복잡한 SELECT문을 뷰로 만들어 두면, 이후에는 뷰를 일반 테이블 처럼 간단하게 조회 가능
GRANT CREATE VIEW To hr;


CREATE TABLE EMP_COPY
AS
SELECT * FROM employees;

SELECT * FROM EMP_COPY;


CREATE VIEW VIEW_EMP01
AS
SELECT employee_id,first_name,salary,department_id
FROM EMP_COPY
WHERE department_id = 10
;

SELECT * FROM VIEW_EMP01;


--2.기본 테이블 생성 및 조회
CREATE TABLE emp01
AS
SELECT employee_id,first_name,email,hire_date,salary,job_id,department_id
FROM employees
;

SELECT employee_id,first_name,email,hire_date,salary,job_id,department_id
FROM emp01
WHERE department_id = 30
;

--SELECT * FROM emp01;

--3.뷰 생성 조회
CREATE OR REPLACE VIEW VIEW_emp01
AS
SELECT employee_id,first_name,email,hire_date,
    salary,job_id,department_id
FROM EMP01
WHERE department_id = 30
;

SELECT * FROM VIEW_EMP01;




--4.뷰의 종류
--단순 뷰  :   하나의 테이블의 기반으로 하며, 함수그룹 함수GROUP BY DISTINCT 등을 사용하지 않은 뷰
--복잡 뷰  :   여러 테이블을 조인하거나 그룹 함수GROUP BY DISTINCT 계산식 등을 포함한 뷰

--단순 뷰
SELECT * FROM VIEW_EMP01;
INSERT INTO VIEW_EMP01 (employee_id,first_name,email,hire_date,salary,job_id,department_id)
VALUES(250,'ANGEL','AKHOO',sysdate,7000,'PU_MAN',30)
;

--단순 뷰 컬럼에 별칭 부여
CREATE OR REPLACE VIEW VIEW_emp02
AS
SELECT employee_id 사원번호,first_name 사원명,
    salary 급여,department_id 부서번호
FROM EMP01
;
SELECT * FROM VIEW_emp02;
desc VIEW_emp02;
SELECT * FROM VIEW_emp02 WHERE 부서번호 = 10;
SELECT * FROM VIEW_emp02 WHERE department_id = 10;
-- DML 명령어 사용 제한 , 뷰 생성시 컬럼에 별칭부여 - 지정된 별칭으로 사용
--ORA-00904: "DEPARTMENT_ID": 부적합한 식별자

--복잡 뷰
--GROUP BY
CREATE OR REPLACE VIEW VIEW_salary
AS
SELECT department_id,
    SUM(salary) AS SalarySum,
    TRUNC(AVG(salary)) AS SalaryAvg
FROM EMP01
GROUP BY department_id
;

SELECT * FROM VIEW_salary;


--조인
CREATE OR REPLACE VIEW VIEW_emp_dept
AS
SELECT employee_id,first_name,e.salary,e.department_id,d.department_name
FROM employees e INNER JOIN departments d
on e.department_id = d.department_id
;
SELECT * FROM VIEW_emp_dept ORDER BY department_id DESC;

--5.뷰의 삭제
-- 데이터 딕셔너리 USER_VIEWS에 사용자가 생성한 모든 뷰에 대한 정의가 저장
SELECT VIEW_name,TEXT FROM USER_VIEWS;

--DROP VIEW VIEW_salary;


--6.뷰의 수정 : OR REPLACE를 사용해서 재생성
CREATE VIEW VIEW_EMP03
AS
SELECT employee_id,first_name,salary,department_id
FROM EMP01
WHERE employee_id = 10
;

SELECT * FROM VIEW_EMP03;

CREATE OR REPLACE VIEW VIEW_EMP03
AS
SELECT employee_id,first_name,salary,department_id
FROM EMP01
WHERE department_id = 10
;


--7.기본테이블 없이 뷰 생성하기 위한 FORCE옵션
CREATE OR REPLACE FORCE VIEW VIEW_NOTABLE
AS
SELECT employee_id,first_name,department_id
FROM EMP15
WHERE employee_id = 10
;
--경고: 컴파일 오류와 함께 뷰가 생성되었습니다.


--8.WITH CHECK OPTION
--SQL에서 사용되는 제약조건이다. 주로 뷰(VIEW)를 생성하거나 변경할때 사용하며,데이터를 필터링하거나 조작할 수 있다.

CREATE OR REPLACE VIEW VIEW_CHK
AS
SELECT employee_id,first_name,salary,department_id
FROM EMP01
WHERE department_id = 20
WITH CHECK OPTION
;

SELECT * FROM VIEW_CHK;
--WHERE department_id = 20 해당 데이터만 유지되어야한다 부서번호를 10으로 변경 불가
UPDATE VIEW_CHK SET department_id = 10 WHERE salary >= 5000;
--SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다


--9.WITH READ ONLY : 뷰를 읽기 전용으로 생성하는 옵션
CREATE OR REPLACE VIEW VIEW_READ
AS
SELECT employee_id,first_name,salary,department_id
FROM EMP01
WHERE department_id = 30
WITH READ ONLY
;
UPDATE VIEW_READ SET department_id = 1000;
--SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.

--10.뷰 활용하기
--ROWNUM : oracle이 조회 결과에 임시로 부여하는 가상 컬럼 1부터 번호 자동 부여
SELECT ROWNUM, employee_id, first_name, hire_date
FROM employees;

SELECT ROWNUM, employee_id, first_name, hire_date
FROM employees
ORDER BY hire_date DESC;

--10_1 뷰를 이용한 TOP-5조회 : 먼저 입사일 최근인 사원 순서 조회
CREATE OR REPLACE VIEW VIEW_hire
AS
SELECT employee_id,first_name,hire_date
FROM employees
ORDER BY hire_date DESC;

SELECT ROWNUM, employee_id, first_name, hire_date
FROM VIEW_hire;

SELECT ROWNUM, employee_id, first_name, hire_date
FROM VIEW_hire
WHERE ROWNUM <= 5;

--10_2 인라인 뷰로 TOP-N 구하기
--서브쿼리로 사용해서 출력
SELECT ROWNUM, employee_id, first_name, hire_date
FROM (
    SELECT employee_id,first_name,hire_date
    FROM employees
    ORDER BY hire_date DESC
)
WHERE ROWNUM <= 5;

-- employees 테이블에서 부서별 최대 급여를 구한 결과 인라인 뷰로 작성한 후,departments 테이블과 조인 부서별 최대 급여 출력
SELECT e.department_id,d.department_name,e.max_salary
FROM (SELECT department_id,
    max(salary)as max_salary
    FROM employees
    GROUP BY department_id
) e INNER JOIN departments d
on e.department_id = d.department_id
;

--WITH : 정의한 이름으로 테이블처럼 사용 가능
WITH TOPN_hire AS(
    SELECT employee_id,first_name,hire_date
    FROM employees
    ORDER BY hire_date ASC
)
SELECT ROWNUM,employee_id,first_name,hire_date
FROM TOPN_hire WHERE ROWNUM <= 5;
    
--10_3 FETCH FIRST n ROWS ONLY
--예제1, 최근에 입사한 사원 5명 조회
SELECT employee_id as 사원번호,
    first_name,hire_date as 사원명,
    hire_date as 입사일
FROM employees
ORDER BY hire_date DESC
FETCH FIRST 5 ROWS ONLY;

--예제2, 사원번호가 빠른 순서대로 10명조회
SELECT employee_id as 사원번호,
    first_name,hire_date as 사원명,
  department_id as 부서번호
FROM employees
ORDER BY employee_id ASC
FETCH FIRST 10 ROWS ONLY;

--10_4 OFFSET
--예제1 급여가 높은 순으로 1~10번째까지 조회
SELECT employee_id as 사원번호,
    first_name,hire_date as 사원명,
  salary as 급여
FROM employees
ORDER BY salary DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY
;

--예제2 급여가 높은 순으로 11~20번째까지 조회
SELECT employee_id as 사원번호,
    first_name,hire_date as 사원명,
  salary as 급여
FROM employees
ORDER BY salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY
;

--예제3 급여가 높은 순으로 5번째만 조회
SELECT employee_id as 사원번호,
    first_name as 사원명,
  salary as 급여
FROM employees
ORDER BY salary DESC
OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY
;

--11 분석 함수 중 순위 함수
--11_1 RANK()OVER()
-- 중복 순위가 나오면 개수만큼 다음 순위를 건너뜀
SELECT employee_id as 사원번호,
    first_name as 사원명,
    TO_DATE(hire_date,'YYYY-MM-DD')as 입사일자,
  RANK()OVER(ORDER BY salary ASC)as 순위
FROM employees
WHERE department_id = 60
;

SELECT employee_id as 사원번호,
    first_name as 사원명,
    salary as 급여,
  RANK()OVER(ORDER BY salary DESC)as 순위
FROM employees
WHERE department_id = 60
;

--11_2 DENSE_RANK()OVER()
--같은 값이 있으면 같은 순위로 부여하며, 다음 순위를 건너뛰지 않고 연속해서 부여
SELECT employee_id as 사원번호,
    first_name as 사원명,
    salary as 급여,
    DENSE_RANK()OVER(ORDER BY salary DESC)as 순위
FROM employees
WHERE department_id = 60
;

--11_3 ROW_NUMBER()OVER()
--지정한 정렬 기준에 따라 각 행에 고유한 번호를 부여하는 함수
SELECT employee_id as 사원번호,
    first_name as 사원명,
    salary as 급여,
    ROW_NUMBER()OVER(ORDER BY salary DESC)as 번호
FROM employees
WHERE department_id = 60
;

--12 분석 함수와 PARTITION BY
--12_1 분석함수 : 조화된 행을 줄이지 않고 그대로 유지하며 각 행에 순위, 그룹별 합계, 평균, 개수와 같은 분석 결과
--12_1 PARTITION BY : 분석 함수에서 조회 결과를 특정 컬럼 기준으로 나누어 계산할 때 사용하는 절
--예제
SELECT department_id,
    first_name ,
    salary ,
    SUM(salary)OVER(PARTITION BY department_id)as department_TOTAL,
    SUM(salary)OVER()as salary_TOTAL
FROM employees
WHERE department_id = 60


