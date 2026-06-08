--FORMAT 예제


--nvl :  null을 0으로 변환하는 
SELECT first_name as 사원명,
    salary as 급여,
    nvl(commission_pct,0) as 커미션비율,
    salary*nvl(commission_pct,0) as 커미션금액,
    salary + (salary*nvl(commission_pct,0)) as 총급여,
    job_id as 직무코드
FROM employees
ORDER BY job_id
;    

--nv2 :  null을 0으로 변환하는 
SELECT first_name as 사원명,
    salary as 급여,
    commission_pct as 커미션비율,
    nvl2(commission_pct,
    salary + (salary*commission_pct),
    salary) as 총급여
FROM employees
;  
    
--nvl2(컬럼 or 표현식,null이 아닐때,null일때)
SELECT last_name as 성,
    first_name as 이름,
    nvl2(manager_id,'직원','최상위 관리자') as 구분
FROM employees
; 

SELECT last_name as 성,
    first_name as 이름,
    nvl(to_char(manager_id),'CEO') as 구분
FROM employees
; 

SELECT first_name as 사원명,
    salary as 급여,
--    commission_pct as 커미션비율,
    nvl(to_char(commission_pct,'0.99'),'<커미션 없음>') as 커미션비율 -- 포맷 잡는게 아직 익숙하질 않네
FROM employees
ORDER BY job_id
;

--decode
SELECT first_name as 사원명,
    hire_date as 입사일,
    to_char(hire_date,'yyyy') as 입사연도,
    decode(to_char(hire_date,'yyyy'),
    '2001','장기근속',
    '2002','장기근속',
    '2003','중간근속',
    '2004','중간근속',
    '일반근속') as 근속구분
FROM employees
;

SELECT first_name as 사원명,
    salary as 급여,
    commission_pct as 커미션비율,
    decode(commission_pct,
    null,'커미션 없음',
    '커미션 있음') as 커미션여부 
FROM employees
;

SELECT first_name as 사원명,
    job_id as 직무코드,
    decode(job_id,
    'AD_PRES','대표',
    'AD_VP','임원',
    'IT_PROG','개발자',
    'SA_REP','영업사원',
    'ST_CLAERK','재고담당',
    '기타') as 직무구분
FROM employees
ORDER BY job_id
;  

--CASE/WHEN
--CASE/WHEN조건/THEN결과/ELSE조건과 다를때
SELECT first_name as 사원명,
    salary as 급여,
    CASE
        WHEN salary >= 15000 then '고액급여'
        WHEN salary >= 10000 then '중간급여'
        WHEN salary >= 5000 then '일반급여'
        ELSE '낮은급여'
    END AS 급여등급
FROM employees
;

--CASE/WHEN/TRUNC
SELECT first_name as 사원명,
    job_id as 직무코드,
    salary as 급여,
    CASE
        WHEN job_id = 'IT_PROG' then '10%'
        WHEN job_id = 'SA_REP' then '15%'
        WHEN job_id = 'ST_CLAERK' then '5%'
        ELSE '3%'
    END AS 인상률,
    TRUNC(
        CASE
            WHEN job_id = 'IT_PROG' then salary*1.10
            WHEN job_id = 'SA_REP' then salary*1.15
            WHEN job_id = 'ST_CLAERK' then salary*1.05
            ELSE salary*1.03
        END
    ) AS 인상후급여
FROM employees
;

SELECT * FROM employees;
SELECT * FROM departments;

--CASE/WHEN/TRUNC - 예제
SELECT e.employee_id as 직원번호,
    e.first_name as 직원명,
    d.department_id as 부서번호,
    d.department_name as 부서명,
    e.salary as 급여,
    CASE
        WHEN d.department_name = 'Marketing' then '5%'
        WHEN d.department_name = 'Purchasing' then '10%'
        WHEN d.department_name = 'Human Resources' then '15%'
        WHEN d.department_name = 'IT' then '20%'
        ELSE '인상없음'
    END AS 인상률,
    TRUNC(
        CASE
            WHEN d.department_name = 'Marketing' then e.salary*1.05
            WHEN d.department_name = 'Purchasing' then e.salary*1.10
            WHEN d.department_name = 'Human Resources' then e.salary*1.15
            WHEN d.department_name = 'IT' then e.salary*1.20
            ELSE salary
        END
    ) AS 인상후급여
FROM employees e JOIN departments d ON e.department_id = d.department_id
;

-- 이런식으로 사용 가능. 자바의 스위치문처럼 사용가능
SELECT e.employee_id as 직원번호,
    e.first_name as 직원명,
    d.department_id as 부서번호,
    d.department_name as 부서명,
    e.salary as 급여,
    CASE d.department_name 
        WHEN 'Marketing' then '5%'
        WHEN 'Purchasing' then '10%'
        WHEN 'Human Resources' then '15%'
        WHEN 'IT' then '20%'
        ELSE '인상없음'
    END AS 인상률,
    TRUNC(
        CASE d.department_name
            WHEN 'Marketing' then e.salary*1.05
            WHEN 'Purchasing' then e.salary*1.10
            WHEN 'Human Resources' then e.salary*1.15
            WHEN 'IT' then e.salary*1.20
            ELSE salary
        END
    ) AS 인상후급여
FROM employees e JOIN departments d ON e.department_id = d.department_id
;




