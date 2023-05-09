-- 如果没有特别说明，下面的查询都在 northwind 库的 employees 表中操作
-- 查询员工最高工资和最低工资的差距 diff
select
	max(salary) - min(salary) as diff
from employees;

-- 查询工种编号和该工种的员工人数 num
select job_id, count(*) as num
from employees
group by job_id;

-- 查询工种编号和该工种的平均工资 average_salary（去掉小数部分）
select job_id, truncate(avg(salary), 0) as average_salary
from employees
group by job_id;

-- 在 departments 表中，查询位置编号和该位置的部门个数 num
select location_id, count(*) as num
from departments
group by location_id;

-- 查询部门编号和该部分员工邮箱中包含 a 字符的最高工资
select department_id, max(salary)
from employees
where email like '%a%'
group by department_id;

-- 查询管理者编号，以及该领导手下有提成的员工的平均工资（去掉小数）average_salary
select manager_id, truncate(avg(salary), 0) as average_salary
from employees
where commission_pct is not null
group by manager_id;

-- 查询部门编号和该部门的员工人数 num，只要 num>5 的数据
select department_id, count(*) as num
from employees
group by department_id
having num > 5;

-- 查询工种编号和该工种有提成的员工的平均工资 average_salary，只要 average_salary>12000 的数据
select job_id, avg(salary) as average_salary
from employees
where commission_pct is not null
group by job_id
having average_salary > 12000;

-- 查询管理者编号和该领导手下员工的最低工资 min_salary，只要 min_salary>5000 的数据
select manager_id, min(salary) as min_salary
from employees
group by manager_id
having min_salary > 5000;


-- 查询管理者编号和该领导手下员工的最低工资 min_salary，只要 min_salary >= 6000 的数据，没有管理者的员工不计算在内
select manager_id, min(salary) as min_salary
from employees
where manager_id is not null
group by manager_id
having min_salary >= 6000;

-- 查询工种编号，以及该工种下员工工资的最大值，最小值，平均值，总和，并按工种编号降序排序
select job_id, max(salary), min(salary), avg(salary), sum(salary)
from employees
group by job_id
order by job_id desc;

-- 查询工种编号和该工种有提成的员工的最高工资 max_salary，只要 max_salary>6000 的数据，对结果按 max_salary 升序排序
select job_id, max(salary) as max_salary
from employees
where commission_pct is not null
group by job_id
having max_salary > 6000
order by max_salary asc;

-- 查询部门编号、该部门员工人数 num 和该部门工资平均值 average_salary，并按平均工资降序排序
select department_id, count(*) as num, avg(salary) as average_salary
from employees
group by department_id
order by average_salary desc;

-- 查询部门编号、工种编号和该部门和工种的员工的最低工资 min_salary，并按最低工资降序排序
select department_id, job_id, min(salary) as min_salary
from employees
group by department_id, job_id
order by min_salary desc;

-- 将上面的 SQL 代码放到 02-sql 目录下的 06-group.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库