-- stored procedure and stored function

create database pf;

-- 1. 创建存储过程
-- 创建存储过程 all_data，查看 employees 表的所有数据

delimiter $
create procedure pf.all_data()
begin
  select * from northwind.employees;
end $
delimiter ;

-- 2. 调用存储过程
call pf.all_data();

-- 创建存储过程 avg_salary，查看 employees 表所有员工的平均工资F
delimiter $
create procedure pf.avg_salary()
begin
  select avg(salary) as avg_salary from northwind.employees;
end $
delimiter ;

call pf.avg_salary();

-- 创建存储过程 max_salary，查看 employees 表的最高工资

delimiter $
create procedure pf.max_salary()
begin
  select max(salary) as max_salary
  from northwind.employees;
end $
delimiter ;

call pf.max_salary();

-- 创建存储过程 min_salary，查看 employees 表的最低工资
-- 并将最低工资通过参数 minSalary 输出

show columns from northwind.employees where Field = 'salary';

delimiter $
create procedure pf.min_salary(out minSalary double)
begin
  select min(salary) into minSalary
  from northwind.employees;
end $
delimiter ;

call pf.min_salary(@minSalary);
select @minSalary;

-- 创建存储过程 get_salary_by_id，查看 employees 表某员工编号员工的工资，
-- 并用 emp_id 输入员工编号

desc northwind.employees;

delimiter $
create procedure pf.get_salary_by_id(in emp_id int)
begin
  select salary from northwind.employees
  where employee_id = emp_id;
end $
delimiter ;

select * from northwind.employees;

call pf.get_salary_by_id(103);
-- or
set @emp_id := 103;
call pf.get_salary_by_id(@emp_id);

-- 创建存储过程 get_salary_by_name，查看 employees 表的某员工的工资
-- 入口参数 emp_name 员工名字，出口参数 salary 该员工的工资

show columns from northwind.employees where Field = 'first_name' or Field = 'salary';

delimiter $
create procedure pf.get_salary_by_name(in name varchar(20), out s double(8,2))
begin
  select salary into s
  from northwind.employees
  where first_name = name;
end $
delimiter ;

select * from northwind.employees;

set @emp_name = 'Lex';
call pf.get_salary_by_name(@emp_name, @salary);
select @salary;

-- 创建存储过程 get_mgr_name，查询 employees 表中某员工名字的领导的名字
-- 参数 name 同时作为输入的员工名字和输出的领导名字

show columns from northwind.employees where Field = 'first_name';

delimiter $
create procedure pf.get_mgr_name(inout name varchar(20))
begin
  select first_name into name
  from northwind.employees
  where employee_id = (
    select manager_id
    from northwind.employees
    where first_name = name
  );
end $
delimiter ;

select * from northwind.employees;

set @name := 'Lex';
call pf.get_mgr_name(@name);
select @name;


-- 3. 创建存储函数
-- 创建存储函数 avg_salary，返回 employees 表所有员工的平均工资

show columns from northwind.employees where Field = 'salary';

delimiter $
create function pf.avg_salary()
returns double(8, 2)
deterministic
contains sql
reads sql data
begin
  return (select avg(salary) from northwind.employees);
end $
delimiter ;

select pf.avg_salary();

select *
from northwind.employees
where salary > pf.avg_salary();

-- 创建存储函数 get_mgr_name，查询 employees 表中某员工名字的领导的名字

set global log_bin_trust_function_creators = 1;
delimiter $
create function pf.get_mgr_name(name varchar(20))
returns varchar(20)
begin
  return(
    select first_name
    from northwind.employees
    where employee_id = (
      select manager_id
      from northwind.employees
      where first_name = name
    )
  );
end $
delimiter ;

select * from northwind.employees;

select pf.get_mgr_name('Lex');

-- 创建存储函数 get_count_by_dept_id，查询 employees 表某部门编号的部门员工人数

delimiter $
create function pf.get_count_by_dept_id(dept_id int)
returns int
begin
  return (select count(*) from northwind.employees where department_id = dept_id);
end $
delimiter ;

set @dept_id := 50;
select pf.get_count_by_dept_id(@dept_id);

-- 4. 查看存储过程和存储函数

-- 查看存储过程和存储函数存储的代码

show create procedure pf.all_data;

show create function pf.get_count_by_dept_id;

-- 查看存储过程和存储函数的状态

show procedure status where db = 'pf';
show procedure status where name = 'all_data';
show function status where db = 'pf';
show function status where name = 'avg_salary';

-- 查看存储过程和存储函数对象信息

select * from information_schema.routines
where routine_schema = 'pf';

select * from information_schema.routines
where routine_name = 'avg_salary';

select * from information_schema.routines
where routine_name = 'avg_salary' and routine_type = 'procedure';

-- 5. 修改存储过程和存储函数

show procedure status where Name = 'avg_salary';

alter procedure pf.avg_salary
sql security invoker
comment '查询平均工资';

-- 6. 删除存储过程和存储函数

drop function if exists pf.avg_salary;
drop procedure if exists pf.get_mgr_name;

select * from information_schema.routines
where routine_schema = 'pf';
