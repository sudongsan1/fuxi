## MySQL其他问题

### 数据库三范式

1. 第一范式：强调的是**列的原子性**，即数据库表的每一列都是不可分割的原子数据项；

2. 第二范式：要求实体的属性**完全依赖于主关键字**。所谓完全依赖是指不能存在仅依赖主关键字一部分的属性；

3. 第三范式：任何非主属性不依赖于其它非主属性，**不能传递依赖**。

### MySQL数据类型

![image.png](https://upload-images.jianshu.io/upload_images/4237057-5474e3a2d2e9dd6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### char 和 varchar 的区别？

**char(n) ：**固定长度类型，比如：订阅 char(10)，当你输入"abc"三个字符的时候，它们占的空间还是 10 个字节，其他 7 个是空字节。char 优点：效率高；缺点：占用空间；适用场景：存储密码的 md5 值，固定长度的，使用 char 非常合适。

**varchar(n) ：**可变长度，存储的值是每个值占用的字节再加上一个用来记录其长度的字节的长度。

所以，从空间上考虑 varcahr 比较合适；从效率上考虑 char 比较合适，二者使用需要权衡。

### varchar(10) 和 varchar(20) 的区别？

varchar(10) 中 10 的涵义最多存放 10 个字符，varchar(10) 和 varchar(20) 存储  hello 所占空间一样，但后者在排序时会消耗更多内存，因为 order by col 采用 fixed_length 计算 col 长度。

### 怎么知道创建的索引有没有被使用到？或者说怎么才可以知道这条语句运行很慢的原因?

使用 Explain 命令来查看语句的执行计划，MySQL 在执行某个语句之前，会将该语句过一遍查询优化器，之后会拿到对语句的分析，也就是执行计划，其中包含了许多信息。可以通过其中和索引有关的信息来分析是否命中了索引，例如：possilbe_key、key、key_len 等字段，分别说明了此语句可能会使用的索引、实际使用的索引以及使用的索引长度。

### 什么情况下索引会失效？即查询不走索引？

下面列举几种不走索引的 SQL 语句：

1. 索引列参与表达式计算：

```
SELECT 'sname' FROM 'stu' WHERE 'age' + 10 = 30;
```

2. 函数运算：

```
SELECT 'sname' FROM 'stu' WHERE LEFT('date',4) < 1990; 
```

3. %词语%--模糊查询：

```
SELECT * FROM 'manong' WHERE `uname` LIKE '码农%' -- 走索引 SELECT * FROM 'manong' WHERE `uname` LIKE "%码农%" -- 不走索引 
```

4. 字符串与数字比较不走索引：

```
CREATE TABLE 'a' ('a' char(10)); EXPLAIN SELECT * FROM 'a' WHERE 'a'="1" -- 走索引 EXPLAIN SELECT * FROM 'a'WHERE 'a'=1 -- 不走索引，同样也是使用了函数运算 
```

5. 查询条件中有 or ，即使其中有条件带索引也不会使用。换言之，就是要求使用的所有字段，都必须建立引：

```
select * from dept where dname='xxx' or loc='xx' or deptno = 45;
```

6. 正则表达式不使用索引。

7. MySQL 内部优化器会对 SQL 语句进行优化，如果优化器估计使用全表扫描要比使用索引快，则不使用索引。

### MySQL 问题排查都有哪些手段？

1. 使用 show processlist 命令查看当前所有连接信息；

2. 使用 Explain 命令查询 SQL 语句执行计划；

3. 开启慢查询日志，查看慢查询的 SQL。

[MySQL面试题](https://mp.weixin.qq.com/s/uIFHe8Myb0RvNxtAivSzOA)

