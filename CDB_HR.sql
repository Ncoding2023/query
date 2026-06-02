-- hr 사용자의 전체 데이블 조회
SELECT * FROM tab;

-- 부서 테이블 조회
SELECT * FROM DEPARTMENTS;

-- 사원 테이블 조회
SELECT * FROM employees;
-- 테이블 구조 파악할때 쓰임. 
DESC DEPARTMENTS;
--COUNTRIES	TABLE
--DEPARTMENTS	TABLE
--EMPLOYEES	TABLE
--EMP_DETAILS_VIEW	VIEW
--JOBS	TABLE
--JOB_HISTORY	TABLE
--LOCATIONS	TABLE
--REGIONS	TABLE 

SELECT * FROM DEPARTMENTS;

SELECT DEPARTMENT_ID,DEPARTMENT_NAME FROM DEPARTMENTS;
--컬럼 별칭 부여
SELECT DEPARTMENT_ID AS DEPARTMENTNo,DEPARTMENT_NAME as DEPARTMENTName 
FROM DEPARTMENTS;
--as없이 컬럼 별칭 부여
SELECT department_id"departmentNo", department_name"departmentName"
from DEPARTMENTS;

SELECT department_id 부서번호, department_name 부서명
from DEPARTMENTS;

SELECT FIRST_NAME || '의 직급은 '|| JOB_ID ||'입니다'AS직급
FROM employees;
-- 두 컬럼을 합쳐서 사용
SELECT first_name || ' '|| last_name 이름, salary 급여, hire_date 입사일
FROM employees;

-- 해당 테이블에서 칼럼 를 표시하되 중복된 값은 한번만 표시하라.
SELECT DISTINCT job_id from employees;

--직원들이 어떤 부서에 소속되어 있는지 소속 부서번호 출력하되 중복되지 않고 한벅씩 출력한 쿼리문을 작성
SELECT DISTINCT DEPARTMENT_ID FROM employees;

-- 전체 직원을 대상 두 커리문 비교
SELECT employee_id,first_name,salary FROM employees;
-- 급여를 10000 이상 받는 직원을 조회
SELECT employee_id,first_name,salary FROM employees WHERE salary>=10000;
-- 급여를 3000 미만 받는 직원을 조회
SELECT employee_id,first_name,salary FROM employees WHERE salary < 3000;
--이름이 'Lex'인 직원 소대문자 구분
SELECT department_id,first_name, last_name,salary FROM employees 
WHERE first_name='Lex';

--2008년 이후에 입사한 직원 정상
SELECT first_name,hire_date 
FROM employees 
WHERE hire_date >='2008/01/01';

--날짜 데이터 2008년 이후에 입사한 직원 오류
--, ORA-01861: 리터럴이 형식 문자열과 일치하지 않음
SELECT first_name,hire_date 
FROM employees 
WHERE hire_date >= DATE'08/01/01';

--DATE 리터럴의 형식이 반드시 정해져 있기 때문에 
--Oracle에서 DATE 리터럴은 DATE 'YYYY-MM-DD' 형식만 허용한다.
SELECT first_name,hire_date 
FROM employees 
WHERE hire_date >= DATE '2008-01-01';

--날짜 데이터 형식 변경
--DATE 'YYYY-MM-DD' 표현식 
--: 오라클에서 날짜 리터럴을 표현하는 가장 표준적이고 깔끔한 방법
SELECT first_name,hire_date 
FROM employees 
WHERE hire_date >=TO_DATE('2008/01/01','YYYY/MM/DD');




--급여가 5000에서 10000이하 직원 정보 출력
SELECT employee_id, first_name, phone_number, department_id, job_id,salary
FROM employees
WHERE salary > 5000 AND salary <= 10000;

--부서번호가 100번이거나 직급이 FI_MGR인 직원
SELECT employee_id,first_name,phone_number,department_id,job_id
FROM employees
WHERE department_id = 100 OR job_id = 'FI_MGR';

--NOT연산자 활용, 부서번호가 100번이 아닌 직원
SELECT employee_id, first_name, phone_number,department_id,job_id
FROM employees
WHERE NOT department_id = 100;

--BETWEEN연산자 활용, 특정 범위 내에 속하는 데이터를 알아볼려고 할때 AND와 함께 사용
--급여가 2000~3000까지의 범위에 속한 사원
SELECT employee_id,first_name,email,salary
FROM employees
WHERE salary BETWEEN 2000 AND 3000;

--IN연산자 활용, 동일한 컬럼이 여러개의 값 중에 하나인지를 살펴보기 위해서 간단하게 표현
--직원번호가 177이거나 101이거나 184인 사원
SELECT employee_id,first_name,salary
FROM employees
WHERE employee_id IN(177,101,184);

--해당  테이블에서 성(first_name)이 K인 직원 정보를 조회.
SELECT employee_id,first_name
FROM employees
WHERE first_name LIKE'%k%';
--WHERE Lower(first_name) LIKE'%k%';//대문자 K로 검색


--해당  테이블에서 업무id(job_id)의 3번째 문자가 (_),4번째는 P인 직원 모든 정보를 조회.
SELECT * FROM employees 
WHERE job_id LIKE'__\_P%'ESCAPE'\';
SELECT * FROM employees 
WHERE job_id LIKE'__@_P%'ESCAPE'@';

