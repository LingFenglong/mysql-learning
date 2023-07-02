-- Active: 1682641859113@@192.168.144.131@3306@JEE
CREATE DATABASE IF NOT EXISTS term_end;
USE term_end;
SELECT DATABASE();
SET GLOBAL validate_password.length=6;
SET GLOBAL validate_password.policy=LOW;


-- DCL 用户管理，权限管理
-- 修改host
update mysql.`user` set host = '192.168.%' where user = 'lingfenglong' and host = '%';
flush privileges;

-- 创建 MySQL 用户，用户名：自己姓名的拼音，密码：123456
CREATE USER 'LingFenglong'@'localhost' IDENTIFIED BY '123456';

-- 查看创建的用户
SELECT user, host from mysql.`user`;
SELECT * FROM mysql.`user` WHERE USER = 'LingFenglong';

-- 查看当前登录用户
SELECT USER();
SELECT current_user();

-- 修改用户 zhang3 为 li4，刷新权限
create user 'zhang3'@'localhost' identified by '123456';
rename user 'zhang3'@'localhost' to 'lisi'@'localhost';
update mysql.`user` set user = 'li4' where user = 'zhang3';


FLUSH PRIVILEGES;


-- 用 drop 关键字删除 li4 用户
drop user 'lisi'@'localhost';
drop user 'zhang3'@'localhost';

-- 创建 zhang3 用户，用 delete 关键字删除 zhang3 用户，刷新权限
create user 'zhang3'@'localhost' identified by '123456';
delete from mysql.`user` WHERE user = 'zhang3';
flush privileges;

-- 用 alter 关键字修改当前用户（root）的密码，重新登录 MySQL
ALTER USER 'zhang3'@'localhost' IDENTIFIED BY 'password';

-- 用 set 关键字修改当前用户（root）的密码，重新登录 MySQL
SET PASSWORD FOR 'zhang3'@'localhost' = '1234567';

-- 列出 MySQL 的所有权限
show privileges;

-- 授予自己姓名用户 northwind 库所有表的增、删、改、查权限，用自己姓名用户登录 MySQL，查询 northwind
select user, host from mysql.user;
grant insert, delete, update, select on *.* to 'LingFenglong'@'localhost';

-- 授予自己姓名用户所有库所有表的权限，用自己姓名用户名登录 MySQL，建库、查询 northwind
grant all privileges on *.* to 'LingFenglong'@'localhost';

-- 查看当前用户的权限
-- 查看 root 或自己姓名账户的权限
show grants for current_user;
show grants for 'LingFenglong'@'localhost';

-- 收回自己姓名用户的所有权限，用自己姓名用户登录 MySQL
revoke all privileges on *.* from 'zhang3'@'localhost';

----------------------------------------------------------------------------------------------------------

-- 视图 创建视图 查询：简单查询，复杂查询
-- 创建数据库 vw，下面操作都在这个数据库中完成
show databases;
drop database if exists vm;
create database if not exists vw;
use vw;
select database();

-- 创建 emps 表，拥有 northwind.employees 表的所有数据
create table if not exists emps as
select * from northwind.employees;

-- 创建 depts 表，拥有 northwind.departments 表的所有数据
create table if not exists depts as
select * from northwind.departments;

drop table if exists vw.depts;

-- 检查两个表中的数据，确保与源表的数据相同
select * from vw.emps;
select * from vw.depts;

-- 创建 v_emp1 视图，包含 emps 表中的员工编号、名字和薪水三个字段
create view v_emp1 as
select employee_id, first_name, salary
from vw.emps;

-- 检查 v_emp1 视图的所有数据，确保跟 emps 表中的记录数相同
select * from vw.v_emp1;

-- 创建 v_emp2 视图，包含 emps 表中月薪大于 8000 的员工，其编号(emp_id)，名字(name)和薪水
create view v_emp2 as
select employee_id as emp_id, first_name as `name`
from vw.emps where salary > 8000;

-- 检查 v_emp2 视图中的所有数据
select * from vw.v_emp2;

