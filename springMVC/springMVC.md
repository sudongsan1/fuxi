本文创建的springMVC项目是基于maven创建的webapp项目，分为***schema-based***（通过xml配置文件来完成配置）和***code-based***

### Maven web项目的创建

创建maven项目，注意是maven-archetype-webapp

![image.png](https://upload-images.jianshu.io/upload_images/4237057-94f23ad8685e16fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

项目创建完成之后的目录结构

![image.png](https://upload-images.jianshu.io/upload_images/4237057-2aef61a5dbf09d1a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 基于***code-based***创建springMVC

 **依赖项：**

```xml
<!--spring的主要依赖-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.11.RELEASE</version>
</dependency>

<!--web-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.1.11.RELEASE</version>
</dependency>

<!--springMVC 依赖servlet API（说白了就是开发springMVC必须下载servlet-api.jar）-->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.1.0</version>
    <scope>provided</scope>
</dependency>
```



***schema-based***配置中web.xml的工作主要有两个配置：

1. 配置一个listener来load spring的配置文件（就是通常取名叫做applicationContext.xml）
   根据配置文件里面的信息来初始化spring的上下文环境。

2. 配置一个servlet（DispatcherServlet）来load springMVC的配置文件。

   并且根据springMVC的配置文件信息来完成对springWEB的环境初始化。

![image.png](https://upload-images.jianshu.io/upload_images/4237057-2090f2599aa75aaf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在`web.xml`中配置监听springcontext的监听器和springMVC的DispatcherServlet

```xml
<web-app>
<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>

<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>/WEB-INF/app-context.xml</param-value>
</context-param>

<servlet>
    <servlet-name>app</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value></param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>app</servlet-name>
    <url-pattern>/app/*</url-pattern>
</servlet-mapping>
</web-app>
```

配置`dispatcher-servlet.xml`，负责mvc的配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd">
    <!--此文件负责整个mvc中的配置-->
<!--启用spring的一些annotation -->
<context:annotation-config/>
 
<!-- 配置注解驱动 可以将request参数与绑定到controller参数上 -->
<mvc:annotation-driven/>
 
<!--静态资源映射-->
<!--本项目把静态资源放在了webapp的statics目录下，资源映射如下-->
<mvc:resources mapping="/css/**" location="/statics/css/"/>
<mvc:resources mapping="/js/**" location="/statics/js/"/>
<mvc:resources mapping="/image/**" location="/statics/images/"/>
<mvc:default-servlet-handler />  <!--这句要加上，要不然可能会访问不到静态资源，具体作用自行百度-->
 
<!-- 对模型视图名称的解析，即在模型视图名称添加前后缀(如果最后一个还是表示文件夹,则最后的斜杠不要漏了) 使用JSP-->
<!-- 默认的视图解析器 在上边的解析错误时使用 (默认使用html)- -->
<bean id="defaultViewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
    <property name="prefix" value="/views/"/><!--设置JSP文件的目录位置-->
    <property name="suffix" value=".jsp"/>
    <property name="exposeContextBeansAsAttributes" value="true"/>
</bean>
 
<!-- 自动扫描装配 -->
<context:component-scan base-package="example.controller"/>
</beans>
```

 配置`applicationContext.xml`，负责一些非MVC组件的配置
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd 
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    <context:component-scan base-package="example"/>
</beans>
```

***code-based***配置

spring官网中提供基于code-based配置，代替了原来繁琐的xml配置

![image.png](https://upload-images.jianshu.io/upload_images/4237057-ccd2db555bcfe59c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以下两张图来自网络，对***code-based***进行了详细的解释，`MyWebApplicationInitializer`这个类（以下简称`Initializer`）的主要作用就是来代替`schema-based`风格中的`web.xml`

![20171217154248385.png](https://upload-images.jianshu.io/upload_images/4237057-26872cfbe438f299.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![20171217154209207.png](https://upload-images.jianshu.io/upload_images/4237057-f94aebdc6ba25af5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```java
public class MyWebApplicationInitializer implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {

        AnnotationConfigWebApplicationContext ac = new AnnotationConfigWebApplicationContext();
        ac.register(AppConfig.class);
        ac.refresh();
        DispatcherServlet dispatcherServlet = new DispatcherServlet(ac);
        ServletRegistration.Dynamic registration = servletContext.addServlet("app",dispatcherServlet);
        registration.setLoadOnStartup(1);
        registration.addMapping("/");
    }
}
```
AppConfig.java
```java
@Configuration
@ComponentScan("com.luban.web")
public class AppConfig {
}
```

测试：

```java
@Controller
public class IndexController {
    @RequestMapping("/index")
    @ResponseBody
    public String index(){
        return "hello";
    }
}
```

Tomcat运行：

1.pom.xml中添加plugin

```xml
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
</plugin>
```

2.配置Tomcat

EditConfigurations

![image.png](https://upload-images.jianshu.io/upload_images/4237057-20ce658868162ce2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/4237057-9d88bac3558c021e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/4237057-bb5a85c91451bbd3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/4237057-3cc7f91856179331.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![20180521095302119.png](https://upload-images.jianshu.io/upload_images/4237057-e66072e1bbc4070e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)