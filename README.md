# Oracle 학습 리마인드

## 1. 사용자(User) 생성 및 권한

### 사용자 생성

```sql
CREATE USER javauser
IDENTIFIED BY 1234;
```

### 권한 부여

```sql
GRANT CONNECT, RESOURCE TO javauser;
```

### 기본 테이블스페이스 및 용량 설정

```sql
ALTER USER javauser
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users;
```

학습 내용

* Oracle은 계정 생성 후 권한을 부여해야 객체 생성 가능
* 테이블스페이스는 데이터가 실제 저장되는 공간
* QUOTA를 통해 사용 가능한 용량을 설정

---

## 2. 테이블 생성

### 기본 테이블 생성

```sql
CREATE TABLE MEMBER (
    MEMBER_ID NUMBER,
    MEMBER_NAME VARCHAR2(50)
);
```

학습 내용

* NUMBER : 숫자형 데이터
* VARCHAR2 : 가변 길이 문자열
* 테이블은 데이터를 저장하는 기본 객체

---

## 3. 무결성 제약조건

### PRIMARY KEY

```sql
MEMBER_ID NUMBER PRIMARY KEY
```

특징

* 중복 불가
* NULL 불가

---

### NOT NULL

```sql
MEMBER_NAME VARCHAR2(50) NOT NULL
```

특징

* 반드시 값 입력

---

### UNIQUE

```sql
EMAIL VARCHAR2(100) UNIQUE
```

특징

* 중복 불가
* NULL 허용

---

### CHECK

```sql
AGE NUMBER CHECK (AGE >= 0)
```

특징

* 조건에 맞는 데이터만 저장

---

### FOREIGN KEY

```sql
FOREIGN KEY (DEPTNO)
REFERENCES DEPT(DEPTNO)
```

특징

* 테이블 간 관계 설정
* 참조 무결성 유지

---

## 4. 데이터 조작어(DML)

### INSERT

```sql
INSERT INTO MEMBER
VALUES (1, '홍길동');
```

---

### UPDATE

```sql
UPDATE MEMBER
SET MEMBER_NAME = '김철수'
WHERE MEMBER_ID = 1;
```

---

### DELETE

```sql
DELETE FROM MEMBER
WHERE MEMBER_ID = 1;
```

---

## 5. 조회(SELECT)

### 전체 조회

```sql
SELECT *
FROM EMP;
```

### 조건 조회

```sql
SELECT *
FROM EMP
WHERE SAL >= 3000;
```

### 정렬

```sql
SELECT *
FROM EMP
ORDER BY SAL DESC;
```

학습 내용

* WHERE : 조건 검색
* ORDER BY : 정렬
* SELECT : 데이터 조회

---

## 6. JOIN

