--사용자 계정 생성
--사용자를 생성하기 위해서는 DBA만 사용자르 생성할 수 있다.
--비밀번호는 대소문자 구분
CREATE USER javauser IDENTIFIED BY java1234;

--비밀번호 변경시
--ALTER USER javauser IDENTIFIED BY java1234;

--DCL
--권한 부여

-- GRANT 권한 하나씩하는거 아래걸로 쓰자.
GRANT CREATE SESSION TO javauser;

--GRANT 롤 to 사용자명 - 그룹으로 넣음. --왠만한 권한은 여기 구문에 다 있음.
GRANT CONNECT,RESOURCE TO javauser;

ALTER USER javauser
DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
--구문 해석
--1. ALTER USER
--사용자 정보를 변경하는 명령어
--ALTER USER javauser → javauser 계정의 설정을 변경
--2. DEFAULT TABLESPACE users
--기본 테이블스페이스 지정
--DEFAULT TABLESPACE users
--의미:
--javauser가 테이블을 생성하면
--기본적으로 USERS 테이블스페이스에 저장한다.
--USERS 테이블스페이스에 생성
--3. QUOTA UNLIMITED ON users
--USERS 테이블스페이스 사용량 제한 해제


-- role 권한 조회
SELECT * FROM role_sys_privs
WHERE role='CONNECT';

SELECT * FROM role_sys_privs
WHERE role='RESOURCE';

SELECT * FROM dba_role_privs
WHERE GRANTEE ='JAVAUSER';

SELECT * FROM tab;





