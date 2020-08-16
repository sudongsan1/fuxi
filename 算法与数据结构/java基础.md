# Java动态代理

https://www.jianshu.com/p/95970b089360

https://www.cnblogs.com/leifei/p/8263448.html

**java动态代理是利用反射机制生成一个实现代理接口的匿名类，在调用具体方法前调用InvokeHandler来处理。**

**而cglib动态代理是利用asm开源包，对代理对象类的class文件加载进来，通过修改其字节码生成子类来处理。**

### jdk动态代理步骤：

**1.Proxy的newInstance方法对这个实例对象代理生成一个代理对象。**

![1569156817222](C:\Users\WPC\AppData\Roaming\Typora\typora-user-images\1569156817222.png)

**2.InvocationHandler**

![1569156890020](C:\Users\WPC\AppData\Roaming\Typora\typora-user-images\1569156890020.png)