### INNER JOIN

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E
JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
```

학습 내용

* 여러 테이블의 데이터를 연결하여 조회
* 실무에서 가장 많이 사용

---

## 7. 데이터 딕셔너리

### 테이블 조회

```sql
SELECT *
FROM USER_TABLES;
```

### 제약조건 조회

```sql
SELECT *
FROM USER_CONSTRAINTS;
```

학습 내용

* Oracle 객체 정보를 확인 가능
* 테이블 구조 및 제약조건 관리에 활용

---

## 8. 시퀀스(Sequence)

### 생성

```sql
CREATE SEQUENCE SEQ_MEMBER
START WITH 1
INCREMENT BY 1;
```

### 다음 값 조회

```sql
SELECT SEQ_MEMBER.NEXTVAL
FROM DUAL;
```

### 현재 값 조회

```sql
SELECT SEQ_MEMBER.CURRVAL
FROM DUAL;
```

학습 내용

* 자동 증가 번호 생성
* PRIMARY KEY 생성 시 자주 사용
* 중복 없는 번호 관리 가능

---

## 학습 정리

이번 학습을 통해 Oracle의 기본 객체 관리, 데이터 조작, 무결성 제약조건, 데이터 조회, JOIN, 데이터 딕셔너리, 시퀀스 사용 방법을 익혔다.

특히 무결성 제약조건과 시퀀스는 데이터의 정확성과 일관성을 유지하기 위한 핵심 기능이며, 향후 Spring Boot와 연동하여 데이터베이스 설계 시 활용할 수 있다.

Oracle 학습 리마인드 - 가상 컬럼 및 제약조건
1. VIRTUAL COLUMN (가상 컬럼)
사용 목적

실제 데이터를 저장하지 않고 다른 컬럼 값을 이용하여 계산 결과를 자동 생성한다.

사용 예시
AVG_SCORE GENERATED ALWAYS AS
(
    TRUNC((KOR_SCORE + ENG_SCORE + MATH_SCORE) / 3, 1)
) VIRTUAL
특징
물리적으로 데이터 저장 안 함
조회 시 자동 계산
데이터 중복 저장 방지
계산 로직 일관성 유지
활용 예시
국어 : 90
영어 : 80
수학 : 70

평균 : 80.0
2. CHECK 제약조건
사용 목적

컬럼에 입력 가능한 데이터 범위를 제한한다.

사용 예시
CONSTRAINT GRADE_MATH_CK
CHECK(MATH_SCORE BETWEEN 0 AND 100)
특징
잘못된 데이터 입력 방지
업무 규칙(DB Rule) 적용
데이터 무결성 유지
입력 가능
INSERT INTO GRADE
VALUES (1, 90, 80, 100);
입력 불가
INSERT INTO GRADE
VALUES (1, 90, 80, 120);
오류
ORA-02290
check constraint violated
3. DESC
사용 목적

테이블 구조를 빠르게 확인한다.

사용 예시
DESC EMP02;
확인 가능 정보
컬럼명
데이터 타입
NULL 허용 여부
결과 예시
Name         Null?    Type
------------ -------- ------------
EMPNO        NOT NULL NUMBER
ENAME                 VARCHAR2(20)
SAL                   NUMBER
학습 포인트

실무에서 처음 보는 테이블 구조를 파악할 때 가장 먼저 사용하는 명령어 중 하나이다.

4. USER_CONSTRAINTS
사용 목적

테이블에 설정된 제약조건을 조회한다.

사용 예시
SELECT constraint_name,
       constraint_type,
       table_name
FROM user_constraints
WHERE table_name = 'EMP02';
결과 예시
CONSTRAINT_NAME    CONSTRAINT_TYPE
-------------------------------
EMP02_PK           P
EMP02_DEPT_FK      R
EMP02_SAL_CK       C
제약조건 코드
코드	의미
P	PRIMARY KEY
R	FOREIGN KEY
U	UNIQUE
C	CHECK / NOT NULL
활용

특정 테이블의 무결성 제약조건을 확인하고 테이블 간 관계를 파악할 수 있다.

학습 정리
VIRTUAL COLUMN : 계산 결과를 자동 생성하는 가상 컬럼
CHECK : 입력 가능한 데이터 범위 제한
DESC : 테이블 구조 조회
USER_CONSTRAINTS : 제약조건 및 무결성 정보 조회

특히 DESC와 USER_CONSTRAINTS는 새로운 테이블을 분석하거나 기존 데이터베이스 구조를 파악할 때 자주 사용하는 명령어이다.

# 자주 사용하는 Oracle 문법

## 1. CONSTRAINT

### 목적

데이터 무결성을 유지하기 위해 컬럼 또는 테이블에 제약조건을 설정한다.

### PRIMARY KEY

```sql
CREATE TABLE MEMBER(
    MEMBER_ID NUMBER,
    CONSTRAINT MEMBER_PK PRIMARY KEY(MEMBER_ID)
);
```

특징

* 중복 불가
* NULL 불가

---

### FOREIGN KEY

```sql
CREATE TABLE STUDENT(
    SD_NUM NUMBER PRIMARY KEY
);

