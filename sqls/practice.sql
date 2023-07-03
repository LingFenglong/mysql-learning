select database();
use JEE;
select user, host from mysql.user;

SET GLOBAL validate_password.length=6;
SET GLOBAL validate_password.policy=LOW;
-- DCL 用户管理，权限管理
create user 'zhangsan'@'localhost' identified by '123456';
-- alter user 'zhangsan'@'localhost' identified by 'abcdef';
set password for 'zhangsan'@'localhost' = '123456';
rename user 'zhangsan'@'localhost' to 'lisi'@'localhost';
rename user 'lisi'@'localhost' to 'zhangsan'@'localhost';
select user, host from mysql.user;
drop user 'zhangsan'@'localhost';

grant all privileges on *.* to 'zhangsan'@'localhost';
revoke all privileges on *.* from 'zhangsan'@'localhost';

-- 视图 创建视图 查询：简单查询，复杂查询
create view v_emp as
select * from northwind.employees;
select * from v_emp;

create view emps as
select e.employee_id, e.first_name, d.department_id, d.department_name
from northwind.employees as e
left join northwind.departments as d
on e.department_id = d.department_id;
select * from emps;

-- 触发器 create triger ...
drop table if exists JEE.trigger_test;
create table if not exists trigger_test(
    id int primary key auto_increment,
    info varchar(255),
    deleted boolean default false
);

create table if not exists trigger_test_delete_log(
    id int primary key auto_increment,
    info varchar(255),
    deleted boolean default false
);
drop trigger if exists after_delete;
delimiter $
create trigger after_delete
after delete on JEE.trigger_test for each row
begin
    insert into JEE.trigger_test_delete_log
    values (old.id, old.info, true);
end $
delimiter ;

insert into JEE.trigger_test (info)
values ('This is info');
select * from JEE.trigger_test;
delete from JEE.trigger_test where id = 3;

select * from JEE.trigger_test_delete_log;


-- 存储过程、存储函数（结合复合语句分支、循环）
delimiter $
create procedure if not exists procedure1(in n int)
begin
    declare i int default 1;
    while i < n do
        select i;
        set i = i + 1;
    end while;
end $
delimiter ;

call procedure1(100);

-- DML （增删改）
update JEE.trigger_test set id = 1 where id = 6;
insert into JEE.trigger_test(id, info, deleted)
values (1000, 'innnnnnnnnnnnnnnnnnfoooo', false);
delete from JEE.trigger_test where id = 1000;
select * from JEE.trigger_test;
insert into JEE.trigger_test(info)
values ('innnnnnnnnnnnnnnnnnfoooo');

-- 多表查询（连接）多种连接方案，各种连接
-- from a join b on a.ca ? b.cb