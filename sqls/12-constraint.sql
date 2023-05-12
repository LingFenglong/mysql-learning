-- 创建 cs 数据库，下面操作都在这个数据库中完成
create database if not exists cs;

-- 创建 tb_null 表添加非空约束
-- 表中字段如下：
-- id int
-- name varchar(15)
-- email varchar(25)
-- salary decimal(10, 2)
-- 要求 id 和 name 两个字段不允许为空
use cs;

show tables;

create table if not exists tb_null (
    id int not null,
    name varchar(15) not null,
    email varchar(25),
    salary decimal(10, 2)
);

-- 检查 tb_null 表结构，确认正确设置非空约束
desc tb_null;

-- 在 tb_null 表中插入正常数据和空数据，测试非空约束的效果
insert into tb_null
values (1, 'licai', 'a@163.com', 8400);

select *
from tb_null;

-- 在 tb_null 表中更改数据，测试非空约束的效果
update tb_null
set name = null
where id = 1;

-- 修改 tb_null 表，给 email 字段添加非空约束，确认非空约束设置成功
alter table tb_null
modify email varchar(25) not null;

desc tb_null;

-- 删除 tb_null 表中 email 字段的非空约束，确认非空约束删除成功
alter table tb_null
modify email varchar(25) null;

desc tb_null;

-- 创建 tb_unique 表添加唯一值约束
-- 表中字段如下：
-- id int
-- name varchar(15)
-- email varchar(25)
-- salary decimal(10, 2)
-- 要求 id 和 email 两个字段是唯一的
-- 要求 id 是列级约束，email 是表级约束
create table if not exists tb_unique (
    id int unique,
    name varchar(15),
    email varchar(25),
    salary decimal(10, 2),
    constraint uk_tb_unique_email unique (email)
);

-- 检查 tb_unique 表结构，确认正确设置唯一值约束
desc tb_unique;

select *
from information_schema.table_constraints
where table_name = 'tb_unique';

-- 在 tb_unique 表中插入正常数据和重复数据，测试唯一值约束的效果
select *
from cs.tb_unique;

insert into cs.tb_unique
values (1, 'zs', 'a@qq.com', 6000);

insert into cs.tb_unique
values (1, 'zs', 'a@qq.com', 6000);

insert into cs.tb_unique
values (2, 'zs', 'a@qq.com', 6000);

-- 在 tb_unique 表中插入空值数据，测试唯一值约束的效果
insert into cs.tb_unique
values (null, 'zs', null, 6000);

insert into cs.tb_unique
values (null, 'zs', null, 6000);

-- 修改 tb_unique 表，给 name 字段添加唯一值约束，确认唯一值约束设置成功
desc cs.tb_unique;

delete from cs.tb_unique;

select *
from cs.tb_unique;

-- 表级约束
alter table cs.tb_unique
add constraint uk_tb_unique_sal unique (salary);

-- 列级约束
alter table cs.tb_unique
modify name varchar(15) unique;

-- 删除 tb_unique 表中 name 字段的唯一值约束，确认唯一值约束删除成功
select *
from information_schema.TABLE_CONSTRAINTS
where table_name = 'tb_unique';

desc cs.tb_unique;

show index
from cs.tb_unique;

alter table cs.tb_unique drop index uk_tb_unique_email;

alter table cs.tb_unique drop index uk_tb_unique_sal;

alter table cs.tb_unique drop index id;

alter table cs.tb_unique drop index name;

alter table cs.tb_unique drop index name_2;

-- 创建 tb_user 表添加复合唯一值约束
-- 表中字段如下：
-- id int
-- name varchar(15)
-- password varchar(25)
-- 要求 name 和 password 两个字段作为整体是唯一的
create table cs.tb_user (
    id int,
    name varchar(15),
    password varchar(25),
    constraint uk_tb_user_name_pwd unique (name, password)
);

-- 检查 tb_user 表结构，确认正确设置唯一值约束
desc cs.tb_user;

show index
from cs.tb_user;

select *
from information_schema.TABLE_CONSTRAINTS
where table_name = 'tb_user';

-- 在 tb_user 表中插入正常数据和重复数据，测试唯一值约束的效果
insert into cs.tb_user
values (1, 'zs', '123');

insert into cs.tb_user
values (1, 'zs', '124');

insert into cs.tb_user
values (1, 'ls', '123');

insert into cs.tb_user
values (1, 'ls', '124');

insert into cs.tb_user
values (1, 'ls', '124');

select *
from cs.tb_user;

-- 在 tb_user 表中插入空值数据，测试唯一值约束的效果
insert into cs.tb_user
values (null, null, null);

insert into cs.tb_user
values (null, null, null);

insert into cs.tb_user
values (null, null, null);

select *
from cs.tb_user;

-- 创建 tb_pk1 表添加主键约束
-- 表中字段如下：
-- id int
-- name varchar(15)
-- email varchar(25)
-- salary decimal(10, 2)
-- 要求 id 字段是列级主键约束
create table if not exists cs.tb_pk1 (
    id int primary key,
    name varchar(15),
    email varchar(25),
    salary decimal(10, 2)
);

drop table if exists cs.tb_pk1;

-- 检查 tb_pk1 表结构，确认正确设置主键约束
desc cs.tb_pk1;

-- 创建 tb_pk2 表跟 tb_pk1 表结构相同，区别是给 id 字段添加表级主键约束
create table if not exists cs.tb_pk2 (
    id int,
    name varchar(15),
    email varchar(25),
    salary decimal(10, 2),
    constraint primary key (id)
);

desc cs.tb_pk1;

-- 在 tb_pk1 表中插入正常数据、重复数据和空数据，测试主键约束的效果
insert into cs.tb_pk1
values (null, null, null, null);

insert into cs.tb_pk1
values (1, null, null, null);

insert into cs.tb_pk1
values (2, null, null, null);

insert into cs.tb_pk1
values (2, null, null, null);

select *
from cs.tb_pk1;

-- 创建 tb_pk3 表添加复合主键约束，tb_pk3 表的字段跟 tb_user 相同，name 和 password 两个字段整体作为主键
create table cs.tb_pk3 (
    id int,
    name varchar(15),
    password varchar(25),
    constraint primary key (name, password)
);

-- 在 tb_pk3 表中插入正常数据、重复数据和空数据，测试复合主键约束的效果
insert into cs.tb_pk3
values (1, 'zs', 123);

insert into cs.tb_pk3
values (1, null, 123);

insert into cs.tb_pk3
values (1, 'zs', null);

insert into cs.tb_pk3
values (1, null, null);

insert into cs.tb_pk3
values (1, 'zs', 123);

select *
from cs.tb_pk3;

-- 创建 tb_pk4 表，跟 tb_pk1 表结构相同，但不设置主键
create table if not exists cs.tb_pk4 (
    id int,
    name varchar(15),
    email varchar(25),
    salary decimal(10, 2)
);

-- 检查 tb_pk4 表结构
desc cs.tb_pk4;

-- 修改 tb_pk4 表，给 id 字段添加主键约束，验证主键约束添加成功
alter table cs.tb_pk4
modify id int primary key;

-- 在 tb_pk4 表，删除主键约束
alter table cs.tb_pk4 drop primary key;

-- 将上面的 SQL 代码放到 02-sql 目录下的 12-constraint.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库