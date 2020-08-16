## centos7安装mysql

**获取mysql**

```
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

rpm -ivh mysql57-community-release-el7-9.noarch.rpm
```

执行完成后会在/etc/yum.repos.d/目录下生成两个repo文件mysql-community.repo mysql-community-source.repo

**安装命令**

```
yum install mysql-server
```

**启动MySQL**

```
systemctl start mysqld
```

获取安装时的临时密码

```
grep 'temporary password' /var/log/mysqld.log
```

**登录mysql**

```
mysql -u root -p

然后输入密码（刚刚获取的临时密码）
```
**修改密码**

输入初始密码，此时不能做任何事情，因为MySQL默认必须修改密码之后才能操作数据库

mysql> ALTER USER ‘root’@‘localhost’ IDENTIFIED BY ‘new password’;
这里有个问题，新密码设置的时候如果设置的过于简单会报错：

原因是因为MySQL有密码设置的规范，具体是与validate_password_policy的值有关：

可以通过如下命令修改：

```mysql
mysql> set global validate_password_policy=0;
mysql> set global validate_password_length=1;
```

再次执行修改密码

```mysql
mysql> ALTER USER ‘root’@‘localhost’ IDENTIFIED BY ‘new password’;
```

**查询端口**

```
firewall-cmd --zone=public --query-port=3266/tcp
```

返回no表示没有防火墙中没有开放这个端口，默认端口3266

添加端口到防火墙

```
firewall-cmd --zone=public --add-port=3306/tcp --permanent
```

重启防火墙

```
firewall-cmd --reload
```

**密码重置**

```
1、vim /etc/my.cnf 加入skip-grant-tables
如：
[mysqld]
skip-grant-tables

2、重启mysql
systemctl restart mysqld

3、update mysql.user set authentication_string=password(“123456”) where user=“root”;

4、vim /etc/my.cnf 去掉skip-grant-tables

5、重启mysql
systemctl restart mysqld
```

立即启用修改 （刷新）

```
flush privileges;
```

**开启远程控制**

新安装的MySQL默认只能本机登录.修改权限给所有主机使用:

方式一：已验证

```
   1. 连接服务器: mysql -u root -p
   
   2. 看当前所有数据库：show databases;
   
   3. 进入mysql数据库：use mysql;
   
   4. 查看mysql数据库中所有的表：show tables;
   
   5. 查看user表中的数据：select Host, User,Password from user;
   
   6. 修改user表中的Host:   update user set Host='%' where User='root';  
   
      说明： % 代表任意的客户端,可替换成具体IP地址。
   
   7. 最后刷新一下：flush privileges;
```

方式二：未验证

```
grant all privileges on *.* to root@‘%’ identified by ‘123456’ with grant option;
```

**其他常用命令**

```
1、设置安全选项：
mysql_secure_installation

2、关闭MySQL
systemctl stop mysqld 

3、重启MySQL
systemctl restart mysqld 

4、查看MySQL运行状态
systemctl status mysqld 

5、设置开机启动
systemctl enable mysqld 

6、关闭开机启动
systemctl disable mysqld 

7、配置默认编码为utf8：
vi /etc/my.cnf 
#添加 
[mysqld] 
character_set_server=utf8 init_connect='SET NAMES utf8'
```

默认配置路径：

```
配置文件：/etc/my.cnf 

日志文件：/var/log/var/log/mysqld.log 

服务启动脚本：/usr/lib/systemd/system/mysqld.service 

socket文件：/var/run/mysqld/mysqld.pid
```

## Linux卸载mysql：

**一、使用以下命令查看当前安装mysql情况，查找以前是否装有mysql**

```
rpm -qa|grep -i mysql
```

**2、停止mysql服务、删除之前安装的mysql**

删除命令：rpm -e –nodeps 包名

```
rpm -ev MySQL-client-5.5.25a-1.rhel5 
rpm -ev MySQL-server-5.5.25a-1.rhel5
```

如果提示依赖包错误，则使用以下命令尝试

```
rpm -ev MySQL-client-5.5.25a-1.rhel5 --nodeps
```

如果提示错误：error: %preun(xxxxxx) scriptlet failed, exit status 1

则用以下命令尝试：

```
rpm -e --noscripts MySQL-client-5.5.25a-1.rhel5
```

**3、查找之前老版本mysql的目录、并且删除老版本mysql的文件和库**

```
find / -name mysql
```


查找结果如下：

```
/var/lib/mysql
/var/lib/mysql/mysql
/usr/lib64/mysql
```

删除对应的mysql目录

```
rm -rf /var/lib/mysql
rm -rf /var/lib/mysql
rm -rf /usr/lib64/mysql
```

具体的步骤如图：查找目录并删除

具体的步骤如图：查找目录并删除

注意：卸载后/etc/my.cnf不会删除，需要进行手工删除

```
rm -rf /etc/my.cnf
```

**再次查找机器是否安装mysql**

**4、再次查找机器是否安装mysql**

```
rpm -qa|grep -i mysql
```

