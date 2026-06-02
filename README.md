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
