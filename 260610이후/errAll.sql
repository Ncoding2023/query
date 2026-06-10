--err

--SubQuery(서브 쿼리)
--3_1 IN 연산자
--예제1 Accounting에서 근무하는 직원과 같은 업무를 담당하는 직원의 이름과업무명 출력

SELECT employee_id,
    first_name,
    (SELECT job_title FROM jobs WHERE job_id IN employees.job_id)
FROM employees
WHERE department_id IN(
    SELECT d.department_id
    FROM employees e JOIN departments d ON
    e.department_id = d.department_id
    where d.department_name IN('Accounting')
)
;
--전
(SELECT job_title FROM jobs WHERE job_id IN job_id)
--후
(SELECT job_title FROM jobs WHERE job_id IN employees.job_id)
--접두어 명시를 하지않아서
-- ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.