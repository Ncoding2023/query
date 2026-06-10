--조인(JOIN)
--FROM절과 WHERE절 - 오라클 전용
--JOIN ~ ON절 - 표준


--1.크로스 조인(Cross Join)


--2.Equi Join

SELECT employee_id, first_name,department_id FROM employees;

SELECT department_id,department_name FROM departments;


desc employees;
desc departments;

SELECT constraint_name, constraint_type, table_name FROM user_constraints 
WHERE table_name = 'departments';



SELECT first_name,department_name
FROM employees,departments
WHERE employees.department_id = departments.department_id;


SELECT first_name,department_name,department_id
FROM employees,departments
WHERE employees.department_id = departments.department_id;
--ORA-00918: 열의 정의가 애매합니다
--두 테이블에 같은 컬럼이 있어 이런 오류가 발생 어느 테이블에 컬럼을 가져올지 정의가 필요
--https://docs.oracle.com/error-help/db/ora-00918/00918. 00000 -  "%s: column ambiguously specified - appears in %s and %s"


SELECT first_name,department_name,department_id
FROM employees,departments
WHERE employees.department_id = departments.department_id;



--별칭 사용
SELECT e.first_name,d.department_name,e.department_id
FROM employees e,departments d
WHERE e.department_id = d.department_id;


SELECT e.first_name,d.department_name,e.department_id
FROM employees e,departments d
WHERE e.department_id = d.department_id
and first_name='Susan';

--3.Non-Equi Join
CREATE TABLE SALARYGRADE(
    GRADE NUMBER PRIMARY KEY,
    MINSALARY NUMBER NOT NULL,
    MAXSALARY NUMBER NOT NULL
);

SELECT * FROM SALARYGRADE;

INSERT INTO SALARYGRADE VALUES (1, 2000, 3000);
INSERT INTO SALARYGRADE VALUES (2, 3001, 4500);
INSERT INTO SALARYGRADE VALUES (3, 4501, 6000);
INSERT INTO SALARYGRADE VALUES (4, 6001, 8000);
INSERT INTO SALARYGRADE VALUES (5, 8001, 10000);
INSERT INTO SALARYGRADE VALUES (6, 10001, 13000);
INSERT INTO SALARYGRADE VALUES (7, 13001, 20000);
INSERT INTO SALARYGRADE VALUES (8, 20001, 30000);

COMMIT;


SELECT e.first_name, e.salary, s.grade
FROM employees E, salarygrade S
WHERE e.salary BETWEEN s.minsalary AND s.maxsalary;

-- 같은 조건은 다음과 같이 비교 연산자를 사용해서 작성할 수도 있다.
SELECT e.first_name, e.salary, s.grade
FROM employees E, salarygrade S
WHERE e.salary >= s.minsalary AND e.salary <= s.maxsalary;


--4.Outer Join
SELECT E.FIRST_NAME, D.DEPARTMENT_ID,D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY D.DEPARTMENT_ID DESC;

SELECT * FROM departments;

--부족한 부분(NULL)이 있는 행을 보이게 하기 위해서 EMPLOYEES로 (+)기준 잡아 조회
SELECT E.FIRST_NAME, D.DEPARTMENT_ID,D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID
ORDER BY D.DEPARTMENT_ID DESC;

--2007년도 상반기 입사한 사원 조회
SELECT employee_id,first_name,hire_date,department_id
FROM employees
WHERE hire_date >= DATE'2007-01-01' 
AND hire_date < DATE'2007-07-01';

--(+)가 있으면 부서번호가 없는 사원도 출력(부서테이블(departments) 부족)/ 없으면 일치하는 사원만 출력
SELECT employee_id,first_name,hire_date,department_name
FROM employees E, departments D
--WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)    --부서번호가 없는 사원도 출력
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID     --부서번호가 일치한 사원만 출력
AND E.hire_date >= DATE'2007-01-01' 
AND E.hire_date < DATE'2007-07-01';

SELECT * FROM jobs;         //직무
SELECT * FROM employees;    //직원
SELECT * FROM departments;  //부서

--삼중 조인 - 앞으로 이렇게 예제풀이를 많이 할 예정
SELECT e.first_name || e.last_name employee_name,j.job_id,j.job_title,d.department_id,d.department_name
FROM jobs j,employees e,departments d
WHERE  e.job_id = j.job_id and E.DEPARTMENT_ID = D.DEPARTMENT_ID
order by employee_name
;


--5.Self Join
-- 본인과 조인

SELECT employee_id,manager_id ,first_name
FROM employees
order by manager_id desc
;

--SELECT *
SELECT employee_id,manager_id ,first_name
FROM employees
--WHERE manager_id = '148'
--WHERE first_name = 'Gerald'
;

