-- 10. 复合语句
-- 要求：
-- 创建数据库 cs，下面的操作都在这个数据库完成
create database if not exists cs;

use cs;
SELECT DATABASE();

-- 创建 employees 表，拥有 northwind.employees 表的所有数据
create table if not exists cs.employees as
select *
from northwind.employees;

select *
from cs.employees;

-- raise_salary 1-3 用 if 分支实现
-- 创建存储过程 raise_salary1，入口参数：员工编号。如果员工薪资低于 8000 元且工龄超过 5 年，涨薪 500 元，否则不变。
DELIMITER $
create procedure raise_salary1(in emp_id int) begin
declare s int;
    declare y DOUBLE(8, 2);

    select salary,
        datediff(now(), hire_date) / 365 into s,
        y
    from cs.employees
    where employee_id = emp_id;

    if s < 8000
    and y > 5 then
    update cs.employees
    set salary = salary + 500
    where employee_id = emp_id;
    end if;
end $ DELIMITER;

-- 确认该存储过程创建成功
-- 调用该存储过程并传入员工编号 104
-- 检查 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
select first_name,
    salary
from cs.employees
where employee_id = 104;

call cs.raise_salary1(104);

select first_name,
    salary
from cs.employees
where employee_id = 104;

-- 创建存储过程 raise_salary2，入口参数：员工编号。
--如果员工薪资低于 9000 元且工龄超过 5 年，涨薪 500 元；否则涨薪 100 元。
DELIMITER $
create procedure raise_salary2(in emp_id int)
begin
    DECLARE s double(8, 2);
    DECLARE y double(8, 2);

    select salary, DATEDIFF(now(), hire_date) / 365 into s, y
    from cs.employees
    where employee_id = emp_id;

    if s < 9000 and y > 5 then
        update cs.employees set salary = s + 500 where employee_id = emp_id;
    else
        UPDATE cs.employees set salary = s + 100 where employee_id = emp_id;
    end if;
end $
DELIMITER ;
-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 103 和 104
-- 检查 103 和 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
select employee_id,
    salary,
    DATEDIFF(now(), hire_date) / 365
from cs.employees
where employee_id in (103, 104);
-- 103 9000.00 33.3726
-- 104 8000.00 31.9945

call raise_salary2(103);
call raise_salary2(104);
-- 103 9100.00 33.3726
-- 104 8500.00 31.9945

-- 创建存储过程 raise_salary3，入口参数：员工编号。
--如果员工薪资低于 9000 元且工龄超过 5 年，则涨薪到 9000，
--薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；
--其他涨薪 100 元。

use cs;

SELECT DATABASE();
DELIMITER $
CREATE  PROCEDURE raise_salary3(in emp_id int)
BEGIN
    DECLARE s double(8, 2);    -- salary
    DECLARE y DOUBLE(8, 2);    --year
    DECLARE c DOUBLE(2, 2);    -- commission_pct

    SELECT salary, DATEDIFF(NOW(), hire_date) / 365, commission_pct into s, y, c
    FROM cs.employees
    WHERE employee_id = emp_id;

    if s < 9000 and y > 5 then
        UPDATE cs.employees set salary = 9000 where employee_id = emp_id;
    elseif s > 9000 and s < 10000 and c is null then
        UPDATE cs.employees set salary = s + 500 where employee_id = emp_id;
    else
        UPDATE cs.employees set salary = s + 100 where employee_id = emp_id;
    end if;
END $
DELIMITER ;

-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 102、103 和 104
-- 检查 102、103 和 104 编号的员工在调用存储过程前后工资的变化，
--确认存储过程执行是否成功
select employee_id,
    salary
from cs.employees
where employee_id in (102, 103, 104);
/*
    102    17000.00
    103    9100.00
    104    8500.00
*/

call raise_salary3(102);
call raise_salary3(103);
call raise_salary3(104);

/*
    102    17400.00
    103    10300.00
    104    10100.00
*/


-- raise_salary 4-5 用 case 分支实现
-- 创建存储过程 raise_salary4，入口参数：员工编号。如果员工薪资低于 9000 元，则涨薪到 9000，
-- 薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。

