-- 在 dbms-demo 目录下，创建 02-sql 文件夹
-- 在 MySQL Shell（或 MySQL Workbench）中完成下面的查询操作
-- 下面的所有查询都在上面导入的 northwind 示例数据库上完成
-- 查询常量值 hello world
select 'hello world';

-- 在 employees 表中，查询 first_name 字段
select first_name
from employees;

-- 在 employees 表中，查询 first_name，last_name 和 salary 字段
select first_name, last_name, salary
from employees;

-- 在 employees 表中，查询所有字段
select *
from employees;

-- 查询表达式，计算半径为 4 的圆的面积
select 3.14 * 4 * 4;

-- 查询函数，获得当前 MySQL 服务器的版本
select version();

-- 浏览 MySQL 手册，浏览 MySQL 内置函数的分类，找到获取 MySQL 版本函数的分类
-- 查询函数，获得当前时间
select now();

-- 查询函数，获得当前登录的用户
select user();

-- 查询表达式，使用幂函数，计算半径为 4 的圆的面积，
select 3.14 * pow(4, 2);

-- 使用别名修改前面的查询，提高查询结果的可读性
select concat(first_name, ' ', last_name) as fullname
from employees;

-- 在 employees 表中，查询 employee_id, last_name 和 annual_salary 字段
select employee_id, last_name, 12 * salary as annual_salary
from employees;

-- 在 employees 表中，查询 fullname 字段，fullname = firstname + ' ' + lastname
select concat(first_name, ' ', last_name) as fullname
from employees;

-- 类似上一条查询，要求查询结果显示的字段为：employee fullname
select concat(first_name, ' ', last_name) as 'employee fullname'
from employees;

-- 在 employees 表中，查询 first_name, last_name, job_id 和 commission_pct 列，各个列之间用逗号连接，字段显示为 output
select concat(first_name, ',', last_name, ',', job_id, ',', commission_pct) as output
from employees;

-- 查询 departments 表的结构
desc departments;

-- 在 departments 表中，查询所有字段
select *
from departments;

-- 在 employees 表中，查询所有不同的部门编号
select distinct department_id
from employees;

-- 在 employees 表中，查询所有不同的工作编号
select distinct employee_id
from employees;

-- 将上面的 SQL 代码放到 02-sql 目录下的 01-project.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库