CREATE TABLE ENROLLMENT(
    NO NUMBER PRIMARY KEY,
    SD_NUM NUMBER,
    CONSTRAINT ENROLLMENT_SD_FK
        FOREIGN KEY(SD_NUM)
        REFERENCES STUDENT(SD_NUM)
);
```

특징

* 부모 테이블 데이터 참조
* 테이블 간 관계 설정

---

### UNIQUE

```sql
EMAIL VARCHAR2(100),
CONSTRAINT MEMBER_EMAIL_UK UNIQUE(EMAIL)
```

특징

* 중복 불가
* NULL 허용

---

### NOT NULL

```sql
NAME VARCHAR2(30) CONSTRAINT MEMBER_NAME_NN NOT NULL
```

특징

* 반드시 값 입력

---

## 2. TO_DATE

### 목적

문자열을 날짜 타입(DATE)으로 변환한다.

### 기본 사용

```sql
TO_DATE('2025-01-01','YYYY-MM-DD')
```

### INSERT 예시

```sql
INSERT INTO MEMBER
VALUES(
    1,
    '홍길동',
    TO_DATE('2000-05-01','YYYY-MM-DD')
);
```

### 자주 사용하는 포맷

```sql
YYYY-MM-DD
YYYY/MM/DD
YYYYMMDD
YYYY-MM-DD HH24:MI:SS
```

예시

```sql
TO_DATE('2025-08-11 13:30:00',
        'YYYY-MM-DD HH24:MI:SS')
```

---

## 3. CHECK

### 목적

입력 가능한 데이터 범위를 제한한다.

### 점수 제한

```sql
SCORE NUMBER,
CONSTRAINT SCORE_CK
CHECK(SCORE BETWEEN 0 AND 100)
```

허용

```sql
50
80
100
```

불가

```sql
-1
120
```

---

### 학점 제한

```sql
GRADE NUMBER(2,1),
CONSTRAINT GRADE_CK
CHECK(GRADE BETWEEN 0 AND 4.5)
```

허용

```sql
3.5
4.0
4.5
```

불가

```sql
5.0
-1
```

---

### 특정 값만 허용

```sql
SEMESTER VARCHAR2(20),

CONSTRAINT SEMESTER_CK
CHECK(
    SEMESTER IN
    ('1학기','2학기','여름학기','겨울학기')
)
```

허용

```sql
1학기
2학기
여름학기
겨울학기
```

불가

```sql
3학기
가을학기
```

---

## 학습 포인트

* CONSTRAINT : 데이터 무결성 유지
* TO_DATE : 문자열 → DATE 변환
* CHECK : 입력 데이터 검증
* FOREIGN KEY 사용 시 부모 컬럼은 PRIMARY KEY 또는 UNIQUE 필요
* 날짜 비교 시 문자열보다 DATE 타입 사용 권장

# Oracle JOIN 학습 정리

## JOIN이란?

두 개 이상의 테이블을 연결하여 원하는 데이터를 조회하는 기법이다.

예를 들어 직원 정보는 EMP 테이블에 있고 부서 정보는 DEPT 테이블에 있을 때, 두 테이블을 연결하여 직원명과 부서명을 함께 조회할 수 있다.

---

# JOIN 작성 방식

## 1. Oracle 전용 방식

FROM 절과 WHERE 절 사용

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E,
     DEPT D
WHERE E.DEPTNO = D.DEPTNO;
```

---

## 2. ANSI 표준 방식

JOIN ~ ON 사용

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E
JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
```

현재 실무에서는 ANSI JOIN 사용을 권장한다.

---

# 1. Cross Join

모든 행을 조합하여 조회

### 특징

* Cartesian Product 발생
* 행 수 = 테이블1 행 수 × 테이블2 행 수

### 예시

```sql
SELECT *
FROM EMP
CROSS JOIN DEPT;
```

---

# 2. Equi Join

가장 많이 사용하는 조인

### 특징

* "=" 연산자로 조인
* 동일한 값을 기준으로 연결

### Oracle 방식

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E,
     DEPT D
WHERE E.DEPTNO = D.DEPTNO;
```

