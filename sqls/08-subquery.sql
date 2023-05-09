-- 查询工资比名为 Ellen 高的员工的名字和工资
select first_name, salary
from employees
where salary > (
	select salary
	from employees
	where first_name = 'Ellen'
);

-- 自连接
select e2.first_name, e2.salary
from employees as e1
join employees as e2
on e1.first_name = 'Ellen'
where e2.salary > e1.salary

select e1.first_name, e1.salary, e2.first_name, e2.salary
from employees as e1
join employees as e2
on e1.first_name = 'Ellen'
where e2.salary > e1.salary;

-- 查询与编号为 141 的员工工种相同，比编号为 143 的员工月薪高的员工名字、工种编号和月薪
select first_name, employee_id, salary
from employees
where job_id = (
	select job_id
	from employees
	where employee_id = 141
) and salary > (
	select salary
	from employees
	where employee_id = 143
);

-- 查询工资最少的员工的名字、工种和月薪
select first_name, job_id, salary
from employees
where salary = (
	select min(salary)
	from employees
);

-- 查询部门编号和该部门的最低月薪 min_salary，要求部门最低月薪大于 100 号部门的最低月薪
select department_id, min(salary) as min_salary
from employees
group by department_id
having min_salary > (
	select min(salary)
	from employees
	where department_id = 100
);

-- 返回位置编号是 1400 和 1500 两个部门中的所有员工名字
select first_name
from employees
where (
	select location_id
	from departments
	where employees.department_id = departments.department_id
) in (1400, 1500);

select first_name
from employees
where department_id in (
	select department_id
	from departments
	where location_id in (1400, 1500)
);

-- 查询其它工种中比 it_prog 工种中任一工资低的员工的员工编号、名字、工种和月薪
-- 查询其它工种中比 it_prog 工种所有工资都低的员工的员工编号、名字、工种和月薪
select employee_id, first_name, job_id, salary
from employees
where salary < (
	select min(salary)
	from employees
	where job_id = 'it_prog'
);


-- 查询员工编号最小并且工资最高的员工信息
select employee_id, first_name, salary
from employees
where employee_id = (
	select min(employee_id)
	from employees
) and salary = (
	select max(salary)
	from employees
);

select employee_id, first_name, salary
from employees
where (employee_id, salary) in (
	select min(employee_id), max(salary)
	from employees
);

-- 查询 employees 的部门编号和管理者编号在 departments 表中的员工名字，部门编号和管理者编号
select first_name, department_id, manager_id
from employees
where (department_id, manager_id) in (
	select department_id, manager_id
	from departments
);

-- 查询每个部门信息和该部门员工个数
-- 连接
-- 错误写法
-- select d.*, count(*) as num
-- from employees as e
-- right join departments as d
-- on d.department_id = e.department_id
-- group by d.department_id;

select d.*, count(employee_id) as num
from employees as e
right join departments as d
on d.department_id = e.department_id
group by d.department_id;

-- 子查询
select *, (
	select count(*)
	from employees
	where employees.department_id = departments.department_id) as num
from departments;

select d.*, (
  select count(*)
  from northwind.employees e
  where e.department_id = d.department_id
) as num
from northwind.departments as d;

-- 查询部门编号、该部门的平均工资 average_salary 和工资等级，平均工资去掉小数部分
select department_id, avg(salary) as average_salary, grade_level
from employees as e
join job_grades as g
on avg(salary) between lowest_sal and highest_sal;
group by department_id;

select s.*, g.grade_level
from (
  select department_id, truncate(avg(salary), 0) as average_salary
  from northwind.employees
  group by department_id
) as s
join northwind.job_grades as g
on s.average_salary between lowest_sal and highest_sal;

-- 查询有员工的部门名称
-- 查询和 Eleni 相同部门的员工名字和工资
select first_name, salary
from employees
where department_id = (
	select department_id
	from employees
	where first_name = 'Eleni'
);

-- 查询比公司平均工资高的员工的员工编号、名字和工资，并按工资升序排序
select employee_id, first_name, salary
from employees
where salary > (select avg(salary) from employees)
order by salary desc;

-- 查询各部门中工资比本部门平均工资高的员工的员工编号、名字和工资

-- 查询和名字中包含字母 u 的员工在相同部门的员工的员工编号和名字
-- 查询在部门 location_id 为 1700 的部门工作的员工的员工编号
-- 查询员工名字和工资，这些员工的上司的名字是 Steven
-- 查询工资最高的员工的姓名 name，name = first_name, last_name
-- 查询工资最低的员工的名字和工资
-- 查询平均工资最低的部门信息
-- 查询平均工资最低的部门信息和该部门的平均工资
-- 查询平均工资最高的 job 信息
select avg(salary)
group by job_id

-- 查询平均工资高于公司平均工资的部门有哪些
-- 查询所有管理者的详细信息
-- 查询各个部门中最高工资中最低的那个部门的最低工资是多少
-- 查询平均月薪最高的部门的管理者的名字、部门编号、邮箱和月薪
-- 将上面的 SQL 代码放到 02-sql 目录下的 08-subquery.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库