-- 创建 v_emp_sal 视图，包含 emps 表中的部门编号和该部门的平均工资(avg_sal)，不包含部门编号为 null 的数据
create view v_emp_sal as
select department_id, avg(salary) as avg_sal
from vw.emps
where department_id is not null
group by department_id;

-- 检查 v_emp_sal 视图的所有数据
select * from vw.v_emp_sal;

-- 创建 v_emp_dept 视图，包含 emps 表中的员工编号和部门编号以及 depts 表中的部门名称
create view v_emp_dept as
select employee_id, d.department_id, department_name
from vw.emps as e
join vw.depts as d
on e.department_id = d.department_id;

-- 检查 v_emp_dept 视图的所有数据
select * from vw.v_emp_dept;

-- 创建 v_emp4 视图，包含 v_emp1 视图中的员工编号和员工名字两个字段
create view v_emp4 as
select employee_id, first_name from v_emp1;

-- 检查 v_emp4 视图的所有数据
select * from vw.v_emp4;

-- 查看 vw_test 数据库中的表对象和视图对象
show tables from vw;

-- 查看 v_emp1 视图的结构
desc vw.v_emp1;

-- 查看 v_emp1 视图的状态信息
show table status from vw like 'v_emp1';

-- 查看 v_emp1 视图的详细定义信息
-- 修改 v_emp1 视图的数据，将编号为 101 的员工，月薪改为 20000
-- 检查 v_emp1 视图的数据，确保修改成功
-- 检查 emps 表，查看 101 编号的员工薪水
-- 修改 emps 表中的数据，将编号为 101 的员工，月薪改为 10000
-- 检查 emps 表的数据，确保修改成功
-- 检查 v_emp1 表，查看 101 编号的员工薪水
-- 删除 v_emp1 视图中的数据，将编号为 101 的员工信息删除
-- 检查 v_emp1 视图的数据，确保修改成功
-- 检查 emps 表，查看 101 编号的员工信息
-- 在 v_emp_sal 视图中，将编号为 30 的部门，平均工资改为 5000，修改是否成功，为什么
-- 在 v_emp_sal 视图中，删除编号为 30 的部门信息，修改是否成功，为什么
-- 修改 v_emp1 视图，包含工资大于 7000 的员工编号，名字，工资和 email 字段
-- 删除 v_emp4 视图，删除前后分别查看 vw_test 库中的所有表和视图，确认删除成功

----------------------------------------------------------------------------------------------------------

-- 触发器 create triger ...
-- 做下面的准备工作
-- 创建数据库 tg（下面的操作都在这个数据库完成）
-- 检查 tg 数据库是否创建成功
drop database if exists tg;
create database if not exists tg;
use tg;

-- 创建表 tb_tg，包括两个字段：id 字段（int、主键、自增）和 note 字段（varchar(20)）
create table tb_tg(
    id int primary key auto_increment,
    note varchar(20)
);

-- 创建表 tb_tg_log，包括两个字段：id 字段（int、主键、自增）和 log 字段（varchar(40)）
create table if not exists tb_tg_log(
    id int primary key auto_increment,
    `log` varchar(40)
);

-- 创建表 employees，包括四个字段：employee_id, first_name, salary 和 manager_id，数据来自 northwind.employees
create table if not exists employees as
select employee_id, first_name, salary, manager_id
from northwind.employees;

-- 检查三个表的结构
desc tb_tg;
desc tb_tg_log;
desc employees;

-- 创建名为 after_insert 的触发器，在 tb_tg 表插入数据后，向 tb_tg_log 表中插入日志信息
-- 日志信息的格式是：[datetime insert]: note，datetime 代表 insert 发生的当前日期和时间，下同
delimiter $
create trigger if not exists after_insert
after insert on tg.tb_tg for each row
begin
    insert into tg.tb_tg_log(`log`)
    values(concat('[', now(), ' insert]: ', new.note));
end $
delimiter ;

-- 查看该触发器，确认创建成功
-- 在 tb_tg 表添加一条日志，内容随意
-- 查看 tb_tg 和 td_tg_log 表的数据，确认触发器正常工作
insert into tg.tb_tg(note) VALUES('hello');
select * from tg.tb_tg;
select * from tg.tb_tg_log;

