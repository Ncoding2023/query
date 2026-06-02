--ocrl study DML2 0529

-- INSERT ALL은 하나의 select 결과를 이용하여 두개 이상의 테이블에 데이터를 한번에 삽입할때 사용하는 구문이다,
--여러개의 INTO 절을 작성하여 각각 다른 테이블에 데이터를 삽입할 수 있으며, 필요에 따라 when 조건 then 절을 사용하여
--조건에 따라 다른테이블에 삽입할 수도 있다

CREATE TABLE EMP_BASIC 
AS
SELECT employee_id,first_name,department_id
FROM employees
WHERE 1=0;

CREATE TABLE EMP_salary
AS
SELECT employee_id,salary,commission_pct
FROM employees
WHERE 1=0;

-- INSERT ALL를 활용해서 부서번호가 50인 직원의 기본 정보를
--emp_basic, emp_salary 두 테이블에 데이터 삽입
INSERT ALL
    INTO emp_basic(employee_id,first_name,department_id)
    VALUES (employee_id,first_name,department_id)
    
    INTO emp_salary(employee_id,salary,commission_pct)
    VALUES (employee_id,salary,commission_pct)
    
SELECT employee_id,first_name,department_id,salary,commission_pct
FROM employees
WHERE department_id = 50;

--확인용
SELECT * FROM EMP_BASIC;
SELECT * FROM EMP_salary;
--INSERT ALL 한 테이블의 컬럼 데이터를 분할 해서 관리할거면 좋을거 같다.

--일부러 안되는 조건을 걸어서 구조만 가져온다
CREATE TABLE emp_old
AS
SELECT employee_id,first_name,hire_date,salary
FROM employees
WHERE 1=2;

CREATE TABLE emp_new
as
SELECT employee_id,first_name,hire_date,salary
FROM employees
WHERE 1= 2;

SELECT * FROM emp_old ORDER by hire_date desc;
SELECT * FROM emp_new ORDER by hire_date;

INSERT ALL
    when hire_date < date'2006-01-01'then
    INTO emp_old
    VALUES (employee_id,first_name,hire_date,salary)
    
    when hire_date >= date'2006-01-01'then
    into emp_new
    VALUES (employee_id,first_name,hire_date,salary)
select employee_id,first_name,hire_date,salary
from employees;

DELETE FROM emp_new;  


SELECT * FROM tb_customer;

-- 커밋하면 이거 해도 안사라짐.
ROLLBACK;

COMMIT;

DROP TABLE TB_CUSTOMER;

CREATE TABLE TB_CUSTOMER(
    CUSTOMER_ID CHAR(7) NOT NULL PRIMARY KEY,
    CUSTOMER_NAME VARCHAR2(15 char) NOT NULL,
    GENDER CHAR(1) NOT NULL,
    BIRTH_DATE DATE NOT NULL,
    PHONE_NUMBER VARCHAR2(20),
    EMAIL VARCHAR2(50),
    TOTAL_POINT NUMBER(10) DEFAULT 0 NOT NULL,
    CREATED_AT DATE DEFAULT SYSDATE NOT NULL 
);

-- 어제는 됨??
--INSERT INTO TB_CUSTOMER VALUES ('2017042','홍길동','M','19810603','010-8202-7496','JAVAUSER@NAVER.COM',283500);

INSERT INTO TB_CUSTOMER VALUES ('2017042','강원진','M',TO_DATE('19810603','yyyymmdd') ,'010-8202-8790','wjgang@navi.com',280300,SYSDATE);
--오류 보고 -
--SQL 오류: ORA-00936: 누락된 표현식
--https://docs.oracle.com/error-help/db/ora-00936/00936. 00000 -  "missing expression"
-- ?? 어디 잘됬는데? 홍길동 때문이네 
--원인 : CREATED_AT 값에  DATE를 넣어서
--해결 방안 : SYSDATE으로 수정해서 INSERT
INSERT INTO TB_CUSTOMER VALUES ('2017053','나경숙','W',TO_DATE('19891225','yyyymmdd'),'010-4509-0043','ksna@boram.co.kr',4500,SYSDATE);
INSERT INTO TB_CUSTOMER VALUES ('2017108','박승대','M',TO_DATE('19710430','yyyymmdd'),NULL,'sdpark@haso.com',23450,SYSDATE);




--DUAL 오라클에서 제공하는 단순 계산 결과를 한 번만 출력하는 용도 테이블
SELECT 12*20 FROM DUAL;
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS NOW FROM DUAL;
