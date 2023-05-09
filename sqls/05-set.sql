-- 下载 set.sql 脚本文件，wget http://sample.wangding.co/dbms/set.sql
-- 安装 set_demo 示例数据库，具体操作参考安装 northwind 数据库

set_a
+------+------+
| m    | n    |
+------+------+
|    1 |    2 |
|    2 |    3 |
|    3 |    4 |
+------+------+

set_b
+------+------+
| m    | n    |
+------+------+
|    1 |    2 |
|    1 |    3 |
|    3 |    4 |
+------+------+

-- 对 set_demo 数据库的 set_a 和 set_b 两个表做并运算，观察查询结果
select *
from set_a
union
select *
from set_b;

-- set_a union set_b
+------+------+
| m    | n    |
+------+------+
|    1 |    2 |
|    2 |    3 |
|    3 |    4 |
|    1 |    3 |
+------+------+

-- 用 union 关键字，在 employees 表中，查询部门编号大于 90 或邮箱包含 a 的员工信息
select first_name, department_id, email
from employees
where department_id > 90
union
select first_name, department_id, email
from employees
where email like '%a%';

-- 交和差集合运算只在 MySQL 8.0.31 版本以上支持
-- 对 set_demo 数据库的 set_a 和 set_b 两个表做交运算，观察查询结果
select *
from set_a
intersect
select *
from set_b;

-- set_a intersect set_b
+------+------+
| m    | n    |
+------+------+
|    1 |    2 |
|    3 |    4 |
+------+------+

-- 对 set_demo 数据库的 set_a 和 set_b 两个表做差运算，观察查询结果

select *
from set_a
except
select *
from set_b;

-- set_a except set_b
+------+------+
| m    | n    |
+------+------+
|    2 |    3 |
+------+------+

-- 将上面的 SQL 代码放到 02-sql 目录下的 05-set.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库