-- 创建名为 after_delete 的触发器，在 tb_tg 表删除数据后，向 tb_tg_log 表中插入日志信息
-- 日志信息的格式是：[datetime delete]: note
-- 查看该触发器，确认创建成功
-- 在 tb_tg 表删除一条日志
-- 查看 td_tg 和 td_tg_log 表的数据，确认触发器正常工作
delimiter $
create trigger if not exists after_delete
after delete on tg.tb_tg for each row
begin
    insert into tg.tb_tg_log(`log`)
    values(concat('[', now(), ' delete]: ', old.note));
end $
delimiter ;

delete from tg.tb_tg;

select * from tg.tb_tg_log;

-- 定义触发器 salary_check，在员工表添加新员工前检查其薪资是否大于他领导的薪资
-- 如果员工薪资大于其领导薪资，则报 sqlstate 为 45000 的错误
-- 查看该触发器，确认创建成功
-- 在员工表表添加一条记录，做通过性测试，检查员工表的数据
-- 在员工表表添加一条记录，做失效性测试，检查员工表的数据
-- 确认这个触发器能正常工作
delimiter $
create trigger if not exists salary_check
before insert on tg.employees for each row
begin
    declare manager_sal double(8, 2);
    select salary into manager_sal from tg.employees where employee_id = new.manager_id;
    if new.salary > manager_sal then
        signal sqlstate '45000' set message_text = 'ERROR: 薪资高于领导薪资', mysql_errno = 1001;
    end if;
end $
delimiter ;

-- 分别用三种方式查看上面创建的某个触发器
-- 删除上面创建的三个触发器

----------------------------------------------------------------------------------------------------------

-- 存储过程、存储函数（结合复合语句分支、循环）
-- 创建数据库 pf，下面的操作都在这个数据库完成
drop database if exists pf;
create database if not exists pf;
use pf;
select database();
-- 创建存储过程 all_data，查询 employees 表的所有数据，调用该存储过程，验证其功能是否正确
delimiter $
create procedure pf.all_data()
begin
    select * from northwind.employees;
end $
delimiter ;
call pf.all_data();

-- 创建存储过程 avg_salary，查询 employees 表所有员工的平均工资
delimiter $
create procedure avg_salary()
begin
    select avg(salary) as avg_salary
    from northwind.employees;
end $
delimiter ;

call avg_salary();

-- 创建存储过程 max_salary，查询 employees 表的最高工资
delimiter $
create procedure max_salary()
begin
    select max(salary) as max_salary
    from northwind.employees;
end $
delimiter ;

call pf.max_salary;

-- 创建存储过程 min_salary，查询 employees 表的最低工资，并将最低工资通过参数 minSalary 输出
drop procedure if exists min_salary;
delimiter $
create procedure min_salary(inout minSalary double(8, 2))
begin
    select min(salary) into minSalary
    from northwind.employees;
end $
delimiter ;
declare min_sal;
set @min_salary := 0;
call pf.min_salary(@min_salary);
select @min_salary;

-- 创建存储过程 get_salary_by_id，查询 employees 表某员工的工资，入口参数是 emp_id 员工编号
delimiter $
create procedure get_salary_by_id(emp_id int)
begin
    select salary from northwind.employees where employee_id = emp_id;
end $
delimiter ;

call pf.get_salary_by_id(100);

-- 创建存储过程 get_salary_by_name，查询 employees 表某员工的工资，入口参数是 emp_name 员工名字，出口参数是 salary 该员工的工资
-- 创建存储过程 get_mgr_name，查询 employees 表中某员工领导的名字，参数 name 同时作为输入的员工名字和输出的领导名字


-- 创建存储函数 avg_salary，返回 employees 表所有员工的平均工资
show variables like 'log_bin_trust_function_creators';
set global log_bin_trust_function_creators= on;
drop function if exists avg_salary;
delimiter $
create function avg_salary()
returns double(8, 2)
begin
    return (select avg(salary) from northwind.employees);
end $
delimiter ;

select avg_salary();

-- 创建存储函数 get_mgr_name，返回 employees 表中某员工名字的领导的名字
delimiter $
create function get_mgr_name(`name` varchar(50))
returns varchar(50)
begin
    return (
        select first_name from northwind.employees where employee_id = (
            select manager_id from northwind.employees where first_name = name
        )
    );
