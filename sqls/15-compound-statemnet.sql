-- 10. 复合语句

-- 要求：

-- 创建数据库 cs，下面的操作都在这个数据库完成

create database if not exists cs;

use cs;

-- 创建 employees 表，拥有 northwind.employees 表的所有数据

create table
    if not exists cs.employees as
select *
from northwind.employees;

select * from cs.employees;

-- raise_salary 1-3 用 if 分支实现

-- 创建存储过程 raise_salary1，入口参数：员工编号。如果员工薪资低于 8000 元且工龄超过 5 年，涨薪 500 元，否则不变。
DELIMITER $
create procedure raise_salary1(in emp_id int)
begin
    declare s int;
    declare y DOUBLE(8, 2);

    select
        salary,
        datediff(now(), hire_date) / 365 into s, y
    from cs.employees
    where employee_id = emp_id;

    if s < 8000 and y > 5 then
        update cs.employees
        set salary = salary + 500
        where employee_id = emp_id;
    end if;
end $ DELIMITER;

-- 确认该存储过程创建成功
-- 调用该存储过程并传入员工编号 104

select first_name,
    salary
from cs.employees
where employee_id = 104;

call cs.raise_salary1(104);

select first_name, salary
from cs.employees
where employee_id = 104;

-- 检查 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功


-- 创建存储过程 raise_salary2，入口参数：员工编号。
--如果员工薪资低于 9000 元且工龄超过 5 年，涨薪 500 元；否则涨薪 100 元。
DELIMITER $
CREATE PROCEDURE raise_salary2(in emp_id)
BEGIN
    
END

-- 确认该存储过程创建成功

-- 调用该存储过程并分别传入员工编号 103 和 104

-- 检查 103 和 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功

-- .

-- 创建存储过程 raise_salary3，入口参数：员工编号。如果员工薪资低于 9000 元且工龄超过 5 年，则涨薪到 9000，薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。

-- 确认该存储过程创建成功

-- 调用该存储过程并分别传入员工编号 102、103 和 104

-- 检查 102、103 和 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功

-- .

-- raise_salary 4-5 用 case 分支实现

-- 创建存储过程 raise_salary4，入口参数：员工编号。如果员工薪资低于 9000 元，则涨薪到 9000，薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。

-- 确认该存储过程创建成功

-- 调用该存储过程并分别传入员工编号 101、104 和 105

-- 检查 101、104 和 105 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功

-- .

-- 创建存储过程 raise_salary5，入口参数：员工编号。如果员工工龄是 0 年，涨薪 50；如果工龄是 1 年，涨薪 100；如果工龄是 2 年，涨薪 200；如果工龄是 3 年，涨薪 300；如果工龄是 4 年，涨薪 400；其他的涨薪 500。

-- 确认该存储过程创建成功

-- 调用该存储过程并分别传入员工编号 101、104 和 105

-- 检查 101、104 和 105 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功

-- .

-- 下面的功能分别用 loop、while 和 repeat 实现

-- 创建存储函数 factorial，计算 n!，入口参数 n，返回值 n! = 1 × 2 × ... × n

-- 确认该存储函数创建成功

-- 调用该存储函数，确认该存储函数执行是否成功

-- .

-- 创建存储过程 pyramid，入口参数 n，输出 n 层法老的金字塔，当 n = 3 时，金字塔如下：

--   *

--  ***

-- *****

-- Copy

-- 确认该存储过程创建成功

-- 调用该存储过程，确认该存储过程执行是否成功

-- .

-- 创建存储过程 mult_talbe，输出九九乘法表

-- 确认该存储过程创建成功

-- 调用该存储过程，确认该存储过程执行是否成功

-- .

-- 声明存储过程 raise_salary6，给全体员工涨薪，每次涨幅为 10%，直到全公司的平均薪资达到 12000 为止，返回上涨次数。

-- 确认该存储过程创建成功

-- 调用该存储过程，确认该存储过程执行是否成功

-- .

-- 创建存储函数 get_count，计算薪资最高员工的工资之和达到 total_salary 的人数

-- 调用该存储函数，确认该存储函数执行是否成功

-- .

-- 将上面的 SQL 代码放到 02-sql 目录下的 15-compound-statemnet.sql 文件中

-- 提交代码仓库，推送到 bitbucket 远程代码仓库