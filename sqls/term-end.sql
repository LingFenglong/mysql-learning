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
-- 创建 emps 表，拥有 northwind.employees 表的所有数据
-- 创建 depts 表，拥有 northwind.departments 表的所有数据
-- 检查两个表中的数据，确保与源表的数据相同
-- 检查 emps 与 northwind.employees 表结构，比较两者的差异
-- 创建 v_emp1 视图，包含 emps 表中的员工编号、名字和薪水三个字段
-- 检查 v_emp1 视图的所有数据，确保跟 emps 表中的记录数相同
-- 创建 v_emp2 视图，包含 emps 表中月薪大于 8000 的员工，其编号(emp_id)，名字(name)和薪水
-- 检查 v_emp2 视图中的所有数据
-- 创建 v_emp_sal 视图，包含 emps 表中的部门编号和该部门的平均工资(avg_sal)，不包含部门编号为 null 的数据
-- 检查 v_emp_sal 视图的所有数据
-- 创建 v_emp_dept 视图，包含 emps 表中的员工编号和部门编号以及 depts 表中的部门名称
-- 检查 v_emp_dept 视图的所有数据
-- 创建 v_emp4 视图，包含 v_emp1 视图中的员工编号和员工名字两个字段
-- 检查 v_emp4 视图的所有数据
-- 查看 vw_test 数据库中的表对象和视图对象
-- 查看 v_emp1 视图的结构
-- 查看 v_emp1 视图的状态信息
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
-- 创建表 tb_tg，包括两个字段：id 字段（int、主键、自增）和 note 字段（varchar(20)）
-- 创建表 tb_tg_log，包括两个字段：id 字段（int、主键、自增）和 log 字段（varchar(40)）
-- 创建表 employees，包括四个字段：employee_id, first_name, salary 和 manager_id，数据来自 northwind.employees
-- 检查三个表的结构
-- 检查 employees 表的数据，确认有 northwind.employees 表对应的 107 条记录
-- 创建名为 after_insert 的触发器，在 tb_tg 表插入数据后，向 tb_tg_log 表中插入日志信息
-- 日志信息的格式是：[datetime insert]: note，datetime 代表 insert 发生的当前日期和时间，下同
-- 查看该触发器，确认创建成功
-- 在 tb_tg 表添加一条日志，内容随意
-- 查看 td_tg 和 td_tg_log 表的数据，确认触发器正常工作
-- .
-- 创建名为 after_delete 的触发器，在 tb_tg 表删除数据后，向 tb_tg_log 表中插入日志信息
-- 日志信息的格式是：[datetime delete]: note
-- 查看该触发器，确认创建成功
-- 在 tb_tg 表删除一条日志
-- 查看 td_tg 和 td_tg_log 表的数据，确认触发器正常工作
-- .
-- 定义触发器 salary_check，在员工表添加新员工前检查其薪资是否大于他领导的薪资
-- 如果员工薪资大于其领导薪资，则报 sqlstate 为 45000 的错误
-- 查看该触发器，确认创建成功
-- 在员工表表添加一条记录，做通过性测试，检查员工表的数据
-- 在员工表表添加一条记录，做失效性测试，检查员工表的数据
-- 确认这个触发器能正常工作
-- .
-- 分别用三种方式查看上面创建的某个触发器
-- 删除上面创建的三个触发器

----------------------------------------------------------------------------------------------------------

-- 存储过程、存储函数（结合复合语句分支、循环）
-- 创建数据库 pf，下面的操作都在这个数据库完成
-- 创建存储过程 all_data，查询 employees 表的所有数据，调用该存储过程，验证其功能是否正确
-- 下面创建的存储过程或存储函数都需要调用和验证，不再赘述
-- 创建存储过程 avg_salary，查询 employees 表所有员工的平均工资
-- 创建存储过程 max_salary，查询 employees 表的最高工资
-- 创建存储过程 min_salary，查询 employees 表的最低工资，并将最低工资通过参数 minSalary 输出
-- 创建存储过程 get_salary_by_id，查询 employees 表某员工的工资，入口参数是 emp_id 员工编号
-- 创建存储过程 get_salary_by_name，查询 employees 表某员工的工资，入口参数是 emp_name 员工名字，出口参数是 salary 该员工的工资
-- 创建存储过程 get_mgr_name，查询 employees 表中某员工领导的名字，参数 name 同时作为输入的员工名字和输出的领导名字
-- 创建存储函数 avg_salary，返回 employees 表所有员工的平均工资
-- 创建存储函数 get_mgr_name，返回 employees 表中某员工名字的领导的名字
-- 创建存储函数 get_count_by_dept_id，返回 employees 表某部门编号的部门员工人数
-- 查看存储过程 all_data 的代码
-- 查看存储函数 get_count_by_dept_id 的代码
-- 查看存储过程 all_data 的状态
-- 查看存储函数 avg_salary 的状态
-- 查看存储过程 avg_salary 的对象信息
-- 查看存储函数 avg_salary 的对象信息
-- 修改存储过程 avg_salary，添加注释，修改 sql security 为 invoker
-- 删除存储过程 get_mgr_name，验证该对象确实删除
-- 删除存储函数 avg_salary，验证该对象确实删除

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