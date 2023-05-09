-- 创建数据库 store，验证数据库是否创建成功
-- 创建表 books，表结构如下：
-- id int
-- name varchar(50)
-- authors varchar(100)
-- price float
-- pubdate year
-- category varchar(100)
-- num int
create database
  if not exists store character set 'utf8';


create table if not exists
  store.books (
    id int,
    name varchar(50),
    authors varchar(100),
    price float,
    pubdate year,
    category varchar(100),
    num int
  );


-- 查看 books 表结构
desc store.books;


-- 查询 books 表中记录
select
  *
from
  store.books;


-- books 表中数据如下
-- id, name, authors, price, pubdate, category, num
-- 1, 看见, 柴静, 39.8, 2013, novel, 13
-- 2, 我的天才女友, [意] 埃莱娜·费兰特, 42, 2017, joke, 22
-- 3, 局外人, [法] 阿尔贝·加缪, 22, 2010, novel, 0
-- 4, 步履不停, [日] 是枝裕和, 36.8, 2017, novel, 30
-- 5, 法学导论, [德] 古斯塔夫·拉德布鲁赫, 30, 2001, law, 10
-- 6, 本草纲目, 李时珍, 30, 1990, medicine, 40
-- 7, 火影忍者, [日] 岸本齐史, 88, 1999, cartoon, 28
-- 不指定字段名称，向 books 表插入 id 为 1 的记录
insert into
  store.books
values
  (1, '看见', '柴静', 39.8, 2013, 'novel', 13);


-- 指定所有字段名称，向 books 表插入 id 为 2 的记录
insert into
  store.books (id, name, authors, price, pubdate, category, num)
values
  (2, '我的天才女友', '[意] 埃莱娜·费兰特', 42, 2017, 'joke', 22);


-- 向 books 表同时插入剩余所有记录
insert into
  store.books
values
  (3, '局外人', '[法] 阿尔贝·加缪', 22, 2010, 'novel', 0),
  (4, '步履不停', '[日] 是枝裕和', 36.8, 2017, 'novel', 30),
  (5, '法学导论', '[德] 古斯塔夫·拉德布鲁赫', 30, 2001, 'law', 10),
  (6, '本草纲目', '李时珍', 30, 1990, 'medicine', 40),
  (7, '火影忍者', '[日] 岸本齐史', 88, 1999, 'cartoon', 28);


-- 将小说类型图书的价格增加 5 元
update
  books
set
  price = price + 5
where
  category = 'novel';


-- 将局外人图书的价格改为 40，并将类别改为 memoir
update
  books
set
  price = 40,
  category = 'memoir'
where
  name = '局外人';


-- 删除库存为 0 的图书
delete from
  books
where
  num = 0;


-- 查找书名中包含火的图书
select
  *
from
  books
where
  name like '%火%';


-- 统计书名中包含火的书的数量和库存总量
select
  count(*),
  sum(num)
from
  books
where
  name like '%火%';


-- 查找 novel 类型的书，按照价格降序排列
select
  *
from
  books
where
  category = 'novel'
order by
  price desc;


-- 查询图书信息，按照库存量降序排列，如果库存量相同的按照 category 升序排列
select
  *
from
  books
order by
  num desc,
  category asc;


-- 按照 category 分类统计书的数量
select
  category,
  count(*)
from
  books
group by
  category;


-- 按照 category 分类统计书的库存量，显示库存量超过 35 本的
select
  category,
  sum(num)
from
  books
group by
  category
having
  sum(num) > 35;


-- 查询所有图书，每页显示 3 本，显示第二页
select
  *
from
  books
limit
  3, 3;


-- offset, num
-- 按照 category 分类统计书的库存量，显示库存量最多的
select
  category,
  sum(num) as sum_num
from
  books
group by
  category
order by
  sum_num desc
limit
  0, 1;


-- 查询作者名称达到 7 个字符的书，不包括里面的空格
select
  char_length(
    replace
      (authors, ' ', '')
  )
from
  books;


select
  name,
  authors
from
  books
where
  char_length(
    replace
      (authors, ' ', '')
  ) >= 7;


-- 查询书名和类型，其中 category 值为 novel 显示小说，law 显示法律，
-- medicine 显示医药，cartoon 显示卡通，joke 显示笑话
select
  name,
  category,
  case
    category
    when 'novel' then '小说'
    when 'law' then '法律'
    when 'medicine' then '医药'
    when 'cartoon' then '卡通'
    when 'joke' then '笑话'
    else '其他'
  end as 'type'
from
  books;


-- 查询书名、库存，其中 num 值超过 30 本的，显示滞销，
-- 大于 0 并低于 10 的，显示畅销，为 0 的显示需要无货，其他显示正常
select
  name,
  num,
  case
    when num > 30 then '滞销'
    when num > 0
    and num < 10 then '畅销'
    when num = 0 then '无货'
    else '正常'
  end as 'status'
from
  books;


-- 统计每一种 category 的库存量，并合计总量
select
  ifnull(category,'total'),
  sum(num)        as sum_num
from
  books
group by
  category
with
  rollup;


-- 统计每一种 category 的数量，并合计总量
select
  ifnull(category,'total'),
  count(*)        as count
from
  books
group by
  category
with
  rollup;


-- 统计库存量前三名的图书
select
  *
from
  books
order by
  num desc
limit
  0, 3;


-- 找出最早出版的一本书
select
  *
from
  books
order by
  pubdate asc
limit
  0, 1;


-- 找出 novel 中价格最高的一本书
select
  *
from
  books
where
  category = 'novel'
order by
  price desc
limit
  0, 1;


-- 找出作者名中字数最多的一本书，不含空格
select
  *
from
  books
order by
  char_length(
    replace
      (authors, ' ', '')
  ) desc
limit
  0, 1;


-- 将上面的 SQL 代码放到 02-sql 目录下的 10-dml.sql 文件中
-- 提交代码仓库，推送到 bitbucket 远程代码仓库
select
  *
from
  Employees;
