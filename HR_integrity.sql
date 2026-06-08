--무결성제약 조건
SELECT * FROM emp01;

DROP TABLE emp01 purge;

CREATE TABLE emp01 (
    empno NUMBER(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    deptno NUMBER(4)
);

INSERT INTO emp01 VALUES (null,null,'SALESMAN',30);

CREATE TABLE emp01 (
    empno NUMBER(4)NOT NULL,
    ename VARCHAR2(10)NOT NULL,
    job VARCHAR2(9),
    deptno NUMBER(4)
);

--오류 보고 - SQL 오류: ORA-01400: NULL을 ("HR"."EMP01"."EMPNO") 안에 삽입할 수 없습니다
--https://docs.oracle.com/error-help/db/ora-01400/01400. 00000 -  "cannot insert NULL into (%s)"
--*Cause:    An attempt was made to insert NULL into previously listed objects.
--*Action:   These objects cannot accept NULL values. Reservable columns cannot

--UNIQUE

--UNIQUE는 특정 칼럼에 대해 자료가 중복되지 않게 하는것
--NULL값은 예외, 프론트에서 유효성 검사 느낌
--UNIQUE와 NULL의 관계
--UNIQUE로 지정한 컬럼은 NULL값은 여러번 저장가능

데이터 딕셔너리

CREATE TABLE emp02 (
    empno NUMBER(4)UNIQUE,
    ename VARCHAR2(10)NOT NULL,
    job VARCHAR2(9),
    deptno NUMBER(4)
);

INSERT INTO emp02 VALUES (7499,'ALLEN','SALESMAN',20);

--상단에 UNIQUE 제약 조건건 컬럼을 2번 추가하면 중복방지 조건으로 오류 발생
--오류 보고 -ORA-00001: 무결성 제약 조건(HR.SYS_C008488)에 위배됩니다
--https://docs.oracle.com/error-help/db/ora-00001/

SELECT * FROM emp02;

INSERT INTO emp02 VALUES (NULL,'jonEs','MANAGER',20);
INSERT INTO emp02 VALUES (NULL,'jonEs','SALESMAN',10);





SELECT table_name FROM user_tables
ORDER BY table_name DESC;

commit;

--제약조건 확인하기
SELECT constraint_name, constraint_type, table_name FROM user_constraints
where table_name='EMP02';

--user_constraints 데이터 딕셔너리 뷰를 제공
-- 현재 사용자가 소유한 데이블에서 설정된 제약 조건 정보를 저장하고 있는 데이터 딕셔너리 뷰
constraint_name
constraint_type
table_name
--이 세가지를 정보를 중심적으로 확인

SELECT * FROM emp03;

CREATE TABLE emp03 (
    empno NUMBER(4)primary key,
    ename VARCHAR2(10)NOT NULL,
    job VARCHAR2(9),
    deptno NUMBER(2)
);

INSERT INTO emp03 VALUES (7449,'ALLEN','SALESMAN',30);
INSERT INTO emp03 VALUES (7449,'JONES','MANAGER',20);
--ORA-00001:
INSERT INTO emp03 VALUES (NULL,'JONES','MANAGER',20);
--ORA-01400:
--오류 보고 - SQL 오류: ORA-01400: NULL을 ("HR"."EMP03"."EMPNO") 안에 삽입할 수 없습니다
--https://docs.oracle.com/error-help/db/ora-01400/01400. 00000 -  "cannot insert NULL into (%s)"
--*Cause:    An attempt was made to insert NULL into previously listed objects.
--*Action:   These objects cannot accept NULL values. Reservable columns cannot
--           accept NULL values.


--제약조건 확인하기
SELECT constraint_name, constraint_type, table_name FROM user_constraints
where table_name='EMP03';

CREATE TABLE dept01 (
    deptno NUMBER(2)primary key,
    dname VARCHAR2(14)NOT NULL,
    locvarchar2 VARCHAR2(13)
);

INSERT INTO dept01 VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO dept01 VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept01 VALUES (30,'SALES','CHICAGO');
INSERT INTO dept01 VALUES (40,'OPERATIONS','BOSTON');

SELECT * FROM emp04;



CREATE TABLE emp04 (
    empno NUMBER(4)primary key,
    ename VARCHAR2(10)NOT NULL,
    job VARCHAR2(9),
    deptno NUMBER(2)references dept01(deptno)
);

INSERT INTO emp04 VALUES (7566,'JONES','MANAGER',50);
--오류 보고 -ORA-02291: 무결성 제약조건(HR.SYS_C008495)이 위배되었습니다- 부모 키가 없습니다
--https://docs.oracle.com/error-help/db/ora-02291/

INSERT INTO emp04 VALUES (7499,'ALLEN','SALESMAN',30);

-- check
-- 컬럼값을 추가할때 지정된 값만 저장할수 있게 제약조건 설정
--NOT NULL,DEFAULT 같이 컬럼단위로 지정하는 조건 변경할 경우
--ALTER TABLE 테이블명 MODIFY(컬럼명 자료형 제약조건); 형식을 사용
CREATE TABLE emp05 (
    empno NUMBER(4)primary key,
    ename VARCHAR2(10)NOT NULL,
    gender char(1) check(gender in('M','F')),
    regdate date default sysdate
);

INSERT INTO emp05(empno, ename, gender) VALUES (7566,'JONES','M');

SELECT * FROM emp05;

INSERT INTO emp05(empno, ename, gender) VALUES (7568,'JONES','A');
--오류 보고 -ORA-02290: 체크 제약조건(HR.SYS_C008497)이 위배되었습니다
--https://docs.oracle.com/error-help/db/ora-02290/

-- 칼럼 레벨 형식

CREATE TABLE EMP06 (
    empno NUMBER(4) CONSTRAINT EMP06_EMPNO_PK primary key,
    ename VARCHAR2(10) CONSTRAINT EMP06_EMPNO_NN NOT NULL,
    job VARCHAR2(9) CONSTRAINT EMP06_JOB_UK UNIQUE,
    deptno NUMBER(2)CONSTRAINT EMP06_DEPTNO_FK REFERENCES dept01(deptno)
);

INSERT INTO emp06 VALUES (7499,'ALLEN','SALESMAN',30);

SELECT * FROM EMP06;

--제약조건 확인하기
SELECT constraint_name, constraint_type, table_name, r_constraint_name
FROM user_constraints
where table_name='EMP06';

--제약 조건 오류 모음
INSERT INTO emp06 VALUES (7499,'ALLEN','SALESMAN',30);
ORA-00001: 무결성 제약 조건(HR.EMPNO_PK)에 위배됩니다
INSERT INTO emp06 VALUES (7499,NULL,'SALESMAN',30);
SQL 오류: ORA-01400: NULL을 ("HR"."EMP06"."ENAME") 안에 삽입할 수 없습니다
INSERT INTO emp06 VALUES (7499,'ALLEN','SALESMAN',50);
ORA-00001: 무결성 제약 조건(HR.EMPNO_PK)에 위배됩니다
INSERT INTO emp06 VALUES (7500,'ALLEN','SALESMAN',50);
ORA-00001: 무결성 제약 조건(HR.EMPNO_UK)에 위배됩니다
INSERT INTO emp06 VALUES (7500,'ALLEN','MANAGER',50);
ORA-02291: 무결성 제약조건(HR.EMPNO_FK)이 위배되었습니다- 부모 키가 없습니다


CREATE TABLE emp06 (
    empno NUMBER(4) CONSTRAINT EMPNO_PK primary key,
    ename VARCHAR2(10) CONSTRAINT EMPNO_NN NOT NULL,
    job VARCHAR2(9) CONSTRAINT EMPNO_UK UNIQUE,
    deptno NUMBER(2)CONSTRAINT EMPNO_FK REFERENCES dept01(deptno)
);


-- 복합키로 키본킬르 지정할 경우
2개 이상의 컬럼을 묶어서 하나의 기본키로 지정하는 경우를 복합키

SELECT * FROM ORDER_DETAIL;

CREATE TABLE ORDER_DETAIL (
    ORDER_ID NUMBER(5),
    PRODUCT_ID NUMBER(5),
    QTY NUMBER(3),
    CONSTRAINT ORDER_DETAIL_PK PRIMARY KEY (ORDER_ID, PRODUCT_ID) 
);



-- ALTER TABLE로 제약 조건을 추가할 경우
--컬럼 레벨로 제약조건을 지정하는 방식
CREATE TABLE emp07 (
    empno NUMBER(4) primary key,
    ename VARCHAR2(10) NOT NULL,
    job VARCHAR2(9) UNIQUE,
    deptno NUMBER(2) REFERENCES dept01(deptno)
);



--테이블 레벨로 제약조건을 지정하는 방식
CREATE TABLE emp08 (
    empno NUMBER(4),
    ename VARCHAR2(10) NOT NULL,
    job VARCHAR2(9),
    deptno NUMBER(2),
    primary key(EMPNO),
    UNIQUE(job),
    FOREIGN KEY(DEPTNO) REFERENCES dept01(deptno)
);

SELECT * FROM emp08;

--제약 조건 변경
CREATE TABLE emp09(
    empno NUMBER(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    deptno NUMBER(2)
);

--기본키를 설정하고 EMPNO컬럼에 외래키 설정
ALTER TABLE EMP09
ADD PRIMARY KEY(EMPNO);

--제약 조건명을 지정
ALTER TABLE EMP09
ADD CONSTRAINT EMP09_EMPNO_PK PRIMARY KEY(EMPNO);


ALTER TABLE EMP09
ADD CONSTRAINT EMP09_DEPTNO_FK FOREIGN KEY(DEPTNO) REFERENCES DEPT01(DEPTNO);


ALTER TABLE EMP09
ADD CONSTRAINT EMP09_JOB_CK CHECK();



--제약 조건 삭제




--제약조건 확인하기
SELECT constraint_name, constraint_type, table_name, r_constraint_name
FROM user_constraints
where table_name='EMP06';


SELECT * FROM EMP06;

ALTER TABLE EMP06
DROP CONSTRAINT EMP06_EMPNO_PK;

ALTER TABLE EMP06
DROP CONSTRAINT EMP06_DEPTNO_FK;




--외래키가 설정된 데이터 삭제
CREATE TABLE DEPT02(
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(14) NOT NULL,
    LOC VARCHAR2(13),
    CONSTRAINT DEPT02_DEPTNO_PK PRIMARY KEY(DEPTNO)
);

SELECT constraint_name, constraint_type, table_name, r_constraint_name
FROM user_constraints
where table_name='DOCTOR';


DROP TABLE EMP02 PURGE;


CREATE TABLE EMP02(
    EMPNO NUMBER(4),
    ename VARCHAR2(10) NOT NULL,
    job VARCHAR2(9),
    DEPTNO NUMBER(2),
    CONSTRAINT EMP02_EMPNO_PK PRIMARY KEY(EMPNO),
    CONSTRAINT EMP02_DEPTNO_FK FOREIGN KEY(DEPTNO) REFERENCES DEPT02(DEPTNO)
);
SELECT * FROM DEPT02;


INSERT INTO DEPT02 VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT02 VALUES (20,'RESEARCH','DALLAS');


INSERT INTO EMP02 VALUES (7499,'ALLEN','SALESMAN',10);
INSERT INTO EMP02 VALUES (7369,'SMITH','CLERK',20);

SELECT * FROM EMP02;

COMMIT;
--사원테이블(자식)
DELETE FROM EMP02 WHERE DEPTNO = 10;
--부서테이블(부모)
DELETE FROM DEPT02 WHERE DEPTNO = 10;
--오류 보고 -ORA-02292: 무결성 제약조건(HR.EMP02_DEPTNO_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
--이걸 먼저 실행하면 자식키 테이블에 해당 컬럼이 존재하여 삭제에 제약이걸림

CREATE TABLE TREATMENT(
    T_NO NUMBER(4) NOT NULL,
    T_COURSE_ABBR VARCHAR2(3) NOT NULL,
    T_COURSE VARCHAR2(30) NOT NULL,
    T_TEL VARCHAR2(15) NOT NULL,
    CONSTRAINT TREATMENT_NO_PK PRIMARY KEY(T_NO),
    CONSTRAINT TREATMENT_COURSE_ABBR_UK UNIQUE(T_COURSE_ABBR)
);

--테이블에 주석 작성하기 


INSERT INTO TREATMENT(T_NO,T_COURSE_ABBR,T_COURSE,T_TEL) VALUES (1001,'NS','신경외과','02-3452-1009');
INSERT INTO TREATMENT(T_NO,T_COURSE_ABBR,T_COURSE,T_TEL) VALUES (1002,'OS','정형외과','02-3452-2009');
INSERT INTO TREATMENT(T_NO,T_COURSE_ABBR,T_COURSE,T_TEL) VALUES (1003,'C','순환기내과','02-3452-3009');

SELECT * FROM TREATMENT;



CREATE TABLE DOCTOR(
    D_NO NUMBER(4) NOT NULL,
    D_NAME VARCHAR2(20) NOT NULL,
    D_SSN CHAR(14) NOT NULL,
    D_EMAIL VARCHAR2(80) NOT NULL,
    D_MAJOR VARCHAR2(50) NOT NULL,
    T_NO NUMBER(4),
    CONSTRAINT DOCTOR_D_NO_PK PRIMARY KEY(D_NO)
);



INSERT INTO DOCTOR VALUES (1,'홍길동','660606-1234561','javauser@naver.com','척추신경외과',1001);
INSERT INTO DOCTOR VALUES (2,'이재환','690724-1674536','jaehwan@naver.com','뇌졸중,뇌혈관외과',1003);
INSERT INTO DOCTOR VALUES (3,'양익환','700129-1328962','sheep1209@naver.com','인공관절,관절염',1002);
INSERT INTO DOCTOR VALUES (4,'김승현','720901-1348940','seunghyeon@naver.com','종양외과,외상전문',1002);

SELECT * FROM DOCTOR;
commit;

--테이블 제약조건 조회
SELECT constraint_name, constraint_type, table_name, r_constraint_name
FROM user_constraints
where table_name='DOCTOR';

--테이블 구조 조회
desc DOCTOR;


ALTER TABLE DOCTOR
add CONSTRAINT DOCTOR_T_NO FOREIGN KEY(T_NO) REFERENCES TREATMENT(T_NO)
ON DELETE CASCADE;
--상단의 제약 조건을 변경해서 부모테이블이랑 연관된 자식테이블의 컬럼까지 삭제
DELETE FROM TREATMENT where t_no = 1002;

COMMIT;

SELECT * FROM all_constraints FK, all_constraints PK;


SELECT FK.owner,FK.constraint_name, FK.TABLE_NAME
FROM all_constraints FK, all_constraints PK
where FK.R_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
    AND PK.owner = 'HR'
    AND FK.CONSTRAINT_TYPE = 'R'
    AND PK.TABLE_NAME = 'DEPT01'
ORDER BY FK.TABLE_NAME;


