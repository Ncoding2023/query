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


--UPDATE 시작

select * from emp;

--새로 만들기
CREATE TABLE emp
as
select * from employees;

drop TABLE emp;

--조건이 없어서 전부 바꿈
update emp
set department_id = 30;


update emp
set salary = salary*1.1;

update emp
set hire_date = sysdate;

-- 부서번호가 10인 사원들의 부서번호를 30으로 변경
update emp
set department_id = 30
where department_id = 10;

-- 급여가 3000이상인 사원만 급여 10%인상
update emp
set salary = salary*1.1
where salary >= 3000;

select * from emp;

-- PK 준 컬럼으로 검색 중복값이 없으니...
select * from emp
WHERE first_name ='Susan';

UPDATE emp
SET department_id =20,job_id ='FI_MGR'
WHERE first_name ='Susan';

select * from emp
WHERE last_name ='Russell';

UPDATE emp
SET salary=17000,commission_pct=0.45
WHERE last_name ='Russell';


SELECT * FROM DUAL;


DELETE FROM dept 
WHERE deptno = 30;


select * from TB_CUSTOMER;

select * from TB_ADD_CUSTOMER;

CREATE TABLE TB_ADD_CUSTOMER(
    CUSTOMER_CD CHAR(7 BYTE) NOT NULL,
    CUSTOMER_NM VARCHAR2(10 BYTE) NOT NULL,
    GENDER CHAR(1 BYTE) NOT NULL,
    BIRTH_DAY CHAR(8 BYTE) NOT NULL,
    PHONE_NUMBER VARCHAR2(16 BYTE),
    CONSTRAINT TB_ADD_CUSTOMER_CUSTOMER_CD_PK PRIMARY KEY(CUSTOMER_CD)
);

DROP TABLE TB_ADD_CUSTOMER;



INSERT INTO TB_ADD_CUSTOMER
(CUSTOMER_CD,CUSTOMER_NM,tb_add_customer.gender,tb_add_customer.birth_day,tb_add_customer.phone_number)
VALUES ('2017108','박승대','M','19711230','010-2580-9919');

INSERT INTO TB_ADD_CUSTOMER
(CUSTOMER_CD,CUSTOMER_NM,tb_add_customer.gender,tb_add_customer.birth_day,tb_add_customer.phone_number)
VALUES ('2019302','전미래','W','19740812','010-8864-0232');
    
INSERT     
    INTO emp_salary(employee_id,salary,commission_pct)
    VALUES (employee_id,salary,commission_pct)

--MERGE
-- 조건을 비교해서 대상 테이블에 존재하면 수정 없으면 추가하는 SQL문
-- WHEN MATCHED THEN 기준으로 처음에 수정 다음엔 추가
MERGE INTO TB_CUSTOMER C
USING 
TB_ADD_CUSTOMER A   -- 추가 및 수정에 사용할 데이터,원천데이터
ON(C.CUSTOMER_ID=A.CUSTOMER_CD) -- 대상 테이블과 원천데이터를 비교할 조건
WHEN MATCHED THEN
 UPDATE SET C.CUSTOMER_NAME=A.CUSTOMER_NM,
    C.GENDER=A.GENDER,
    C.BIPTH_DATE=TO_DATE(A.BIPTH_DAY,'YYYYMMDD'),
    C.PHONE_NUMBER=A.PHONE_NUMBER
WHEN MATCHED THEN
    INSERT (
        CUSTOMER_ID,
        CUSTOMER_NAME,
        GENDER,
        BIPTH_DATE,
        PHONE_NUMBER
    ) VALUES (
        A.CUSTOMER_CD,
        A.CUSTOMER_NM,
        A.GENDER,
        TO_DATE(A.BIRTH_DAY,'YYYYMMDD'),
        A.PHONE_NUMBER
        );
        
        
            
SELECT * FROM TB_CUSTOMER;


SELECT * FROM EMP01;

DROP TABLE EMP01;


PRIMARY KEY,

CREATE TABLE EMP01(
    EMPNO NUMBER(4) NOT NULL PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    MGRNO NUMBER(4),
    HIREDATE DATE NOT NULL,
    SAL NUMBER(7,2) NOT NULL,
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2) NOT NULL
);

INSERT INTO EMP01 VALUES (7369,'SMITH','CLEAK',7839,TO_DATE('2019-12-17'),800,'',20);
INSERT INTO EMP01 VALUES (7499,'ALLEN','SALESMAN',7839,TO_DATE('2000-12-20'),1600,300,30);
INSERT INTO EMP01 VALUES (7839,'KING','PRESIDENT','',TO_DATE('1980-02-08'),5000,'',10);

SELECT * FROM EMP01;

DELETE FROM EMP01;

--데이터 입력 예제 모음

SELECT * FROM MEMBER;
 
INSERT INTO MEMBER VALUES (1,'홍길동',TO_DATE('1970-10-01'),'010-5690-2510','서울특별시 동작구 흑석 3동 140-3');
INSERT INTO MEMBER VALUES (2,'김철수',TO_DATE('1999-05-28'),'010-7825-1983','평택시 비전 1동 118-36');
INSERT INTO MEMBER VALUES (3,'이희진',TO_DATE('1995-11-11'),'010-6724-2412','인천광역시 남동구 간석동 264-11');

DELETE FROM MEMBER;

SELECT * FROM BOOK;
INSERT INTO BOOK VALUES (1001,'마흔에 읽는 쇼펜하우어',7,17000,'유노북스');
INSERT INTO BOOK VALUES (1002,'삶이 흔들릴 때 뇌과학을 읽습니다',5,18000,'힉스');
INSERT INTO BOOK VALUES (1003,'무엇이 나를 행복하게 만드는가',10,19200,'북플레저');

COMMIT;

SELECT * FROM BOOK_ORDER;
DESC BOOK_ORDER;

ALTER TABLE BOOK_ORDER
MODIFY(ORDER_ID VARCHAR2(20) );

INSERT INTO BOOK_ORDER VALUES ('202411260010001',1,1002,1,SYSDATE);
INSERT INTO BOOK_ORDER VALUES ('202411260010002',2,1003,1,SYSDATE);
INSERT INTO BOOK_ORDER VALUES ('202411260010003',2,1001,1,SYSDATE);

SELECT * FROM BOOK_REVIEW;

INSERT INTO BOOK_REVIEW VALUES (1,1,1001,5,'생각을 정리하는데 도움이 되는 책입니다.',SYSDATE);
INSERT INTO BOOK_REVIEW VALUES (2,2,1002,4,'뇌과학 내용을 쉽게 설명해서 읽기 좋았습니다',SYSDATE);
INSERT INTO BOOK_REVIEW VALUES (3,3,1003,5,'행복에 대해 다시 생각해 볼 수 있는 책입니다.',SYSDATE);

COMMIT;


SELECT * FROM TB_CUSTOMER;

