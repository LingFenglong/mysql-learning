-- 如果没有特别说明，下面的查询都在 northwind 库的 employees 表中操作
-- 查询员工编号、名字、工资、以及工资提高百分之 20% 后的结果 new_salary
select employee_id, first_name, last_name, salary, salary * 1.2 as new_salary
from employees;

-- 将员工的姓氏按首字母升序排序，并查询姓氏和姓氏的长度 length
select last_name, length(last_name) as last_name_length
from employees
order by last_name asc;

-- 查询员工编号、名字，薪水，作为一个列输出（逗号分割），别名为 output
select concat(employee_id, ',', first_name, ' ', last_name, ',', salary) as output
from employees;

-- 查询员工编号、工作的年数 work_years（保留小数点后 1 位）、工作的天数 work_days，并按工作年数的降序排序
select employee_id, first_name, last_name, hire_date, truncate(datediff(now(), hire_date) / 365, 1) as work_years, datediff(now(), hire_date) as work_days
from employees
order by work_years desc;

-- 查询员工名字、入职时间（格式：MM-DD/YYYY）、部门编号、提成，并同时满足以下条件：
-- 入职时间在 1997 年之后
-- 部门编号是 80 或 90 或 110
-- 提成不为空
select
	first_name, last_name, date_format(hire_date, '%m-%d/%Y') as hire_date, department_id, commission_pct
from employees
where hire_date > '1997-1-1'
	and department_id in (80, 90, 110)
	and commission_pct is not null;

select employee_id, first_name, last_name, commission_pct
from employees
where department_id in (90, 110);

-- 查询入职超过 10000 天的员工名字和入职时间
select first_name, last_name, hire_date, datediff(now(), hire_date) as work_days
from employees
where datediff(now(), hire_date) > 10000;

select subdate(now(), interval 10000 day);

-- 查询 dream，dream = <first_name> earns <salary> monthly but wants <salary>*3，salary 不要小数部分
select concat(first_name, ' earns ', format(salary, 0), ' monthly but wants ' , format(salary * 3, 0),salary) as dream
from employees;


-- 查询员工名字、工种以及工种的等级，其中工种的等级如下：
-- 如果 job_id 为 AD_PRES，grade 为 A 级
-- 如果 job_id 为 ST_MAN，grade 为 B 级
-- 如果 job_id 为 IT_PROG，grade 为 C 级
-- 如果 job_id 为 SA_REP，grade 为 D 级
-- 如果 job_id 为 ST_CLERK，grade 为 E 级
select first_name, last_name,
case job_id
	when 'AD_PRES' then 'A'
	when 'ST_MAN' then 'B'
	when 'IT_PROG' then 'C'
	when 'SA_REP' then 'D'
	when 'ST_CLERK' then 'E'
	else null
end as grade
from employees;

-- 查询员工的名字、工资以及工资级别 grade，grade 计算如下：
-- 如果工资大于 20000，grade 为 A 级
-- 如果工资大于 15000，grade 为 B 级
-- 如果工资大于 10000，grade 为 C 级
-- 否则，grade 为 D 级
select first_name, last_name, salary,
case
	when salary > 20000 then 'A'
	when salary > 15000 then 'B'
	when salary > 10000 then 'C'
	else 'D'
end as grade
from employees;

-- 查询员工工资的最大值、最小值、平均值、总和和数量
select max(salary), min(salary), avg(salary), sum(salary), count(salary)
from employees;

-- 查询最早入职时间、最近入职时间以及两者相差的天数 diff
select
	min(hire_date) as far,
	max(hire_date) as near,
	datediff(max(hire_date), min(hire_date))
from employees;

-- 查询部门编号为 90 的员工人数
select count(*)
from employees
where department_id = 90;

select first_name
from employees
where department_id = 90;

-- 将上面的 SQL 代码放到 02-sql 目录下的 04-buildin-functions.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库