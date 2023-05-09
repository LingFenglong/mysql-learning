-- 查询员工名字和所在部门的名称
select first_name, department_name
from employees as e
left join departments as d
on e.department_id = d.department_id;

-- 查询员工名字、工种编号和工种名称
select first_name, e.job_id, job_title
from employees as e
join jobs as j
on e.job_id = j.job_id;

-- 查询有提成员工的员工名字、部门名称和提成
select first_name, department_name, commission_pct
from employees as e
join departments as d
on e.department_id = d.department_id
where commission_pct is not null;

-- 查询所在城市名中第二个字符为 o 的部门名称和城市名
select department_name, city
from locations as l
join departments as d
on l.location_id = d.location_id
where department_name like '_o%';

-- 查询城市名称和该城市拥有的部门数量，过滤没有部门的城市
select city, count(department_id) as num
from locations as l
join departments as d
on l.location_id = d.location_id
group by city
having num > 0;

-- 查询有提成的部门，部门名称、部门的领导编号和部门的最低工资 min_salary
select department_name, d.manager_id, min(salary) as min_salary
from departments as d
join employees as e
on d.department_id = e.department_id
where commission_pct is not null
group by department_name, d.manager_id;

-- 查询每个工种的工种名称和员工人数，并且按员工人数降序排序
select job_title, count(*) as num
from jobs as j
join employees as e
on j.job_id = e.job_id
group by job_title
order by num desc;

-- 查询员工名字、部门名称和所在的城市，并按部门名称降序排序
select first_name, department_name, city
from employees as e
join departments as d
on e.department_id = d.department_id
join locations as l
on d.location_id = l.location_id
order by department_name desc;

-- 非等值链接
-- 查询员工的工资和工资级别
select salary, grade_level
from employees as e
join job_grades as j
on e.salary between j.lowest_sal and j.highest_sal;

-- 查询员工编号、员工名字、上司编号和名字
select e.employee_id, e.first_name, e.manager_id, m.first_name as manager_name
from employees as e
join employees as m
on e.manager_id = m.employee_id;

-- 查询 90 号部门员工的工种编号和位置编号
select job_id, location_id
from employees as e
join departments as d
on e.department_id = d.department_id
where e.department_id = 90;

-- 查询有提成的员工，员工名字、部门名称、位置编号和城市
select first_name, department_name, d.location_id, city
from employees as e
join departments as d
on e.department_id = d.department_id
join locations as l
on d.location_id = l.location_id
where commission_pct is not null;

-- 查询在 toronto 市工作的员工，员工名字、工种编号、部门编号和部门名称
select first_name, e.job_id, e.department_id, department_name
from employees as e
join jobs as j
on e.job_id = j.job_id
join departments as d
on e.department_id = d.department_id
join locations as l
on d.location_id = l.location_id
where city = 'toronto';

-- 查询每个部门的部门名称、工种名称、该工种的最低工资
select department_name, job_title, min(min_salary) as min_salary
from departments as d
join employees as e
on d.department_id = e.department_id
join jobs as j
on e.job_id = j.job_id
group by department_name, job_title;

-- 查询拥有部门数量大于 2 的国家，国家编号和部门数量
select country_id, count(department_id) as num
from locations as l
join departments as d
on l.location_id = d.location_id
group by country_id
having num > 2;

-- 查询名为 Lisa 的员工，员工编号、其上司编号和名字
select a.first_name, a.employee_id, a.manager_id, b.first_name
from employees as a
join employees as b
on a.manager_id = b.employee_id
where a.first_name = 'Lisa';

-- 查询没有部门的城市
select city
from departments as d
right join locations as l
on d.location_id = l.location_id
where department_id is null;

-- 查询任职部门名为 sal 和 it 的员工信息
select e.*
from employees as e
join departments as d
on e.department_id = d.department_id
where d.department_name in ('sal', 'it');

-- 查询名字中包含 e 的员工，其名字和工种名称
select first_name, job_title
from employees as e
join jobs as j
on e.job_id = j.job_id
where first_name like '%e%';

-- 查询拥有部门数量大于 3 的城市，城市名和部门数量
select city, count(*) as num
from departments as d
join locations as l
on l.location_id = d.location_id
group by city
having num > 3;

-- 查询员工人数大于 10 的部门，部门名称和员工人数，并按人数降序排序
select department_name, count(*) as num
from employees as e
join departments as d
on e.department_id = d.department_id
group by department_name
having num > 10
order by num desc;

-- 查询员工名字、部门名称、工种名称，并按部门名称降序排序
select first_name, department_name, job_title
from employees as e
join departments as d
on e.department_id = d.department_id
join jobs as j
on e.job_id = j.job_id
order by department_name desc

-- 查询员工的工资和工资级别
select first_name, salary, grade_level as grade
from employees as e
join job_grades as j
on e.salary between j.lowest_sal and j.highest_sal;

-- 查询工资级别和该级别的员工人数，不包括人数小于 20 的工资级别
select grade_level, count(*) as num
from job_grades as j
join employees as e
on e.salary between j.lowest_sal and j.highest_sal
group by grade_level
having num >= 20;

-- 查询所有员工的名字和所属部门的名称
select first_name, department_name
from employees as e
left join departments as d
on e.department_id = d.department_id;

-- 查询所有部门的名称以及该部门的平均工资 average_salary （不要小数部分），并按平均工资降序排序
select department_name, truncate(avg(salary), 0) as average_salary
from employees as e
right join departments as d
on e.department_id = d.department_id
group by department_name;

-- 将上面的 SQL 代码放到 02-sql 目录下的 07-join.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库