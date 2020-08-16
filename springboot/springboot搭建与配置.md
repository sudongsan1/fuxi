### 三种构建方式

1、使用官网提供的Quick start。https://start.spring.io/ 

2、创建Maven项目的方式。

3、使用IDEA中Spring Initializr的方式。

### 目录结构

![image.png](https://upload-images.jianshu.io/upload_images/4237057-8eeab16c137c84d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 基本启动器

spring-boot-starter-parent - 所有Spring Boot组件的基础引用

spring-boot-starter-web -提供web的支持

spring-boot-starter-thymeleaf -提供thymeleaf模板引擎的支持

spring-boot-maven-plugin -提供打包的支持

```xml
<!-- Inherit defaults from Spring Boot -->
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-parent</artifactId>
	<version>2.1.10.RELEASE</version>
	<relativePath/> <!-- lookup parent from repository -->
</parent>


<dependencies>
    <!--spring-boot-starter-web-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--spring-boot-starter-thymeleaf-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
</dependencies>

<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

### SpringBoot常用配置

**application.xml**

```properties
#服务器端口配置
server.port=80
#调试模式开启(日志级别就是debug)
#debug=true
#上下文配置
server.servlet.context-path=/yoyo
#字符编码
spring.banner.charset=UTF-8
#关闭缓存(开发测试阶段建议关闭缓存)
spring.thymeleaf.cache=false
#日期格式配置(web中)
spring.mvc.date-format=yyyy-MM-dd
#日期格式配置(json中)
spring.jackson.date-format=yyyy-MM-dd
#设置时区
spring.jackson.time-zone=GMT+8
#配置日志输出
#logging.file=d:/logs/log01.log
#设置日志级别
#logging.level.ROOT=INFO
#logging.level.org.springframework=ERROR
#logging.level.org.apache=ERROR
```

**application.yml**

```yml
server:
  port: 80
  servlet:
    context-path: /yoyo
spring:
  banner:
    charset: utf-8
  thymeleaf:
    cache: false
  mvc:
    date-format: yyyy-MM-dd
  jackson:
    date-format: yyyy-MM-dd
    time-zone: GMT+8
```

### 日志

SpringBoot 日志配置 默认采用LogBack作为日志输出

具体输出的格式详解如下：

```
2019-01-10 17：30：08.685 ：日期精确到时间毫秒级别
info是日志级别 ： 可以设置为其他的级别如debug,error等
9184 ：进程id
--- : 分割符
main: 表示主线程
com.xxxxx: 通常为源码类
“：” 后即为详细的日志信息
```

| 日志常用配置项     | 默认值             | 备注                 |
| ------------------ | ------------------ | -------------------- |
| logging.file       |                    | 日志输出的文件地址   |
| logging.level.ROOT | info               | 设置日志的输出级别   |
| logging.level.*    | info               | 定义指定包的输出级别 |
| logging.config     | logback-spring.xml | 日志的配置文件       |

注意：SpringBoot默认并没有进行文件输出，只在控制台中进行了打印。

日志级别：debug>info>warn>error，默认情况下springboot日志级别为info

如果设置了debug=true时，日志会降级为debug

**若要使用自己定义的xml配置的日志，以logback为例：**`logback.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="false">
<property name="PROJECT" value="mysb1" />
<!--定义日志文件的存储地址 勿在 LogBack 的配置中使用相对路径-->
<property name="ROOT" value="d:/logs/${PROJECT}/" />
<!--日志文件最大的大小-->
<property name="FILESIZE" value="50MB" />
<!--日志文件保留天数-->
<property name="MAXHISTORY" value="100" />
<timestamp key="DATETIME" datePattern="yyyy-MM-dd HH:mm:ss" />
<!-- 控制台打印 -->
<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder charset="utf-8">
        <pattern>[%-5level] %d{${DATETIME}} [%thread] %logger{36} - %m%n
        </pattern>
    </encoder>
</appender>
<!-- ERROR 输入到文件，按日期和文件大小 -->
<!-- RollingFileAppender 按照每天生成日志文件 -->
<appender name="ERROR" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <encoder charset="utf-8">
        <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符-->
        <pattern>[%-5level] %d{${DATETIME}} [%thread] %logger{36} - %m%n
        </pattern>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
        <level>ERROR</level>
        <onMatch>ACCEPT</onMatch>
        <onMismatch>DENY</onMismatch>
    </filter>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <!--日志文件输出的文件名-->
        <fileNamePattern>${ROOT}%d/error.%i.log</fileNamePattern>
        <!--日志文件保留天数-->
        <maxHistory>${MAXHISTORY}</maxHistory>
        <timeBasedFileNamingAndTriggeringPolicy
                class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <!--日志文件最大的大小-->
            <maxFileSize>${FILESIZE}</maxFileSize>
        </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
</appender>

<!-- WARN 输入到文件，按日期和文件大小 -->
<appender name="WARN" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <encoder charset="utf-8">
        <pattern>[%-5level] %d{${DATETIME}} [%thread] %logger{36} - %m%n
        </pattern>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
        <level>WARN</level>
        <onMatch>ACCEPT</onMatch>
        <onMismatch>DENY</onMismatch>
    </filter>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <fileNamePattern>${ROOT}%d/warn.%i.log</fileNamePattern>
        <maxHistory>${MAXHISTORY}</maxHistory>
        <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <maxFileSize>${FILESIZE}</maxFileSize>
        </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
</appender>

<!-- INFO 输入到文件，按日期和文件大小 -->
<appender name="INFO" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <encoder charset="utf-8">
        <pattern>[%-5level] %d{${DATETIME}} [%thread] %logger{36} - %m%n
        </pattern>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
        <level>INFO</level>
        <onMatch>ACCEPT</onMatch>
        <onMismatch>DENY</onMismatch>
    </filter>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <fileNamePattern>${ROOT}%d/info.%i.log</fileNamePattern>
        <maxHistory>${MAXHISTORY}</maxHistory>
        <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <maxFileSize>${FILESIZE}</maxFileSize>
        </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
</appender>
<!-- DEBUG 输入到文件，按日期和文件大小 -->
<appender name="DEBUG" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <encoder charset="utf-8">
        <pattern>[%-5level] %d{${DATETIME}} [%thread] %logger{36} - %m%n
        </pattern>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
        <level>DEBUG</level>
        <onMatch>ACCEPT</onMatch>
        <onMismatch>DENY</onMismatch>
    </filter>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <fileNamePattern>${ROOT}%d/debug.%i.log</fileNamePattern>
        <maxHistory>${MAXHISTORY}</maxHistory>
        <timeBasedFileNamingAndTriggeringPolicy
                class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <maxFileSize>${FILESIZE}</maxFileSize>
        </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
</appender>
<!-- TRACE 输入到文件，按日期和文件大小 -->
<appender name="TRACE" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <encoder charset="utf-8">
        <pattern>[%-5level] %d{${DATETIME}} [%thread] %logger{36} - %m%n
        </pattern>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
        <level>TRACE</level>
        <onMatch>ACCEPT</onMatch>
        <onMismatch>DENY</onMismatch>
    </filter>
    <rollingPolicy
            class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <fileNamePattern>${ROOT}%d/trace.%i.log</fileNamePattern>
        <maxHistory>${MAXHISTORY}</maxHistory>
        <timeBasedFileNamingAndTriggeringPolicy
                class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <maxFileSize>${FILESIZE}</maxFileSize>
        </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
</appender>

<!-- SQL相关日志输出-->
<logger name="org.apache.ibatis" level="INFO" additivity="false" />
<logger name="org.mybatis.spring" level="INFO" additivity="false" />
<logger name="com.github.miemiedev.mybatis.paginator" level="INFO" additivity="false" />

<!-- Logger 根目录 -->
<!-- 日志输出级别 -->
<root level="DEBUG">
    <appender-ref ref="STDOUT" />
    <appender-ref ref="DEBUG" />
    <appender-ref ref="ERROR" />
    <appender-ref ref="WARN" />
    <appender-ref ref="INFO" />
    <appender-ref ref="TRACE" />
</root>
</configuration>
```
