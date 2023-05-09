-- 8. 视图 view vw --> vm
show databases;

select user();

drop database if exists vm;

-- 创建数据库 vw，下面操作都在这个数据库中完成
create database if not exists vm;

-- 创建 emps 表，拥有 northwind.employees 表的所有数据
create table vm.emps as
select *
from northwind.employees;

-- 创建 depts 表，拥有 northwind.departments 表的所有数据
create table vm.depts as
select *
from northwind.departments;

-- 检查两个表中的数据，确保与源表的数据相同
select *
from vm.emps;

select *
from vm.depts;

-- 检查 emps 与 northwind.employees 表结构，比较两者的差异
desc vm.emps;

desc northwind.employees;

-- 创建 v_emp1 视图，包含 emps 表中的员工编号、名字和薪水三个字段
create view vm.v_emp1 as
select employee_id,
    first_name,
    salary
from vm.emps;

-- 检查 v_emp1 视图的所有数据，确保跟 emps 表中的记录数相同
select *
from vm.v_emp1;

-- 创建 v_emp2 视图，包含 emps 表中月薪大于 8000 的员工，其编号(emp_id)，名字(name)和薪水
create view vm.v_emp2 as
select employee_id,
    first_name,
    salary
from vm.emps
where salary > 8000;

-- 检查 v_emp2 视图中的所有数据
select *
from vm.v_emp2;

-- 创建 v_emp_sal 视图，包含 emps 表中的部门编号和该部门的平均工资(avg_sal)，
-- 不包含部门编号为 null 的数据
drop view vm.v_emp_sal;

create view vm.v_emp_sal as
select vm.emps.department_id,
    avg(vm.emps.salary) as avg_salary
from vm.emps
group by vm.emps.department_id;

-- 检查 v_emp_sal 视图的所有数据
select *
from vm.v_emp_sal;

-- 创建 v_emp_dept 视图，包含 emps 表中的员工编号和部门编号以及 depts 表中的部门名称
drop view vm.v_emp_dep;

create view vm.v_emp_dep as
select emps.employee_id,
    emps.department_id,
    depts.department_name
from vm.emps
    join vm.depts on emps.department_id = depts.department_id;

-- 检查 v_emp_dept 视图的所有数据
select *
from vm.v_emp_dep;

-- 创建 v_emp4 视图，包含 v_emp1 视图中的员工编号和员工名字两个字段
drop view vm.v_emp4;

create view vm.v_emp4 as
select employee_id,
    first_name
from vm.v_emp1;

-- 检查 v_emp4 视图的所有数据
select *
from vm.v_emp4;

-- 查看 vw_test 数据库中的表对象和视图对象
show tables
from vm;

-- 查看 v_emp1 视图的结构
desc vm.v_emp1;

-- 查看 v_emp1 视图的状态信息
show table status
from vm like 'v_emp1';

-- 查看 v_emp1 视图的详细定义信息
show create view vm.v_emp1;

-- 修改 v_emp1 视图的数据，将编号为 101 的员工，月薪改为 20000
update vm.v_emp1
set salary = 20000
where employee_id = 101;

-- 检查 v_emp1 视图的数据，确保修改成功
select *
from vm.v_emp1
where employee_id = 101;

-- 检查 emps 表，查看 101 编号的员工薪水
select salary
from vm.emps
where employee_id = 101;

-- 修改 emps 表中的数据，将编号为 101 的员工，月薪改为 10000
update vm.emps
set salary = 1000
where department_id = 10000;

-- 检查 emps 表的数据，确保修改成功
select salary
from vm.emps
where employee_id = 101;

-- 检查 v_emp1 表，查看 101 编号的员工薪水
select salary
from vm.v_emp1
where employee_id = 101;

-- 删除 v_emp1 视图中的数据，将编号为 101 的员工信息删除
delete from vm.v_emp1
where employee_id = 101;

-- 检查 v_emp1 视图的数据，确保修改成功
select *
from vm.v_emp1
where employee_id = 101;

-- 检查 emps 表，查看 101 编号的员工信息
select *
from vm.emps
where employee_id = 101;

-- 在 v_emp_sal 视图中，将编号为 30 的部门，平均工资改为 5000，修改是否成功，为什么
desc vm.v_emp_sal;

update vm.v_emp_sal
set avg_salary = 5000
where department_id = 30;

-- 在 v_emp_sal 视图中，删除编号为 30 的部门信息，修改是否成功，为什么
delete from vm.v_emp_sal
where department_id = 30;

-- 修改 v_emp1 视图，包含工资大于 7000 的员工编号，名字，工资和 email 字段
drop view vm.v_emp1;

create view vm.v_emp1 as
select employee_id,
    first_name,
    salary,
    email
from vm.emps
where salary > 7000;

select *
from vm.v_emp1
order by salary asc;

-- 删除 v_emp4 视图，删除前后分别查看 vw_test 库中的所有表和视图，确认删除成功
drop view vm.v_emp4;
show tables from vm;

-- 将上面的 SQL 代码放到 02-sql 目录下的 13-view.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库