

mybatis有自己的日志包，位于org.apache.ibatis.logging，封装了原生的日志，以`Log4jImpl`为例，`Log4jImpl`是mybatis自带的，而导入的log4j是原生的。在mybatis中使用log4j需要我们在pom.xml文件中导入log4j的jar包。

![image.png](https://upload-images.jianshu.io/upload_images/4237057-0cddd23b059ea73b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



mybatis日志最重要的类是`LogFactory`，在初始化`LogFactory`的时候就会加载以下静态方法：

```java
private static Constructor<? extends Log> logConstructor;

//mybatis日志加载顺序Slf4j>jcl>log4j2>log4j>jul，需要提供相应的jar包
//需要注意的是spring环境中默认导入了jcl
static {
    tryImplementation(LogFactory::useSlf4jLogging);
    tryImplementation(LogFactory::useCommonsLogging);
    tryImplementation(LogFactory::useLog4J2Logging);
    tryImplementation(LogFactory::useLog4JLogging);
    tryImplementation(LogFactory::useJdkLogging);
    tryImplementation(LogFactory::useNoLogging);
  }

//tryImplementation方法调用setImplementation(Class<? extends Log> implClass)方法
private static void tryImplementation(Runnable runnable) {
    if (logConstructor == null) {
      try {
        runnable.run();
      } catch (Throwable t) {
        // ignore
      }
    }
  }

//该方法给logConstructor赋值，也可通过org.apache.ibatis.logging.LogFactory.useLog4JLogging();赋值
private static void setImplementation(Class<? extends Log> implClass) {
    try {
      Constructor<? extends Log> candidate = implClass.getConstructor(String.class);
      Log log = candidate.newInstance(LogFactory.class.getName());
      if (log.isDebugEnabled()) {
        log.debug("Logging initialized using '" + implClass + "' adapter.");
      }
      logConstructor = candidate;
    } catch (Throwable t) {
      throw new LogException("Error setting Log implementation.  Cause: " + t, t);
    }
  }
```
总结：

```java
1.可以通过以下方法给logConstructor提前赋值
org.apache.ibatis.logging.LogFactory.useSlf4jLogging();
org.apache.ibatis.logging.LogFactory.useLog4JLogging();
org.apache.ibatis.logging.LogFactory.useLog4J2Logging();
org.apache.ibatis.logging.LogFactory.useJdkLogging();
org.apache.ibatis.logging.LogFactory.useCommonsLogging();
org.apache.ibatis.logging.LogFactory.useStdOutLogging();
2.也可以按照mybatis的给logConstructor赋值顺序自动初始化
```

