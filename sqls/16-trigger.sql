11. 触发器
要求：

做下面的准备工作
创建数据库 tg（下面的操作都在这个数据库完成）
检查 tg 数据库是否创建成功
创建表 tb_tg，包括两个字段：id 字段（int、主键、自增）和 note 字段（varchar(20)）
创建表 tb_tg_log，包括两个字段：id 字段（int、主键、自增）和 log 字段（varchar(40)）
创建表 employees，包括四个字段：employee_id, first_name, salary 和 manager_id，数据来自 northwind.employees
检查三个表的结构
检查 employees 表的数据，确认有 northwind.employees 表对应的 107 条记录
创建名为 after_insert 的触发器，在 tb_tg 表插入数据后，向 tb_tg_log 表中插入日志信息
日志信息的格式是：[datetime insert]: note，datetime 代表 insert 发生的当前日期和时间，下同
查看该触发器，确认创建成功
在 tb_tg 表添加一条日志，内容随意
查看 td_tg 和 td_tg_log 表的数据，确认触发器正常工作
.
创建名为 after_delete 的触发器，在 tb_tg 表删除数据后，向 tb_tg_log 表中插入日志信息
日志信息的格式是：[datetime delete]: note
查看该触发器，确认创建成功
在 tb_tg 表删除一条日志
查看 td_tg 和 td_tg_log 表的数据，确认触发器正常工作
.
定义触发器 salary_check，在员工表添加新员工前检查其薪资是否大于他领导的薪资
如果员工薪资大于其领导薪资，则报 sqlstate 为 45000 的错误
查看该触发器，确认创建成功
在员工表表添加一条记录，做通过性测试，检查员工表的数据
在员工表表添加一条记录，做失效性测试，检查员工表的数据
确认这个触发器能正常工作
.
分别用三种方式查看上面创建的某个触发器
删除上面创建的三个触发器
.
将上面的 SQL 代码放到 02-sql 目录下的 16-trigger.sql 文件中
提交代码仓库，推送到 bitbucket 远程代码仓库