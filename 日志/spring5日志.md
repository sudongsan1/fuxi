

# spring日志

### JCL

**jakartaCommonsLoggingImpl**

jcl他不直接记录日志,他是通过第三方记录日志，如果使用jcl来记录日志:

- 在没有log4j的依赖情况下,是用jul

- 如果有了log4j则使用log4j

jcl=Jakarta commons-logging ,是apache公司开发的一个抽象日志通用框架,本身不实现日志记录,但是提供了记录日志的抽象方法即接口(info,debug,error.......),底层通过一个数组存放具体的日志框架的类名,然后循环数组依次去匹配这些类名是否在app中被依赖了,如果找到被依赖的则直接使用,所以他有先后顺序。

**JCL+Log4J组合使用模式（即commons-logging+log4j）：**

1. commons-logging-1.1.jar
2. log4j-1.2.15.jar
3. log4j.properties

```xml
<dependency>
   <groupId>commons-logging</groupId>
    <artifactId>commons-logging</artifactId>
    <version>1.1.1</version>
</dependency>

<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

log4j配置文件
```properties
log4j.rootCategory=INFO, stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{ABSOLUTE} %5p %t %c{2}:%L - %m%n
log4j.category.org.springframework.beans.factory=DEBUG
```

```properties
log4j.rootLogger=INFO, stdout

##appender console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.out
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d (%t) [%p - %] %m%n
```

### slf4j

slf4j他也不记录日志,通过**binder**绑定器绑定一个具体的日志记录来完成日志记录

他只提供一个核心slf4j api(就是slf4j-api.jar包)，这个包只有日志的接口，并没有实现，所以如果要使用就得再给它提供一个实现了些接口的日志包，比 如：log4j,common logging,jdk log日志实现包等，但是这些日志实现又不能通过接口直接调用，实现上他们根本就和slf4j-api不一致，因此slf4j又增加了一层binder来转换各日志实现包的使用，当然slf4j-simple除外。

**slf4j+log4j组合使用模式：**

1. slf4j-api-1.5.11.jar
2. slf4j-log4j12-1.5.11.jar(绑定器)
3. log4j-1.2.15.jar
4. log4j.properties(也可以是 log4j.xml)

### 不同的获取logger的方式

```java
log4j：
import org.apache.log4j.Logger;
Logger logger= Logger.getLogger(xx.class);

jcl+log4j:
import org.apache.commons.logging.Log; 
import org.apache.commons.logging.LogFactory;
private static Log log = LogFactory.getLog(xx.class);

slf4j+log4j：
import  org.slf4j.Logger;
import  org.slf4j.LoggerFactory;
Logger logger = LoggerFactory.getLogger(xx.class);
```

### Spring的日志管理

#### spring5.日志技术实现

spring5使用的spring的jcl(spring改了jcl的代码,变成了**spring-jcl**)来记录日志的,但是jcl不能直接记录日志,采用循环优先的原则

![image.png](https://upload-images.jianshu.io/upload_images/4237057-3922425e3d41e6d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



```java
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class LogTest {
    public static void main(String[] args) {
        Log log = LogFactory.getLog(LogTest.class);
        log.info("info");
    }
}
```

源码解析：

```java
/**
	 * Convenience method to return a named logger.
	 * @param clazz containing Class from which a log name will be derived
	 */
	public static Log getLog(Class<?> clazz) {
		return getLog(clazz.getName());
	}

/**
	 * Convenience method to return a named logger.
	 * @param name logical name of the <code>Log</code> instance to be returned
	 */
	public static Log getLog(String name) {
		return LogAdapter.createLog(name);
	}
```

最终调用`LogAdapter.createLog(name)`

![image.png](https://upload-images.jianshu.io/upload_images/4237057-e67bbf391d957b93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![image.png](https://upload-images.jianshu.io/upload_images/4237057-9b0d984fceaba913.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**分析源码可知:**

在没有LOG4J(其实为log4j2.x)，SLF4J_LAL，Slf4j时，logApi默认情况下调用`JavaUtilAdapter.createLog(name)`方法创建jcl，如果需要log4j或slf4j则需要添加额外依赖

![image.png](https://upload-images.jianshu.io/upload_images/4237057-aff42bda4e39781d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**总结：**

- spring5默认jul


- spring5+slf4j：以绑定到log4j为例，不需要像spring4那样要桥接到slf4j


```xml
<!--spring-context-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.9.RELEASE</version>
</dependency>

<!--slf4j-api-->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.25</version>
</dependency>

<!--slf4j绑定器绑定到log4j-->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>1.7.25</version>
</dependency>
```



####  spring4.日志技术实现

spring4当中依赖的是原生的jcl

![image.png](https://upload-images.jianshu.io/upload_images/4237057-09733996011a9827.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

spring中默认使用的日志是`commons-logging`，简称`JCL`，**只需要log4j+log4j.properties**

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>
        <version>4.3.24.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>log4j</groupId>
        <artifactId>log4j</artifactId>
        <version>1.2.17</version>
    </dependency>
</dependencies>
```

**log4j2+log4j.properties**

```xml
<dependencies>

	<dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>
        <version>4.3.24.RELEASE</version>
    </dependency>
    
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.6.2</version>
    </dependency>
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-jcl</artifactId>
        <version>2.6.2</version>
    </dependency>
</dependencies>
```

### spring不使用自带的Commons Logging

如果觉得spring自带的`JCL`不合适，可以自己进行替换，有以下两种方法：

- 直接从`spring-core`排除掉`commons-logging`的依赖，因为`spring-core`是唯一明确依赖`JCL`的模块
- 依赖于一个特殊`commons-logging`，它是一个空jar包，参考`slf4j`

### spring中使用SLF4J代替`jCL`

```xml
<dependencies>
    <!--去除spring中自带的commons-logging-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>
        <version>4.3.24.RELEASE</version>
        <exclusions>
            <exclusion>
                <groupId>commons-logging</groupId>
                <artifactId>commons-logging</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    
    <!--桥接迁徙到slf4j-->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>jcl-over-slf4j</artifactId>
        <version>1.7.21</version>
    </dependency>
    
    <!--slf4使用log4j绑定器实现-->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-log4j12</artifactId>
        <version>1.7.21</version>
    </dependency>
    
    <!--log4j包-->
    <dependency>
        <groupId>log4j</groupId>
        <artifactId>log4j</artifactId>
        <version>1.2.17</version>
    </dependency>
</dependencies>
```

如果选用`logback`作用`slf4j`，那就简单多了，因为`logback`出现的比较晚，它实现了`slf4j`,那就不需要中间包了，下面是Maven依赖。

```xml
<dependencies>
    <!--桥接-->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>jcl-over-slf4j</artifactId>
        <version>1.7.21</version>
    </dependency>
    
    <!--logback包-->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.1.7</version>
    </dependency>
</dependencies>
```

