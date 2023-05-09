-- 12. DCL
CREATE USER USER_NAME@HOST IDENTIFIED BY PWD;

CREATE USER 'lingfenglong'@HOST IDENTIFIED BY '147258369';

SELECT
    USER
FROM
    MYSQL.USER;

SELECT
    USER
FROM
    MYSQL.USER WHEN USER == 'lingfenglong';

-- 改用户名
RENAME USER_NAME OLD_NAME TO NEW_NAME;
UPDATE MYSQL.USER
SET
    USER = 'new_name'
WHERE
    USER = 'old_name';
FLUSH PRIVILEGE;

-- 改密码
ALTER USER 'username' IDENTIFIED BY 'password';
SET PASSWORD FOR 'username' = 'password';

ALTER USER 'username' IDENTIFIED BY 'password';
ALTER USER() IDENTIFIED BY 'password';

-- 删除用户
DROP USER 'user_name';

-- 权限
SHOW PRIVILEGE;
SHOW GRANTS FOR 'username';

GRANT SELECT ON NORTHWIND.* TO 'username';
GRANT ALL PRIVILEGES ON *.* TO 'username' with GRANT OPTION;

REVOKE SELECT ON NORTHWIND.* FROM 'username';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'username';

-- 创建 MySQL 用户，用户名：自己姓名的拼音，密码：123456
-- 创建 MySQL 用户，用户名：zhang3@localhost，密码：123456
-- 查看创建的用户
-- 查看当前登录用户
-- 修改用户 zhang3 为 li4，刷新权限
-- 用 drop 关键字删除 li4 用户
-- 创建 zhang3 用户，用 delete 关键字删除 zhang3 用户，刷新权限
-- 用 alter 关键字修改当前用户（root）的密码，重新登录 MySQL
-- 用 set 关键字修改当前用户（root）的密码，重新登录 MySQL
-- 用 alter 关键字修改自己姓名用户的密码为 ddd
-- 用 set 关键字修改自己姓名用户的密码为 123456
-- 列出 MySQL 的所有权限
-- 授予自己姓名用户 northwind 库所有表的增、删、改、查权限，用自己姓名用户登录 MySQL，查询 northwind
-- 授予自己姓名用户所有库所有表的权限，用自己姓名用户名登录 MySQL，建库、查询 northwind
-- 查看当前用户的权限
-- 查看 root 或自己姓名账户的权限
-- 收回自己姓名用户的所有权限，用自己姓名用户登录 MySQL
-- 查看 mysql.user 表结构
-- 查看 mysql.user 表的所有数据
-- 查看 mysql.user 表中 user, host 和 authentication_string（加密的密码） 三列数据
-- 查看 mysql.db 表结构和数据
-- 查看 mysql.tables_priv 表结构和数据
-- 查看 mysql.columns_priv 表结构和数据
-- 查看 mysql.procs_priv 表结构和数据
-- .
-- 将上面的 SQL 代码放到 02-sql 目录下的 17-dcl.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库