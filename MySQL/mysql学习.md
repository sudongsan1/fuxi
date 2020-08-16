创建索引的语法:
```sql
create index  [indexname]  on [tablename]([column_name]);
create index idx_t1_bcd on t1(b,c,d);
```

查看表的索引：
```sql
show index from table_name（表名）
```
mysql查询表属于哪个数据库
```sql
select table_schema from information_schema.TABLES WHERE table_name = '表名';
```

```sql
create table t1(
a int primary key,
b int,
c int,
d int,
e varchar(20)
)engine=MyISAM
```

```sql
insert into t1 values(4, 3, 1, 1,'d');
insert into t1 values(1, 1, 1, 1,'a');
insert into t1 values(8, 8, 8, 8,'h');
insert into t1 values(2, 2, 2, 2,'b');
insert into t1 values(5, 2, 3, 5,'e');
insert into t1 values(3, 3, 2, 2,'c');
insert into t1 values(7, 4, 5, 5,'g');
insert into t1 values(6, 6, 4, 4,'f');


insert into t2 values(4, 3, 1, 1,'d');
insert into t2 values(1, 1, 1, 1,'a');
insert into t2 values(8, 8, 8, 8,'h');
insert into t2 values(2, 2, 2, 2,'b');
insert into t2 values(5, 2, 3, 5,'e');
insert into t2 values(3, 3, 2, 2,'c');
insert into t2 values(7, 4, 5, 5,'g');
insert into t2 values(6, 6, 4, 4,'f');
```

## 事务：
https://mp.weixin.qq.com/s/IWthSznQpNiY5BiI26RM2g