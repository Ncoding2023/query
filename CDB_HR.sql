--학생예제

SELECT * FROM student;

CREATE TABLE STUDENT(
    NO NUMBER NOT NULL PRIMARY KEY,
    SD_NUM GENERATED ALWAYS AS (TO_CHAR(SD_BIRTH,'YY') || S_NUM || '000' ||NO) VIRTUAL NOT NULL, 
    SD_NAME VARCHAR2(30),
    SD_ID VARCHAR2(50)UNIQUE,
    SD_PASSWD VARCHAR2(50),
    S_NUM VARCHAR2(2),  --학과번호
    SD_BIRTH DATE,
    SD_ADDRESS VARCHAR2(150),
    SD_EMAIL GENERATED ALWAYS AS (SD_ID || '@naver.com') VIRTUAL,
    SD_DATE DATE DEFAULT SYSDATE,
    FOREIGN KEY (S_NUM) REFERENCES SUBJECT(S_NUM)
);

SELECT * FROM tab;

SELECT * FROM subject;  //학과
SELECT * FROM student;  //학생
SELECT * FROM COURSE;      //과목
SELECT * FROM ENROLLMENT;  //수강

SELECT st.sd_num,st.sd_name,sj.s_num,sj.s_name
FROM student st JOIN subject sj on st.s_num = sj.s_num
;


