SELECT emp.first_name 사원명 
, mgr.first_name 매니저명
,emp.manager_id , mgr.employee_id
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id
;

SELECT emp.first_name || '의 매니저는' ||
 mgr.first_name || ' 이다.' as "그 사원의 매니저"
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id
;

SELECT RPAD(emp.first_name, 11, '') || '의 매니저는 '
|| mgr.first_name || ' 이다.' as "그 사원의 매니저"
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id
;

--RPAD(emp.first_name,11,'')는 자리수 지정


--6.ANSI Join
SELECT first_name, e.job_id,
job_title,e.department_id,department_name
FROM employees e 
INNER JOIN jobs j ON e.job_id = j.job_id
INNER JOIN departments d ON e.department_id = d.department_id
;

--USING(공통컬럼명 별칭 넣으면 오류 나온다는데?? 왜 정상이지?
--SELECT first_name,department_name
--FROM employees e INNER JOIN departments d
--USING(department_id)
--;
                
--USING(공통컬럼명) 이건 별칭 필요 없음
SELECT first_name,department_name
FROM employees INNER JOIN departments
USING(department_id)
WHERE FIRST_name='Susan'
;

--LEFT OUTER JOIN 왼쪽 테이블의 모든 행 출력
SELECT first_name,e.department_id,department_name
FROM employees e LEFT OUTER JOIN departments d
on e.department_id = d.department_id
;

--RIGHT OUTER JOIN 오른쪽 테이블의 모든 행 출력
SELECT first_name,e.department_id,department_name
FROM employees e RIGHT OUTER JOIN departments d
on e.department_id = d.department_id
;

--FULL OUTER JOIN 양쪽 테이블의 모든 행 출력
SELECT first_name,e.department_id,department_name
FROM employees e FULL OUTER JOIN departments d
on e.department_id = d.department_id
;

SELECT e.employee_id, 
e.first_name || e.last_name name,
e.hire_date,
d.department_name
--FROM employees e INNER JOIN departments d
FROM employees e LEFT OUTER JOIN departments d // 이것만 다름
ON e.department_id = d.department_id
where e.hire_date >= date '2007-01-01'
and e.hire_date < date '2007-07-01'
;

--join 예제풀이
--1
--Sales 부서에 속
SELECT e.first_name || e.last_name employee_name,
e.hire_date
FROM employees e JOIN departments d
ON e.department_id = d.department_id
where d.department_name = 'Sales'
ORDER BY e.hire_date
;


--2
SELECT e.first_name || e.last_name employee_name,
e.commission_pct,d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
where e.commission_pct >= 0.1
ORDER BY e.commission_pct
;

--3
SELECT e.employee_id,
e.first_name || e.last_name employee_name,
d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
where d.department_name = 'IT'
ORDER BY e.commission_pct
;

--4
SELECT employee_id,
first_name ,
department_id
FROM employees
where department_id = (SELECT department_id FROM employees where first_name = 'Guy')
and first_name != 'Guy'
;

--SELECT employee_id,
--first_name ,
--department_id
--FROM employees e1, employees e2
--JOIN e1.department_id = 
--and first_name != 'Guy'
--;


SELECT * FROM treatment;

DELETE FROM treatment WHERE t_no = 1005;

commit;

SELECT * FROM employees;

-- 컬럼명 dd를 bb로 작성했었음. 수정함
ALTER TABLE book RENAME COLUMN prcie TO price;



SELECT * FROM tab;

desc book_order;




SELECT order_id,
member_id,
book_id,
order_quantity,
order_date
FROM book_order
;

SELECT bo.order_id,
bo.member_id,
m.member_name,
bo.book_id,
bo.order_quantity,
bo.order_date
FROM book_order bo, member m
WHERE bo.member_id = m.member_id
;


SELECT * FROM book_review;

INSERT INTO BOOK_ORDER VALUES ('202411260010004',3,1004,100,SYSDATE);

commit;


 SELECT constraint_name, constraint_type, table_name FROM user_constraints WHERE table_name = 'EMP02';

SELECT bo.order_id,
bo.member_id,
m.member_name,
bo.book_id,
bo.order_quantity,
br.rating,
br.review_content,
bo.order_date
FROM book_order bo JOIN  member m ON bo.member_id = m.member_id
join book_review br on bo.book_id = br.book_id
;







SELECT bo.order_id,
bo.member_id,
m.member_name,
bo.book_id,
b.book_title,
b.publisher,
b.stock_quantity,
b.price,
bo.order_quantity,
bo.order_date,
br.rating,
br.review_content
FROM book_order bo JOIN  member m ON bo.member_id = m.member_id
join book_review br on bo.book_id = br.book_id
join book b on b.book_id = br.book_id
;








