## FactoryBean和BeanFactory区别

BeanFactory接口是springIOC的顶级接口，负责解析，获取bean等

FactoryBean接口：可以通过getObject（）方法返回bean（实例化的bean），让程序员插手bean实例化的过程。spring中applicationContext可以获得两个对象，beanName获得的是getObject（）返回的bean；&+beanName获得的是FactoryBean对象。

spring中一个bean实例化的过程：class-->beanDefinition-->reader.registry()注册到bdMap中-->bean实例化

