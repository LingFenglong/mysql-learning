-- # compound statement

-- ## variable

show variables like 'datadir';
show variables like 'autocommit';
show variables like '%character%';

-- 系统变量
-- 全局变量
show global variables;
SELECT @@global.datadir;

-- 会话变量
show session variables;
SELECT @@session.datadir;

-- 修改全局变量
-- set @@global.var_name = value
set autocommit = 0;
show global variables like 'autocommit';
show session variables like 'autocommit';

SELECT *
FROM performance_schema.threads;

delimiter $
create procedure pd1()
begin
    declare abc int default 0;
    set abc = 100;
    select abc;
end $
delimiter ;

-- ## flow control

-- 一、分支结构之 if
if condition then
    block
end if;

if condition then
    block
else
    block
end if;

if condition1 then
    block
else if condition2 then
    block
else
    block
end if;

-- 二、分支结构之 case

case field
    when constant1 then statement1
    when constant2 then statement2
    ...
    else
        statement
end case;

case
    when condition1 then statement1
    when condition2 then statement2
    ...
    else
        statement
end case;

-- 三、循环结构之 loop


-- 四、循环结构之 while


-- 五、循环结构之 repeat

delimiter $
create function factorial(n int) returns int
    declare i int default 1
    declare res int default 1

    while i<=n do
        set res = res * i
        set i = i + 1
    end while;

    return(res);
end $
delimiter ;

-- 六、leave 的使用
-- break 跳出循环

-- 七、iterate 的使用
-- continue 跳出本次循环

-- ## error handle

-- ## cursor
repeat

    until
end repeat;
