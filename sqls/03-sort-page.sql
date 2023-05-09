-- select select_list
-- from table_name
-- where conditions
-- order by at_x
-- limit offset, size;

-- sort | pagination
-- direction -> asc(end), desc(end)

-- 如果没有特别说明，下面的查询都在 northwind 库的 employees 表中操作
-- 查询所有信息，按工资降序排序
select *
from employees
order by salary desc;

-- 查询部门编号大于等于 90 的员工信息，并按员工编号降序排序
select *
from employees
where department_id >= 90
order by employee_id desc;

-- 查询所有员工信息，按年薪降序排序
select *,salary * 12 as annual_salary
from employees
order by annual_salary desc;

-- 查询所有员工信息，按年薪升序排序
select *,salary * 12 as annual_salary
from employees
order by annual_salary asc;

-- 查询员工名字 first_name 和名字长度，并且按名字的长度降序排序
select *,length(first_name) as first_name_length
from employees
order by first_name_length desc;

-- 查询所有员工信息，先按工资降序，再按 employee_id 升序排序
select *
from employees
order by salary desc, employee_id asc;

-- 查询员工名字，部门编号和年薪，按年薪降序并按姓名升序排序
select first_name,last_name,department_id,salary * 12 as annual_salary
from employees
order by annual_salary desc, first_name asc; 

-- 查询工资不在 8000 到 17000 的员工的名字和工资，按工资降序排序
select first_name,last_name,salary
from employees
where salary not between 8000 and 17000
order by salary desc;

-- 查询邮箱中包含 e 的员工信息，并先按邮箱的长度降序，再按部门号升序排序
select *
from employees
where email like '%e%'
order by length(email) desc, department_id asc;

-- 查询前五条员工信息
select *
from employees
limit 5;

-- 查询第 11 条 ~ 第 25 条
select *
from employees
limit 10, 15;

-- 查询有提成，且工资最高的前 10 位员工信息
select *
from employees
where commission_pct is not null
order by salary desc
limit 10;

-- 将上面的 SQL 代码放到 02-sql 目录下的 03-sort-page.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库