end $
delimiter ;

select * from northwind.employees;
select get_mgr_name('Lex');

-- 创建存储函数 get_count_by_dept_id，返回 employees 表某部门编号的部门员工人数
delimiter $
create function get_count_by_dept_id(id int)
returns int
begin
    return (
        select count(*) from northwind.employees where department_id = id
    );
end $
delimiter ;

select get_count_by_dept_id(100);
----------------------------------------------------------------------------------------------------------

-- DML （增删改）
-- 创建数据库 store，验证数据库是否创建成功
-- 创建表 books，表结构如下：
-- id int
-- name varchar(50)
-- authors varchar(100)
-- price float
-- pubdate year
-- category varchar(100)
-- num int
-- 查看 books 表结构
-- 查询 books 表中记录
create database if not exists store;
use store;
show tables;
drop table store.books;

create table if not exists books(
    id int,
    name varchar(50),
    authors varchar(100),
    price float,
    pubdate year,
    category varchar(100),
    num int
);
desc books;

-- books 表中数据如下
-- id, name, authors, price, pubdate, category, num
-- 1, 看见, 柴静, 39.8, 2013, novel, 13
-- 2, 我的天才女友, [意] 埃莱娜·费兰特, 42, 2017, joke, 22
-- 3, 局外人, [法] 阿尔贝·加缪, 22, 2010, novel, 0
-- 4, 步履不停, [日] 是枝裕和, 36.8, 2017, novel, 30
-- 5, 法学导论, [德] 古斯塔夫·拉德布鲁赫, 30, 2001, law, 10
-- 6, 本草纲目, 李时珍, 30, 1990, medicine, 40
-- 7, 火影忍者, [日] 岸本齐史, 88, 1999, cartoon, 28
-- 不指定字段名称，向 books 表插入 id 为 1 的记录
insert into store.books values(1, '看见', '柴静', 39.8, 2013, 'novel', 13);

-- 指定所有字段名称，向 books 表插入 id 为 2 的记录
insert into store.books(id, name, authors, price, pubdate, category, num)
values(2, '我的天才女友', '[意] 埃莱娜·费兰特', 42, 2017, 'joke', 22);

-- 向 books 表同时插入剩余所有记录
insert into store.books values(3, '局外人', '[法] 阿尔贝·加缪', 22, 2010, 'novel', 0),
(4, '步履不停', '[日] 是枝裕和', 36.8, 2017, 'novel', 30),
(5, '法学导论', '[德] 古斯塔夫·拉德布鲁赫', 30, 2001, 'law', 10),
(6, '本草纲目', '李时珍', 30, 1990, 'medicine', 40),
(7, '火影忍者', '[日] 岸本齐史', 88, 1999, 'cartoon', 28);

insert into store.books(id, name, authors, price, pubdate, category, num)
values(2, '我的火', '[意] 埃莱娜·费兰特', 42, 2017, 'joke', 22);

delete from store.books;

select * from store.books;

-- 将小说类型图书的价格增加 5 元
update store.books
set price = price + 5 where category = 'novel';

-- 将局外人图书的价格改为 40，并将类别改为 memoir
update store.books
set price = 40, category = 'memoir'
where name = '局外人';

-- 删除库存为 0 的图书
delete from store.books
where num = 0;

select * from store.books where num = 0;

-- 查找书名中包含火的图书
select * from store.books where name like '%火%';

-- 统计书名中包含火的书的数量和库存总量
select count(*) as book_count, sum(num) as num
from store.books
where name like '%火%';

-- 查找 novel 类型的书，按照价格降序排列
select * from store.books
where category = 'novel'
order by price desc;

