-- 오라클 DDL
CREATE TABLE emp01(
    empno number(4),
    ename varchar2(20),
    sal number(7,2)
);

-- all 테이블 조회
SELECT * FROM tab;

SELECT * FROM emp01;


-- CREATE TABLE AS SELECT 문 테이블 복사, 컬럼명,자료형,데이터를 복사 제약 조건은 X
CREATE TABLE employees01
AS 
SELECT * FROM employees;
-- CREATE TABLE AS SELECT 문 테이블 복사 데이터 없이 가져오기
-- 조건을 거짓된 조건으로 걸면 해당 조건에 맞는 데이터 없어 컬럼명만 가져온다.

CREATE TABLE employees03
AS 
SELECT * FROM employees
WHERE employee_id < 1
;


--employees의 테이블은 복사를 했지만 제약 조건은 없음. PK 등
SELECT * FROM employees01;





--컬럼 추가
ALTER TABLE emp01
ADD(job VARCHAR2(9));


--컬럼 타입 변경 - 제약 조건도 사용 가능 값을 추가하는데 사용
-- 이거 데이터 복사하고 제약 조건 넣을때 좋을듯.
ALTER TABLE emp01
MODIFY(job VARCHAR2(30) NOT NULL);


--컬럼 타입 변경 문제 1
ALTER TABLE emp01
MODIFY(job DATE);

--컬럼 삭제
ALTER TABLE emp01
DROP COLUMN job;


--휴지통 구조파악. 이거 삭제하고 복구 않하면 수업에 차질 발생.
--그냥 아무 테이블만들어서 쓰자
desc recyclebin;



--실수로 지운 테이블이라 삭제를 취소할려면 다음과같은 명령으로 다시 복구
--FLASHBACK TABLE TABLE_name TO BEFORE DROP; 
FLASHBACK TABLE emp01 TO BEFORE DROP;


--테이블명 변경 RENAME TABLE_old TO TABLE_new;
RENAME employees02 to employees01;






--테이블 구조 파악
desc emp01;


SELECT * FROM employees01;

--*테이블 삭제와 무결성 제약 조건
--삭제하고자 하는 테이블의 기본 키나 고유 키를 다른 테이블에서 참조해서 사용하는 경우에는
--해당 테이블을 제거할 수 없다. 이러한 경우에는 참조하는 테이블을 먼저 제거한 후에 해당
--테이블을 삭제해야 한다.

-- 해당 테이블의 모든 로우를 제거, 롤백 불가 되돌리기가 없다.
TRUNCATE TABLE employees01;

--컬럼 삭제
DELETE FROM employees01;

--테이블 삭제
DROP TABLE employees01;

DROP TABLE TB_CUSTOMER;
--DML 시작--------------------------------------------------------------
CREATE TABLE TB_CUSTOMER(
    CUSTOMER_ID CHAR(7) NOT NULL PRIMARY KEY,
    CUSTOMER_NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(1) NOT NULL,
    BIRTH_DATE DATE NOT NULL,
    PHONE_NUMBER VARCHAR2(20),
    EMAIL VARCHAR2(50),
    TOTAL_POINT NUMBER(10) DEFAULT 0 NOT NULL,
    CREATED_AT DATE DEFAULT SYSDATE NOT NULL -- 또 안 읽고 하다 까먹음 DEFAULT SYSDATE
);

-- 어제는 됨??
INSERT INTO TB_CUSTOMER VALUES ('2017042','홍길동','M','19810603','010-8202-7496','JAVAUSER@NAVER.COM',283500);

INSERT INTO TB_CUSTOMER VALUES ('2017042','강원진','M','19810603','010-8202-8790','wjgang@navi.com',280300,DATE);
--오류 보고 -
--SQL 오류: ORA-00936: 누락된 표현식
--https://docs.oracle.com/error-help/db/ora-00936/00936. 00000 -  "missing expression"
-- ?? 어디 잘됬는데? 홍길동 때문이네 
INSERT INTO TB_CUSTOMER VALUES ('2017053','나경숙','W','19891225','010-4509-0043','ksna@boram.co.kr',4500,DATE);
INSERT INTO TB_CUSTOMER VALUES ('2017108','박승대','M','19710430',NULL,'sdpark@haso.com',23450,DATE);