drop PROCEDURE raise_salary4;

DELIMITER $

CREATE PROCEDURE raise_salary4(in emp_id int)
BEGIN
    DECLARE s DOUBLE(8, 2);    -- salary
    DECLARE c DOUBLE(8, 2);    -- commission_pct
    SELECT salary into s FROM cs.employees WHERE employee_id = emp_id;

    CASE
        WHEN s < 9000 THEN
            UPDATE cs.employees set salary = 9000 WHERE employee_id = emp_id;
        WHEN s > 9000 and s < 10000 and c is null THEN
            UPDATE cs.employees SET salary = s + 500 WHERE employee_id = emp_id;
        ELSE
            UPDATE cs.employees SET salary = s + 100 WHERE employee_id = emp_id;
    END case;

END$

DELIMITER ;
-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 101、104 和 105
-- 检查 101、104 和 105 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
select employee_id, salary, commission_pct
from cs.employees
where employee_id in (101, 104, 105);
/*
    101    17100.00
    104    10500.00
    105    4800.00
*/

call raise_salary4(101);
call raise_salary4(104);
call raise_salary4(105);


-- 创建存储过程 raise_salary5，入口参数：员工编号。如果员工工龄是 0 年，涨薪 50；
-- 如果工龄是 1 年，涨薪 100；如果工龄是 2 年，涨薪 200；如果工龄是 3 年，涨薪 300；
-- 如果工龄是 4 年，涨薪 400；其他的涨薪 500。
drop PROCEDURE raise_salary5;
DELIMITER $
create PROCEDURE raise_salary5(in emp_id int)
begin
    DECLARE s DOUBLE(8, 2);
    DECLARE y DOUBLE(8, 2);

    SELECT salary, DATEDIFF(NOW(), hire_date) / 365 into s, y
    FROM cs.employees
    WHERE employee_id = emp_id;

    case
        WHEN y >= 5 THEN
            UPDATE cs.employees set salary = s + 500 WHERE employee_id = emp_id;
        WHEN y >= 4 THEN
            UPDATE cs.employees set salary = s + 400 WHERE employee_id = emp_id;
        WHEN y >= 3 THEN
            UPDATE cs.employees set salary = s + 300 WHERE employee_id = emp_id;
        WHEN y >= 2 THEN
            UPDATE cs.employees set salary = s + 200 WHERE employee_id = emp_id;
        WHEN y >= 1 THEN
            UPDATE cs.employees set salary = s + 100 WHERE employee_id = emp_id;
        WHEN y >= 0 THEN
            UPDATE cs.employees set salary = s + 50 WHERE employee_id = emp_id;
        END CASE;
end$

DELIMITER ;

-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 101、104 和 105
-- 检查 101、104 和 105 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
SELECT employee_id, salary, DATEDIFF(now(), hire_date) / 365 FROM cs.employees WHERE employee_id in (101, 104, 105);
/*
    101    18500.00
    104    12000.00
    105    9300.00
*/
call raise_salary5(101);
call raise_salary5(104);
call raise_salary5(105);

-- 下面的功能分别用 loop、while 和 repeat 实现
-- 创建存储函数 factorial，计算 n!，入口参数 n，返回值 n! = 1 × 2 × ... × n
-- 确认该存储函数创建成功
-- 调用该存储函数，确认该存储函数执行是否成功

show VARIABLES like 'log_bin_trust_function_creators';
set GLOBAL log_bin_trust_function_creators = on;
DELIMITER $
create FUNCTION factorial1(n int)
returns int
begin
    DECLARE i int DEFAULT 2;
    DECLARE result int DEFAULT 1;

    WHILE i <= n do
        set result = result * i;
        set i = i + 1;
    end WHILE;

    return (select result);
end$
DELIMITER ;

SELECT factorial1(5);    -- 120
----------------------------------------------------------------------------------

drop FUNCTION factorial2;
DELIMITER $
create FUNCTION factorial2(n int)
returns int
begin
    DECLARE i int DEFAULT 2;
    DECLARE result int DEFAULT 1;

    lp: LOOP
        set result = result * i;
        set i = i + 1;
        if i > n then
            leave lp;
        end if;
    end loop lp;

    return (select result);