--사원의 커미션 비율(commission_pct)이 NULL이라면,
--그 사원이 커미션을 받지 않거나 아직 커미션 정보가 입력되지 않았다는 의미로 볼수 있다
SELECT employee_id,first_name,commission_pct,job_id
FROM employees
WHERE commission_pct = NULL;

--커미션 정보가 없는 사원을 조회하려면 IS NULL을 사용한다.
SELECT employee_id,first_name,commission_pct,job_id
FROM employees
WHERE commission_pct IS NULL;

--커미션 정보가 없는 사원을 조회하려면 IS NOT NULL을 사용한다.
SELECT employee_id,first_name,commission_pct,job_id
FROM employees
WHERE commission_pct IS NOT NULL;

--<문제풀이 NULL
--직속상관 정보는 manager_id 컬럼을 기준으로 판단한다.
SELECT first_name || last_name "전체 이름",employee_id,job_id
FROM employees
WHERE manager_id IS NULL;

--커미션 받은 사원만 조회. 출력 컬럼은 사원번호, 이름,급여,수당율,수당금액으로 하며
--, 수당금액은 급여*수당율로 게산하여 출력
SELECT employee_id as "사원번호", first_name as "이름", salary as "급여",
  commission_pct as "수당율",
  salary*commission_pct as "수당금액"
FROM employees
WHERE commission_pct IS NOT NULL;
--문제풀이>

--사번을 기준으로 오름차순으로 정렬 ASC
SELECT employee_id,first_name
FROM employees
ORDER BY employee_id ASC;

--사번을 기준으로 오름차순으로 정렬 DESC
SELECT employee_id,first_name
FROM employees
ORDER BY employee_id DESC;




--문제풀이 ORDER BY
--문제1번 급여가 높은 직원부터 출력
SELECT employee_id,first_name,salary,department_id
FROM employees
--ORDER BY salary DESC, first_name asc; // 이름순으로 했음
ORDER BY salary DESC, employee_id asc;

--문제2번 가장 최근에 입사한 직원부터 출력
SELECT employee_id,first_name,hire_date
FROM employees
ORDER BY hire_date DESC;

--문제3번 부서번호 20번 또는 50번인 사람의 이름, 부서번호, 급여를 조회,이름 기준으로 오름차순
SELECT first_name,department_id
FROM employees
WHERE department_id IN (20, 50)
--WHERE department_id = 20 or department_id = 50
ORder BY first_name ASC;







--문제 SELECT문  예제풀이
--1. employees테이블에서 급여(SALARY)가 3000이상인 사원의 사원번호(EMPLOYEE_ID), 이름(FIRST_NAME), 담당업무(JOB_ID), 급여(SALARY)를 조회
SELECT employee_id , first_name,job_id,salary
FROM employees
WHERE salary >= 3000;

--2. employees테이블에서 담당업무가 ST_MAN인 사원의 사원번호, 이름, 담당업무, 급여, 부서번호를 조회
SELECT employee_id , first_name,job_id,salary,department_id
FROM employees
WHERE job_id = 'ST_MAN';

--3. employees테이블에서 입사일자가 2006년 1일1일 이후인 사원의 사원번호, 이름, 담당업무, 급여, 입사일자, 부서번호를 조회
SELECT employee_id , first_name,job_id,salary,hire_date,department_id
FROM employees
WHERE hire_date >= '2006/01/01';

--4. employees 테이블에서 급여가 3000이상 5000이하인 사원의 이름,담당업무, 급여, 부서번호를 조회
SELECT employee_id , first_name,job_id,salary,hire_date,department_id
FROM employees
WHERE salary BETWEEN 3000 AND 5000;

--5. employees 테이블에서 2005년에 입사한 사원의 사원번호, 이름, 담당업무, 급여, 입사일자, 부서번호를 조회
SELECT employee_id , first_name,job_id,salary,hire_date,department_id
FROM employees
WHERE hire_date BETWEEN '2005/01/01' AND '2005/12/31';

--6.
SELECT employee_id, last_name || first_name Name, salary,job_id,hire_date,manager_id
FROM employees;

--7
--SELECT first_name || last_name Name,job_id Job,salary Salary, Salary+100 Ann_Salary,(Salary+100)*12 AS "Increased Salary" 
--문제를 잘못 이해한거 같다. 코딩문제들은 왜이리 말이 이상한거 같냐?...
SELECT first_name || last_name Name,job_id Job,salary Salary, (12*salary)+100 "Increased Ann_Salary",(Salary+100)*12 AS "Increased Salary"
 FROM employees;

--8
SELECT first_name || ': 1 Year Salary = $' || (salary)*12 as"1 Year Salary"
FROM employees;

--9 오덜 바이로 정렬안함
select distinct department_id, job_id
from employees
order by department_id;


--10
select last_name || first_name Name, salary
from employees
where not salary between 7000 and 10000
order by salary;


--11
SELECT last_name || first_name, employee_id,hire_date
FROM employees
WHERE hire_date BETWEEN '06/05/20' and '07/05/20'
ORDER BY hire_date ASC;


--12
SELECT last_name || first_name Name,salary, job_id, commission_pct
FROM employees
ORDER BY salary DESC,
commission_pct DESC;



