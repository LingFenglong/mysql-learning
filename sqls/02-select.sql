-- select select_list
-- from table_name
-- where conditions;

-- 如果没有特别说明，下面的查询都在 northwind 库的 employees 表中操作
-- 查询工资大于 12000 的员工信息
select *
from employees
where salary > 12000;

-- 查询部门编号不等于 90 的员工 last_name 和部门编号
select last_name,deparment_id
from employees
where department_id != 90;

-- 查询工资在 10000 到 20000 之间的员工 last_name、工资以及提成
select last_name,salary,commission_pct
from employees
where salary between 10000 and 20000;

-- 查询部门编号不是在 90 到 110 之间，或者工资高于 15000 的员工信息
select *
from employees
where department_id not between 90 and 110 or salary > 15000;

-- 查询员工 lastname 中包含字符 a 的员工信息
select *
from employees
where last_name like '%a%';
-- a的位置
-- xxxxa	'%a'
-- axxxx	'a%'
-- xxxax	'%a%'

-- 查询员工 lastname 中第三个字符为 n，第五个字符为 l 的员工 last_name 和工资
select last_name,salary
from employees
where last_name like '__n_l%';

-- 查询员工 job_id 中第三个字符为'_'的员工 last_name 和 job_id
select last_name,job_id,salary
from employees
where job_id like '__\_%';

-- 查询员工编号在 100 到 120 之间的员工信息
select *
from employees
where employee_id between 100 and 120;

-- 查询工种编号在 it_prog、ad_vp、ad_pres 中的员工 last_name 和工种编号
select employee_id,last_name,job_id
from employees
where job_id in ('it_prog','ad_vp','ad_pres');

-- 查询没有提成的员工 last_name 和提成
select last_name,commission_pct
from employees
where commission_pct is null;

-- 查询工资为 12000 的员工 lastname 和工资
select last_name,salary
from employees
where salary = 12000;

-- 将上面的 SQL 代码放到 02-sql 目录下的 02-select.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库