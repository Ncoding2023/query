--GROUP
--
--함수	설명
--COUNT()	개수
--SUM()	합계
--AVG()	평균
--MAX()	최대값
--MIN()	최소값


SELECT sum(salary) FROM employees;

SELECT to_char(sum(salary),'FM$999,999,999') FROM employees;

SELECT avg(salary)  as "평균 급여" FROM employees;

--**
SELECT Round(avg(salary),1) as "평균 급여 지정한 자리수 소수점 반올림" FROM employees;

SELECT trunc(avg(salary),1) as "평균 급여 지정한 자리수  소수점 버림" FROM employees;
--SELECT floor(avg(salary)) as "평균 급여 버림" FROM employees;


--오류원인, 컬럼값 확인: 날짜 타입으로 넣질 않음
SELECT to_char(max(hire_date),'yyyy.mm.dd')as "최근입사일",
to_char(min(hire_date),'yyyy-mm-dd')as "최초입사일"
FROM employees;


--COUNT
SELECT COUNT(*) as "전체 사원 수",
COUNT(employee_id) as "사원번호 개수",
COUNT(commission_pct) as "커미션 수령 사원 수"
FROM employees
;


--GROUP BY
SELECT department_id,
MAX(salary)  as "최대 급여",
MIN(salary)  as "최소 급여"
FROM employees
GROUP BY department_id
ORDER BY department_id
;

SELECT department_id,
SUM(salary)  as "급여의 합",
round(AVG(salary),1)  as "급여의 평균"
FROM employees
GROUP BY department_id
ORDER BY department_id
;

--GROUP BY를 작성하지 않는다면
--GROUP BY department_id 
--ORA-00937: 단일 그룹의 그룹 함수가 아닙니다


--HAVING : GROUP BY 조건절, 필터링 역할
SELECT department_id as 부서번호,
trunc(AVG(salary),1)  as "급여의 평균"
FROM employees
GROUP BY department_id
HAVING AVG(salary) >= 5000
ORDER BY department_id
;

SELECT department_id,
MAX(salary)  as "최대 급여",
MIN(salary)  as "최소 급여"
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 5000
ORDER BY department_id
;

SELECT department_name as 부서명,
COUNT(employee_id) as 인원수
FROM departments RIGHT OUTER JOIN employees
USING(department_id)
GROUP BY department_name ,department_id
ORDER BY department_id
;

--예제풀이
--1
SELECT department_id as 부서번호,
    COUNT(department_id) as 사원수
FROM employees
GROUP BY department_id
HAVING COUNT(department_id) > 4
ORDER BY department_id
;

--2
SELECT department_id,
    SUM(salary) as "급여 합계"
FROM employees
GROUP BY department_id
HAVING SUM(salary) >= 30000
ORDER BY SUM(salary) DESC
;

--3
SELECT job_id as "직무 코드",
    COUNT(job_id)  as 사원수
FROM employees
GROUP BY job_id
HAVING COUNT(job_id) >= 5
ORDER BY job_id
;

--ROLLUP
--ROLLUP 사용 전 쿼리
SELECT department_id as 부서번호,
--null as job_id,
job_id,
COUNT(*) as 사원수,
SUM(salary) as "급여 합계"
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id
;

--ROLLUP으로 작성한 경우
--그룹별 데이터의 중간 합계(소계)와 전체 합계(총계)를 자동으로 계산하는 기능
SELECT department_id as 부서번호,
job_id,
COUNT(*) as 사원수,
SUM(salary) as "급여 합계"
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id, job_id
;
-- 부서번호랑 직무코드 순서변경
SELECT job_id,
department_id,
COUNT(*),
SUM(salary)
FROM employees 
GROUP BY ROLLUP(job_id,department_id)
ORDER BY job_id,department_id
;

--CUBE - 모든 조합의 소계와 전체 합계를 출력하는 함수
SELECT department_id,
    job_id,
    COUNT(*) as 사원수,
    SUM(salary) as 급여합계
FROM employees 
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id ,job_id
;
--28번째랑 31번째 job_id가 동일함.

--GROUPING SETS절 : 특정 열(Column)별로 각각 데이터를 그룹화하여 보여주는 기능
--기본 문법: GROUP BY GROUPING SETS (조건A, 조건B, (조건A, 조건B), ())
--GROUPING SETS 전
SELECT department_id,
    job_id,
    COUNT(*) as 사원수,
    SUM(salary) as 급여합계
FROM employees 
GROUP BY department_id, job_id
ORDER BY department_id ,job_id
;
--GROUPING SETS 후
SELECT department_id,
    job_id,
    COUNT(*) as 사원수,
    SUM(salary) as 급여합계
FROM employees 
GROUP BY GROUPING SETS(department_id, job_id)
ORDER BY department_id ,job_id
;

--집합 연산자: SQL에서 여러 SELECT 결과를 조인 없이 결합해 하나의 결과로 만드는 연산자
--대표적으로 UNION(합집합), UNION ALL, INTERSECT(교집합), MINUS(차집합)

--집합 연산자의 제한 사항
--SELECT 리스트의 컬럼 개수와 데이터 타입이 일치해야한다.
--ORDER BY절은 맨 마지막 SELECT문 뒤에만 사용 - 이것도 같은 테이블일때만 사용 가능
--일부 데이터 타입에는 사용 불가 - LONG형 컬럼은 사용할 수 있음

SELECT * FROM exp_goods_asia;
SELECT * FROM exp_goods_asia WHERE country = '한국';
SELECT * FROM exp_goods_asia WHERE country = '일본';

--UNION(합집합) : 2개 이상의 SELECT문 결과를 하나로 합쳐 출력할 때 사용하는 집합 연산자
-- 중복된 행은 한번만 출력
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods FROM exp_goods_asia
WHERE country = '일본'
;

--UNION ALL(합집합) : 2개 이상의 SELECT문 결과를 하나로 합쳐 출력할 때 사용하는 집합 연산자
--UNION과 달리 중복된 행은 제거되지 않고 출력
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods FROM exp_goods_asia
WHERE country = '일본'
;

--INTERSECT(교집합) : 두 SELECT 결과에서 공통된 행만 남기는 집합 연산(교집합)
--두 결과를 합치되 중복을 제거합니다
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT goods FROM exp_goods_asia
WHERE country = '일본'
;

--MINUS(차집합) : 차집합 개념으로, 첫 번째 집합에서 두 번째 집합과 공통된 행을 제거합니다.
--결과 집합에서 중복 행은 제거됩니다(DISTINCT처럼 동작).
--두 SELECT 문의 컬럼 개수와 데이터 타입이 같아야 하며, 다르면 오류가 발생할 수 있습니다.
SELECT goods FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods FROM exp_goods_asia
WHERE country = '일본'
ORDER BY goods
;
 
--집합 연산자의 제한 사항
--SELECT 리스트의 컬럼 개수와 데이터 타입이 일치해야한다.
SELECT '공지게시판' as 게시판구분,
no AS 글번호,
name AS 작성자,
title AS 제목,
TO_CHAR(regdate,'yyyy-mm-dd') as 작성일
FROM notice
UNION ALL
SELECT '게시판구분' as 공지게시판,
no AS 글번호,
name AS 작성자,
title AS 제목,
TO_CHAR(regdate,'yyyy-mm-dd') as 작성일
FROM free
;