-- 查询图书信息，按照库存量降序排列，如果库存量相同的按照 category 升序排列
-- 按照 category 分类统计书的数量
-- 按照 category 分类统计书的库存量，显示库存量超过 35 本的
-- 查询所有图书，每页显示 3 本，显示第二页
-- 按照 category 分类统计书的库存量，显示库存量最多的
-- 查询作者名称达到 7 个字符的书，不包括里面的空格
-- 查询书名和类型，其中 category 值为 novel 显示小说，law 显示法律，medicine 显示医药，cartoon 显示卡通，joke 显示笑话
-- 查询书名、库存，其中 num 值超过 30 本的，显示滞销，大于 0 并低于 10 的，显示畅销，为 0 的显示需要无货，其他显示正常
-- 统计每一种 category 的库存量，并合计总量
-- 统计每一种 category 的数量，并合计总量
-- 统计库存量前三名的图书
-- 找出最早出版的一本书
-- 找出 novel 中价格最高的一本书
-- 找出作者名中字数最多的一本书，不含空格

----------------------------------------------------------------------------------------------------------

-- 多表查询（连接）多种连接方案，各种连接
use northwind;
select database();
-- 查询员工名字和所在部门的名称
select first_name, department_name
from northwind.employees as e
left join northwind.departments as d
on e.department_id = d.department_id;

-- 查询员工名字、工种编号和工种名称
select e.first_name, e.job_id, j.job_title
from northwind.employees as e
left join jobs as j
on e.job_id = j.job_id;

-- 查询有提成员工的员工名字、部门名称和提成
select first_name, department_name, commission_pct
from northwind.employees as e
left join northwind.departments as d
on e.department_id = d.department_id
where commission_pct is not null;

-- 查询所在城市名中第二个字符为 o 的部门名称和城市名
select department_name, city
from northwind.departments as d
left join northwind.locations as l
on d.location_id = l.location_id
where city like '_o%';

-- 查询城市名称和该城市拥有的部门数量，过滤没有部门的城市
select city, count(*) as num
from northwind.locations as l
join northwind.departments as d
on l.location_id = d.location_id
group by city
having num != 0;

select *
from northwind.locations as l
join northwind.departments as d
on l.location_id = d.location_id;

-- 查询有提成的部门，部门名称、部门的领导编号和部门的最低工资 min_salary
select department_name, d.manager_id, min(salary) as min_salary
from departments as d
join employees as e
on d.department_id = e.department_id
where commission_pct is not null
group by department_name, d.manager_id;

-- 查询每个工种的工种名称和员工人数，并且按员工人数降序排序
select job_title, count(*) as num
from northwind.jobs as j
join northwind.employees as e
on j.job_id = e.job_id
group by job_title
order by num desc;

-- 查询员工名字、部门名称和所在的城市，并按部门名称降序排序
select e.first_name, d.department_name, l.city
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.locations as l
on d.location_id = l.location_id
order by d.department_name desc;

-- 查询员工的工资和工资级别
select salary, grade_level
from northwind.employees as e
join northwind.job_grades as jd
-- on e.salary > jd.lowest_sal and e.salary < jd.highest_sal;
on e.salary between jd.lowest_sal and jd.highest_sal;

-- 查询员工编号、员工名字、上司编号和名字
select e.employee_id, e.first_name, m.first_name as manager_name
from northwind.employees as e
left join northwind.employees as m
on e.manager_id = m.employee_id;

-- 查询 90 号部门员工的工种编号和位置编号
select job_id, location_id
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
where d.department_id = 90;

-- 查询有提成的员工，员工名字、部门名称、位置编号和城市
select e.first_name, d.department_name, l.location_id, l.city
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.locations as l
on d.location_id = l.location_id
where commission_pct is not null;

-- 查询在 toronto 市工作的员工，员工名字、工种编号、部门编号和部门名称
select e.first_name, e.job_id, d.department_id, d.department_name
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
where d.location_id = (
    select location_id from northwind.locations where city = 'toronto'
);

-- 查询每个部门的部门名称、工种名称、该工种的最低工资
select d.department_name, j.job_id, min(e.salary) as min_salary
from northwind.departments as d
join northwind.employees as e
on d.department_id = e.department_id
join northwind.jobs as j
on e.job_id = j.job_id
group by d.department_id, j.job_id;

-- 查询拥有部门数量大于 2 的国家，国家编号和部门数量
-- city and country are not same
select l.country_id, count(*) as num
from northwind.locations as l
join northwind.departments as d
on l.location_id = d.location_id
group by country_id
having num > 2;