### ANSI 방식

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E
INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
```

---

# 3. Non-Equi Join

"=" 이 아닌 범위 조건으로 조인

### 특징

* BETWEEN
* > =
* <=

등을 사용

### 예시

```sql
SELECT E.ENAME,
       E.SAL,
       S.GRADE
FROM EMP E,
     SALGRADE S
WHERE E.SAL
BETWEEN S.LOSAL
    AND S.HISAL;
```

---

# 4. Outer Join

조인 조건에 만족하지 않는 데이터도 함께 조회

---

## Left Outer Join

왼쪽 테이블 기준

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E
LEFT OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
```

특징

* EMP는 모두 출력
* DEPT가 없으면 NULL 표시

---

## Right Outer Join

오른쪽 테이블 기준

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E
RIGHT OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
```

특징

* DEPT는 모두 출력
* EMP가 없으면 NULL 표시

---

## Full Outer Join

양쪽 모두 출력

```sql
SELECT E.ENAME,
       D.DNAME
FROM EMP E
FULL OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
```

특징

* 양쪽 테이블의 모든 데이터 출력

---

# 5. Self Join

같은 테이블을 자기 자신과 조인

### 특징

* 상사와 사원 관계 조회
* 조직도 조회

### 예시

```sql
SELECT E.ENAME AS 사원명,
       M.ENAME AS 관리자명
FROM EMP E,
     EMP M
WHERE E.MGR = M.EMPNO;
```

---

# 6. ANSI JOIN

ANSI 표준 JOIN 방식

---

## ANSI Inner Join

```sql
SELECT *
FROM EMP
INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;
```

---

## USING 사용

공통 컬럼명이 같을 경우

```sql
SELECT *
FROM EMP
JOIN DEPT
USING(DEPTNO);
```

특징

* 공통 컬럼을 한 번만 작성

---

# ANSI Outer Join

## LEFT OUTER JOIN

```sql
SELECT *
FROM EMP
LEFT OUTER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;
```

---

## RIGHT OUTER JOIN

```sql
SELECT *
FROM EMP
RIGHT OUTER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;
```

---

## FULL OUTER JOIN

```sql
SELECT *
FROM EMP
FULL OUTER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;
```

---

# RPAD 함수

문자열의 길이를 맞추기 위해 사용

### 문법

```sql
RPAD(값, 자릿수, 채울문자)
```

### 예시

```sql
SELECT RPAD(FIRST_NAME, 15, ' ')
FROM EMPLOYEES;
```

결과

```text
홍길동
김철수
박영희
```

뒤에 공백이 자동 추가되어 출력 길이가 동일해진다.

---

## RPAD 주의사항

```sql
RPAD(FIRST_NAME, 15, '')
```

Oracle에서는

```sql
'' = NULL
```

로 처리한다.

따라서 결과가 NULL이 될 수 있다.

공백을 사용하려면

```sql
RPAD(FIRST_NAME, 15, ' ')
```

처럼 작성해야 한다.

---

# 학습 정리

## 실무에서 가장 많이 사용하는 JOIN

### Inner Join

```sql
JOIN ~ ON
```

조인 조건에 만족하는 데이터만 조회

---

### Outer Join

```sql
LEFT OUTER JOIN
RIGHT OUTER JOIN
FULL OUTER JOIN
```

조인 조건에 만족하지 않는 데이터도 함께 조회

---

### 핵심 정리

* Cross Join : 모든 행 조합
* Equi Join : "=" 조건 조인
* Non-Equi Join : 범위 조건 조인
* Outer Join : 조건 불일치 데이터 포함
* Self Join : 자기 자신과 조인
* ANSI JOIN : 현재 표준 방식
* USING : 공통 컬럼명 사용
* RPAD : 문자열 길이 맞춤