end$
DELIMITER ;

SELECT factorial2(5);    -- 120
----------------------------------------------------------------------------------

drop FUNCTION factorial3;
DELIMITER $
create FUNCTION factorial3(n int)
returns int
begin
    DECLARE i int DEFAULT 2;
    DECLARE result int DEFAULT 1;

    REPEAT
        set result = result * i;
        set i = i + 1;
    UNTIL i > n
    end REPEAT;
    return (select result);
end$
DELIMITER ;

SELECT factorial3(5);    -- 120

-- 创建存储过程 pyramid，入口参数 n，输出 n 层法老的金字塔，当 n = 3 时，金字塔如下：
--   *
--  ***
-- *****
-- Copy
-- 确认该存储过程创建成功
-- 调用该存储过程，确认该存储过程执行是否成功
use cs;
SELECT DATABASE();
drop PROCEDURE pyramid;
DELIMITER $
create PROCEDURE pyramid(n int)
begin
    DECLARE res varchar(10000) DEFAULT '\r\n';
    DECLARE i int DEFAULT 1;
    REPEAT
        set res = CONCAT(res, repeat(' ', n - i), repeat('*', 2 * i - 1), '\r\n');
        set i = i + 1;
        UNTIL i > n
    END REPEAT;
    SELECT res;
end$

DELIMITER ;

show create procedure pyramid;
-- show procedure status where db = 'cs';
show procedure status where `name` = 'pyramid';
select * from information_schema.routines
where routine_name = 'pyramid';

call pyramid(10);

-- 创建存储过程 mult_talbe，输出九九乘法表
-- 确认该存储过程创建成功
-- 调用该存储过程，确认该存储过程执行是否成功
drop PROCEDURE mult_table;
DELIMITER $
CREATE PROCEDURE mult_table(n int)
BEGIN
    DECLARE i int DEFAULT 1;
    DECLARE j int DEFAULT 1;
    DECLARE res varchar(16383) DEFAULT '\r\n';

    WHILE i <= n do
        set j = 1;
        WHILE j <= i do
            set res = CONCAT(res, j, ' * ', i, ' = ', i * j, '  ');
            set j = j + 1;
        END WHILE;
        set res = concat(res, '\r\n');
        set i = i + 1;
    end while;
    SELECT res;
END$
DELIMITER;


-- 声明存储过程 raise_salary6，给全体员工涨薪，每次涨幅为 10%，直到全公司的平均薪资达到 12000 为止,
-- 返回上涨次数。
-- 确认该存储过程创建成功
-- 调用该存储过程，确认该存储过程执行是否成功

drop procedure raise_salary6;
delimiter $
create procedure raise_salary6(out cnt int)
begin
    declare c int default 0;
    while (select min(salary) from cs.employees) < 12000 do
        update cs.employees set salary = salary * 1.1;
        set c = c + 1;
    end while;
    set cnt = c;
end $
delimiter ;

set @cnt = 0;
select @cnt;
call raise_salary6(@cnt);

-- 创建存储函数 get_count，计算薪资最高员工的工资之和达到 total_salary 的人数
-- 调用该存储函数，确认该存储函数执行是否成功
set GLOBAL log_bin_trust_function_creators = on;

drop FUNCTION get_count;

DELIMITER $
create FUNCTION get_count(total_salary double(8, 2))
returns INT
begin
    DECLARE ss DOUBLE(8, 2) DEFAULT 0.0;    -- sum_salary
    DECLARE c int DEFAULT 0;    -- count
    lp: loop
        set c = c + 1;
        SELECT SUM(salary) into ss 
        FROM (
                SELECT salary
                FROM cs.employees
                order by salary desc
                LIMIT 0, c
            ) as sal;
        if ss >= total_salary then
            leave lp;
        end if;
    end loop lp;
    return (SELECT c);
end $
DELIMITER ;

SELECT get_count(57000);

select employee_id, first_name, salary
from cs.employees
order by salary desc
limit 0, 10;

use cs;
SELECT DATABASE();

-- 将上面的 SQL 代码放到 02-sql 目录下的 15-compound-statemnet.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库