select city, country_id
from northwind.locations;

-- 查询名为 Lisa 的员工，员工编号、其上司编号和名字
-- 查询没有部门的城市
-- 查询任职部门名为 sal 和 it 的员工信息
-- 查询名字中包含 e 的员工，其名字和工种名称
-- 查询拥有部门数量大于 3 的城市，城市名和部门数量
-- 查询员工人数大于 10 的部门，部门名称和员工人数，并按人数降序排序
-- 查询员工名字、部门名称、工种名称，并按部门名称降序排序
-- 查询员工的工资和工资级别
-- 查询工资级别和该级别的员工人数，不包括人数小于 20 的工资级别
-- 查询所有员工的名字和所属部门的名称
-- 查询所有部门的名称以及该部门的平均工资 average_salary （不要小数部分），并按平均工资降序排序

----------------------------------------------------------------------------------------------------

create table if not exists tb_test(
    id int primary key auto_increment,
    `name` varchar(50),
    book_id int,
    foreign key (id) references books (book_id),
    index idx_name using btree (`name`)
);

-- 创建数据库 cs，下面的操作都在这个数据库完成
show databases;
drop database if exists cs;
create database if not exists cs;
use cs;
-- 创建 employees 表，拥有 northwind.employees 表的所有数据
create table if not exists employees as
select * from northwind.employees;
select * from employees;
select database();

-- raise_salary 1-3 用 if 分支实现
-- 创建存储过程 raise_salary1，入口参数：员工编号。如果员工薪资低于 8000 元且工龄超过 5 年，涨薪 500 元
-- ，否则不变。
-- 确认该存储过程创建成功
-- 调用该存储过程并传入员工编号 104
-- 检查 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
desc employees;
drop procedure cs.raise_salary1;
delimiter $
create procedure cs.raise_salary1(in emp_id int)
begin
    declare s double(8, 2);
    declare y int;

    select salary, datediff(now(), hire_date) / 365 into s, y
    from cs.employees
    where employee_id = emp_id;

    if s < 8000 && y > 5 then
        update employees set salary = salary + 500 where employee_id = emp_id;
    end if;
end $
delimiter ;

select salary from cs.employees where employee_id = 104;
call cs.raise_salary1(104);

-- 创建存储过程 raise_salary2，入口参数：员工编号。如果员工薪资低于 9000 元且工龄超过 5 年，涨薪 500 元；
-- 否则涨薪 100 元。
-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 103 和 104
-- 检查 103 和 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
delimiter $
create procedure cs.raise_salary2(in emp_id int)
begin
    declare s double(8, 2);
    declare y int;

    select salary, datediff(now(), hire_date) / 365 into s, y
    from cs.employees
    where employee_id = emp_id;

    if s < 9000 && y > 5 then
        update employees set salary = salary + 500 where employee_id = emp_id;
    else
        update employees set salary = salary + 100 where employee_id = emp_id;
    end if;
end $
delimiter ;

select salary from cs.employees where employee_id = 103;
select salary from cs.employees where employee_id = 104;
call cs.raise_salary2(103);
call cs.raise_salary2(104);

-- 创建存储过程 raise_salary3，入口参数：员工编号。如果员工薪资低于 9000 元且工龄超过 5 年，
-- 则涨薪到 9000，薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。
-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 102、103 和 104
-- 检查 102、103 和 104 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
desc employees;
drop procedure raise_salary3;
delimiter $
create procedure cs.raise_salary3(in emp_id int)
begin
    declare s double(8, 2);
    declare y int;
    declare c_pct double(2, 2);

    select salary, datediff(now(), hire_date) / 365, commission_pct into s, y, c_pct
    from cs.employees
    where employee_id = emp_id;

    if s < 9000 && y > 5 then
        update employees set salary = 9000 where employee_id = emp_id;
    elseif s > 9000 && s < 10000 && c_pct = null then
        update employees set salary = salary + 500 where employee_id = emp_id;
    else
        update employees set salary = salary + 100 where employee_id = emp_id;
    end if;
end $
delimiter ;