DELETE FROM TB_CUSTOMER WHERE CUSTOMER_ID = '2017042';

COMMIT;

ALTER TABLE TB_CUSTOMER
MODIFY(CREATED_AT DATE DEFAULT SYSDATE NOT NULL);

SELECT * FROM tb_customer;

DESC TB_CUSTOMER;

select * from tab;

CREATE TABLE MEMBER(
    MEMBER_ID NUMBER(20) NOT NULL PRIMARY KEY,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    BIETH_DATE DATE NOT NULL,
    PHONE_NIMBER VARCHAR2(13) NOT NULL,
    ADDRESS VARCHAR2(100) NOT NULL
);



CREATE TABLE BOOK (
    BOOK_ID NUMBER(4) NOT NULL PRIMARY KEY,
    BOOK_TITLE VARCHAR2(100) NOT NULL,
    STOCK_QUANTITY NUMBER(6) NOT NULL,
    PRCIE NUMBER(10) NOT NULL,
    PUBLISHER VARCHAR2(50) NOT NULL
);

CREATE TABLE BOOK_ORDER(
    ORDER_ID VARCHAR2(10) NOT NULL PRIMARY KEY,
    MEMBER_ID NUMBER(20) NOT NULL,
    BOOK_ID NUMBER(4) NOT NULL,
    ORDER_QUANTITY NUMBER(6) NOT NULL,
    ORDER_DATE DATE NOT NULL
);

CREATE TABLE BOOK_REVIEW(
    REVIEW_ID NUMBER(10) NOT NULL PRIMARY KEY,
    MEMBER_ID NUMBER(20) NOT NULL,
    BOOK_ID NUMBER(4) NOT NULL,
    RATING NUMBER(1) NOT NULL,
    REVIEW_CONTENT VARCHAR2(1000) NOT NULL,
    REVIEW_DATE DATE NOT NULL
);

CREATE TABLE DEPT (
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13)
);

INSERT INTO DEPT VALUES(10,'ACCUNTING','NEW YORK');




SELECT * FROM DEPT;

-- 저장
COMMIT;

--되돌리기
ROLLBACK;

--< INSERT 오류모음

INSERT INTO DEPT VALUES(10,'ACCUNTING');
--SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
--https://docs.oracle.com/error-help/db/ora-00947/00947. 00000 -  "not enough values"

INSERT INTO DEPT VALUES(10,'ACCUNTING','NEW YORK',20);
--SQL 오류: ORA-00913: 값의 수가 너무 많습니다
--https://docs.oracle.com/error-help/db/ora-00913/00913. 00000 -  "too many values"

INSERT INTO DEPT(NUM, DNAME, LOC) VALUES(10,'ACCUNTING','NEW YORK');
--SQL 오류: ORA-00904: "NUM": 부적합한 식별자
--https://docs.oracle.com/error-help/db/ora-00904/00904. 00000 -  "%s: invalid identifier"

INSERT INTO DEPT VALUES(10,ACCUNTING,'NEW YORK');
--SQL 오류: ORA-00984: 열을 사용할 수 없습니다
--https://docs.oracle.com/error-help/db/ora-00984/00984. 00000 -  "column not allowed here"

-- INSERT 오류모음 -->


INSERT INTO DEPT VALUES(20,'RESEATCH','DALLAS');

INSERT INTO DEPT VALUES(20,'RESEATCH','DALLAS');

COMMIT;


ALTER TABLE DEPT
--MODIFY(DEPTNO NUMBER(2) NOT NULL);
--MODIFY(DNAME VARCHAR2(14) NOT NULL);
MODIFY(DEPTNO NUMBER(4),DNAME VARCHAR2(30));


--NOT NULL 제약 조건이 없어서 NULL값으로 추가 가능
INSERT INTO DEPT(DEPTNO, DNAME) VALUES(10,'ACCUNTING');

INSERT INTO DEPT VALUES(40,'RESEATCH',NULL);

INSERT INTO DEPT
SELECT department_id,department_name,location_id FROM departments;

SELECT * FROM DEPT;

DESC DEPT;
