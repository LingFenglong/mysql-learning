show variables like '%validate_password%';
set global validate_password.length = 1;
set global validate_password.policy = low;

-- 创建 MySQL 用户，用户名：自己姓名的拼音，密码：123456
create user 'lingfenglong' identified by '123456';

-- 创建 MySQL 用户，用户名：zhang3@localhost，密码：123456
create user 'zhang3' @'localhost' identified by '123456';

-- 查看创建的用户
select user,
    host
from mysql.`user`;

-- 查看当前登录用户
select user();
select current_user();

-- 修改用户 zhang3 为 li4，刷新权限
rename user 'zhang3'@'localhost' to 'li4'@'localhost';
flush privileges;

-- 用 drop 关键字删除 li4 用户
drop user 'li4'@'localhost';

-- 创建 zhang3 用户，用 delete 关键字删除 zhang3 用户，刷新权限
create user 'zhang3' identified by '123456';
delete from mysql.user
where user = 'zhang3';

flush privileges;

select user,
    host
from mysql.user;


select *
from mysql.`user`
where user = 'zhang3'; 
-- 用 alter 关键字修改当前用户（root）的密码，重新登录 MySQL
alter user 'zhang3' identified by '456789';

-- 用 set 关键字修改当前用户（root）的密码，重新登录 MySQL
set password for 'zhang3' = '123456';

-- 用 alter 关键字修改自己姓名用户的密码为 ddd
alter user current_user() identified by '147258369';

-- 用 set 关键字修改自己姓名用户的密码为 123456
set password for current_user() = '147258369';

select user();
select current_user();

-- 列出 MySQL 的所有权限
show privileges;

-- 授予自己姓名用户 northwind 库所有表的增、删、改、查权限，
-- 用自己姓名用户登录 MySQL，查询 northwind
SELECT user, host from mysql.`user`;
grant insert,
    delete,
    update,
    select on northwind.* to 'lingfenglong' @'%';

-- 授予自己姓名用户所有库所有表的权限，用自己姓名用户名登录 MySQL，建库、查询 northwind
grant all privileges on *.* to 'lingfenglong' @'%';

-- 查看当前用户的权限
show grants for current_user;

-- 查看 root 或自己姓名账户的权限
show grants for 'root'@'%';

show grants for 'lingfenglong';

-- 收回自己姓名用户的所有权限，用自己姓名用户登录 MySQL
revoke all privileges on *.*
from 'zhang3';

-- 查看 mysql.user 表结构
desc mysql.`user`;

-- 查看 mysql.user 表的所有数据
select *
from mysql.`user`;

-- 查看 mysql.user 表中 user, host 和 authentication_string（加密的密码） 三列数据
select user,
    host,
    authentication_string
from mysql.`user`;

-- 查看 mysql.db 表结构和数据
desc mysql.db;

select *
from mysql.db;

-- 查看 mysql.tables_priv 表结构和数据
desc mysql.tables_priv;

select *
from mysql.tables_priv;

-- 查看 mysql.columns_priv 表结构和数据
desc mysql.columns_priv;
SELECT * FROM mysql.columns_priv;

-- 查看 mysql.procs_priv 表结构和数据
desc mysql.procs_priv;
select *
from mysql.procs_priv

-- 将上面的 SQL 代码放到 02-sql 目录下的 17-dcl.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库