-- raise_salary 4-5 用 case 分支实现
-- 创建存储过程 raise_salary4，入口参数：员工编号。如果员工薪资低于 9000 元，则涨薪到 9000，薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。
-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 101、104 和 105
-- 检查 101、104 和 105 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功


-- 创建存储过程 raise_salary5，入口参数：员工编号。
-- 如果员工工龄是 0 年，涨薪 50；
-- 如果工龄是 1 年，涨薪 100；
-- 如果工龄是 2 年，涨薪 200；
-- 如果工龄是 3 年，涨薪 300；
-- 如果工龄是 4 年，涨薪 400；
-- 其他的涨薪 500。
-- 确认该存储过程创建成功
-- 调用该存储过程并分别传入员工编号 101、104 和 105
-- 检查 101、104 和 105 编号的员工在调用存储过程前后工资的变化，确认存储过程执行是否成功
drop procedure cs.raise_salary5;
delimiter $
create procedure cs.raise_salary5(in emp_id int)
begin
    declare y int;

    select datediff(now(), hire_date) / 365 into y
    from cs.employees
    where employee_id = emp_id;

    case
        when y = 0 then
            update employees set salary = salary + 50 where employee_id = emp_id;
        when y = 1 then
            update employees set salary = salary + 100 where employee_id = emp_id;
        when y = 2 then
            update employees set salary = salary + 200 where employee_id = emp_id;
        when y = 3 then
            update employees set salary = salary + 300 where employee_id = emp_id;
        when y = 4 then
            update employees set salary = salary + 400 where employee_id = emp_id;
        else
            update employees set salary = salary + 500 where employee_id = emp_id;
    end case;
end $
delimiter ;

select salary, datediff(now(), hire_date) / 365 as years from employees where employee_id = 101;
call cs.raise_salary5(101);

update employees
set hire_date = makedate(year(now()) - 3, day(now()))
where employee_id = 104;
select salary, datediff(now(), hire_date) / 365 as years from employees where employee_id = 104;
call raise_salary5(104);
select salary, datediff(now(), hire_date) / 365 as years from employees where employee_id = 105;


-- 下面的功能分别用 loop、while 和 repeat 实现
-- 创建存储函数 factorial，计算 n!，入口参数 n，返回值 n! = 1 × 2 × ... × n
-- 确认该存储函数创建成功
-- 调用该存储函数，确认该存储函数执行是否成功

show variables like 'log_bin_trust_function_creators';
set global log_bin_trust_function_creators = on;

delimiter $
create function if not exists factorial(n int) returns int
begin
    declare res int default 1;
    while n > 1 do
        set res = res * n;
        set n = n - 1;
    end while;
    return (select res);
end $
delimiter ;

select database();
select factorial(5);    // OK

delimiter $
create function if not exists factorial2(n int) returns int
begin
    declare res int default 1;
    lp: loop
        set res = res * n;
        set n = n - 1;
        if n < 2 then
            leave lp;
        end if;
    end loop lp;
    return (select res);
end $
delimiter ;

select factorial2(5);


delimiter $
create function if not exists factorial3(n int) returns int
begin
    declare res int default 1;
    repeat
        set res = res * n;
        set n = n - 1;
        until n < 2
    end repeat;
    return (select res);
end $
delimiter ;

select factorial3(5);

-- 创建存储过程 pyramid，入口参数 n，输出 n 层法老的金字塔，当 n = 3 时，金字塔如下：
--   *
--  ***
-- *****
-- Copy
-- 确认该存储过程创建成功

-- 调用该存储过程，确认该存储过程执行是否成功

-- 创建存储过程 mult_talbe，输出九九乘法表
-- 确认该存储过程创建成功
-- 调用该存储过程，确认该存储过程执行是否成功


-- 声明存储过程 raise_salary6，给全体员工涨薪，每次涨幅为 10%，直到全公司的平均薪资达到 12000 为止，返回上涨次数。
-- 确认该存储过程创建成功
-- 调用该存储过程，确认该存储过程执行是否成功


-- 创建存储函数 get_count，计算薪资最高员工的工资之和达到 total_salary 的人数
-- 调用该存储函数，确认该存储函数执行是否成功