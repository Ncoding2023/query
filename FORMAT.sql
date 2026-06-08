--포맷 FORMAT 형식변환

--날짜 형식 
--현재 날짜에서 연도 월 일만 각 각 출력
SELECT to_char(sysdate,'yyyy'),
    to_char(sysdate,'mm'),
    to_char(sysdate,'dd'),
    to_char(sysdate,'yyyy"년" mm"월" dd"일" day'),
    to_char(sysdate,'yyyy/mon/dd dy') -- 2026/6월 /05 금
FROM dual;

--오늘 날짜의 일수, 주차, 분기
SELECT to_char(sysdate,'ddd') as 올해일수,
    to_char(sysdate,'ww') as 올해주차,
    to_char(sysdate,'q') as 분기
FROM dual;

--현재 시간 출력
SELECT to_char(sysdate,'pm') as 오전오후,
    to_char(sysdate,'pm:hh:mi:ss') as 시간12시간형식,
    to_char(sysdate,'hh24"시"  mi"분"  ss"초"') as 시간24시간형식
FROM dual;
--오늘 날짜와 현재 시간 출력
SELECT to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') as 현재일시
FROM dual;

--숫자에 천단위 구분 기호 적용
SELECT to_char(1234,'9,999') as 숫자형식1,
to_char(123467,'fm999,999') as 숫자형식2,
to_char(123467890,'fm999,999,999') as 숫자형식3,
to_char(123467,'fml999,999') as 통화형식,
to_char(4,'fm9.0') as 소수형식
FROM dual;

--0 형식과 fm 형식 비교
SELECT to_char(1,'00') as 기본형식, to_char(1,'fm00') as 공백제거형식
FROM dual;

--9 형식과 fm 형식 비교
SELECT to_char(1,'99') as 기본형식, to_char(1,'fm99') as 공백제거형식
FROM dual;

--문자 숫자를 숫자형으로 변환
SELECT to_number('12345') as 결과 FROM dual;

--콤마가 포함된 문자 숫자를 숫자형으로 변환
SELECT to_number('12,345','99,999') as 결과 FROM dual;

--소수점이 포함된 문자 숫자를 숫자형으로 변환
SELECT to_number('12345.67','99999.99') as 결과 FROM dual;

--TO_NUMBER로 숫자형으로 변환
SELECT to_number('10,000','999,999') + to_number('20,000','999,999') as 합계 FROM dual;

--계산 결과를 다시 문자 형식으로 출력
SELECT to_char(
    to_number('10,000','999,999') + to_number('20,000','999,999'),
    'fm999,999') as 합계 FROM dual;

--nvl(컬럼 or 표현식,대체값) :  null을 0으로 변환하는 
SELECT null,nvl(null,0) FROM dual;    
    
--nvl2(컬럼 or 표현식,null이 아닐때 반환값,null일때 반환값)
SELECT null,nvl2(0,0,1),nvl2(null,0,1) FROM dual;    

--decode(표현식, 비교값1,결과값1, 비교값2,결과값2 ...,기본값)
SELECT decode(to_char(sysdate,'yyyy'),
'2024','재작년',
'2025','작년',
'2026','올해',
'기본값') FROM dual;    




--CASE/WHEN조건/THEN결과/ELSE조건과 다를때
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

