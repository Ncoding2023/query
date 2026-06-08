--SubQuery(서브 쿼리)
--서브 쿼리는 하나의 SQL 문장 안에 포함된 또 다른 SELECT문
--일반적으론 ORDER BY 절을 사용할 수 없다. 단, 인라인 뷰 처럼 정렬 결과를 이용해야 하는 경우 사용 가능
SELECT * FROM employees
WHERE first_name='Susan'
;

SELECT department_name FROM departments
WHERE department_id=40
;

SELECT department_name FROM departments
WHERE department_id=(SELECT department_id FROM employees
WHERE first_name='Susan')
;

SELECT first_name,
    to_char(hire_date, 'yyyy-mm-dd') as hire_date
FROM employees
WHERE department_id=(SELECT department_id FROM employees
WHERE first_name='Lex')
;

SELECT first_name,
    to_char(hire_date, 'yyyy-mm-dd') as hire_date
FROM employees
WHERE department_id=(SELECT department_id FROM employees
WHERE first_name='Lex')
;

SELECT *
FROM employees
WHERE manager_id = 100
;
-- 매니져 값은 100이면 이사람들이 보고하는 직원이 아닌가?
-- CEO 값이 null이라고 하면 ceo한테 보고하는 직원 구하는게 왜 이런 식으로 나오지? 조회하면 나오는게 없음? 

SELECT * FROM departments;

--단일 행 서브 쿼리
--Guy가 있는 부서의 정보. 
--AND first_name <> 'Guy' - Guy는 제외
SELECT employee_id,
first_name,
job_id,
salary,
nvl(commission_pct,0) as commission_pct,    --null은 0으로 대체
to_char(hire_date,'yyyy.mm.dd') as hire_date
FROM employees
WHERE department_id = (SELECT department_id
    FROM employees
    WHERE first_name = 'Guy') AND first_name <> 'Guy'
;

SELECT first_name,
salary
FROM employees
WHERE salary > (SELECT avg(salary)
    FROM employees)
;

SELECT employees.employee_id,
employees.first_name || employees.last_name as 이름,
(SELECT department_name FROM departments WHERE department_id =employees.department_id) as 담당업무,
employees.salary
FROM employees
WHERE salary > (SELECT salary FROM employees
WHERE last_name ='Kochhar')
;

