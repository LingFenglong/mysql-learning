-- 使用默认字符集创建 library 数据库
create database library;

-- 查看 DBMS 上的所有数据库，确认 library 是否创建成功
show databases;

-- 查看 library 数据库创建使用的字符集
show create database library;

-- 查看 DBMS 默认的字符集设置
show variables like '%character%';

-- 创建 library2 数据库，使用 utf8mb4 字符集
create database library2 character set 'utf8mb4';

-- 查看 DBMS 上的所有数据库，确认 library2 是否创建成功
show databases;

-- 查看 library2 数据库创建使用的字符集
show create database library2;

-- 切换到 northwind 数据库
use northwind;
\u northwind;

-- 查看 northwind 数据库，有哪些表
show tables;

-- 查看当前使用的数据库
select database();

-- 查看 mysql 数据库有哪些表（不要切换到 mysql 数据库）
show tables from mysql;

-- 修改 library 数据库，使用 utf8mb4 字符集
alter database library character set 'utf8mb4';

-- 删除 library2 数据库
drop database library2;

-- 在 library 数据库中创建 books 表，字段和数据类型如下：
	-- id int
	-- name varchar(20)
	-- price double,
	-- author_id int,
	-- publish_date date
create table books(
	id int auto_increment,
	name varchar(20),
	price double,
	author_id int,
	publish_date date,
	primary key (id)
);

-- 查看 books 表的字段和数据类型
desc books;

-- 查看 books 表使用的字符集和存储引擎
show create table books;

-- 在 library 数据库中创建 emp2 表，该表拥有 northwind.employees 表的
--  employee_id, first_name 和 salary 三个字段，以及相应的数据
create table emp2
as
select employee_id, first_name, salary
from northwind.employees;

-- 在 library 数据库中创建 emp3 表，该表拥有 northwind.employees 
-- 表相同结构，但没有数据
create table emp3
as
select *
from northwind.employees
where false;

-- 查看 emp2 表的字段和数据类型
desc emp2;

-- 查看 emp2 表的字符集和存储引擎
show create table emp2;

-- 查看 emp2 表中的数据
select *
from emp2;

-- 对 emp3 做类似的三项检查
desc emp3;
show create table emp3;
select *
from emp3;

-- 在 emp2 表中增加一个新字段 hire_date 类型为 date，
-- 新字段为最后一个字段，验证操作是否正确，下面操作类似
alter table emp2
add column hire_date date;

-- 在 emp2 表中增加一个新字段 phone 类型为 varchar(20)，
-- 新字段为第一个字段
alter table emp2
add	column phone varchar(20) first;

-- 在 emp2 表中增加一个新字段 email 类型为 varchar(20)，
-- 新字段的前一个字段为 salary
alter table emp2
add column email varchar(20) after salary;

-- 修改 emp2 表的 employee_id 字段为 id，验证修改是否正确，
-- 下面操作类似
alter table emp2
change column employee_id id int;

-- 修改 emp2 表的 email 字段为 mail，并且数据类型改为 varchar(30)
alter table emp2
change column email mail varchar(30);

-- 修改 emp2 表的 first_name 字段为 varchar(25)
alter table emp2
modify column first_name varchar(25);

alter table emp2
change column first_name first_name varchar(25);

-- 修改 emp2 表的 first_name 字段为 varchar(35)，默认值为 abc
alter table emp2
modify column first_name varchar(35) default 'abc';

-- 删除 emp2 表的 mail 字段
alter table emp2
drop column mail;

-- 修改 emp2 表的名称为 emp，验证修改是否成功
rename table emp2 to emp;
show tables;
desc emp;

-- 用另一种方式将 emp 表名改为 emp2，验证修改是否成功
alter table emp
rename to emp2;
show tables;
desc emp2;

-- 删除 emp3 表
drop table if exists emp3;

-- 用 delete 方法删除 emp2 表中的所有数据，
-- 并验证 delete 是否支持回滚操作
select *
from emp2;

delete from emp2 where true;

-- 用 truncate 方法删除 emp2 表中的所有数据，并验证 truncate 是否支持回滚操作
truncate table emp2;

-- 将上面的 SQL 代码放到 02-sql 目录下的 09-ddl.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库

create table tb_name

alter database db_name
	character set 'CharSetName'
	-- UTF-8

alter table tb_name {
	add column col_name TYPE POSITION;
	change column col_name new_col_name TYPE;
	modify column col_name TYPE;
	drop column col_name;
	rename to new_tb_name; (or rename tb_name to new_tb_name)
}

delete from tb_name
where conditions

drop table if exists tb_name

truncate table tb_name