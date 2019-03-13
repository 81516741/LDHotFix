
# HotFix使用说明
#### 本热修复的主要功能描述
1.可以通过js替换项目中任意类的实例方法和类方法
2.可以在原来的方法之前和之后执行一些修正代码
3.可以修改原来方法的传入参数，然后在调用原方法
### 1.如何用CocoaPods安装
###### 在你的Podfile文件中加上:

```
pod ‘LDHotFix’
```


### 2.如何使用
1.这里以本地js的方式演示，实际过程中js是从服务器下发的

```//hook 类方法
fixClassMethod
('ProbleClass1','classMethod',
function(instance, originInvocation,originArguments){
runInvocation(originInvocation);
});

//hook 对象方法，
fixInstanceMethod
('ProblemClass','test:value2:value3:',
function(instance, originInvocation, originArguments){
//原样执行原来的 方法
runInvocation(originInvocation);
//改变参数执行原来的方法
runInvocation(originInvocation,['Float(3.141592653)','Int(81516741)','就是替换了']);
});

//修复方法
fixInstanceMethod
('ProblemClass','divide:dd:',
function(instance, originInvocation, originArguments){
//如果传入的分母是0 则执行下面的代码
if (originArguments[0] == '0') {
//创建TestObject对象
var objc = runClassWithParamters('TestObject','instance:','创建TestObject对象');
console.log('test对象是：' + objc);
//执行对象的方法
var objc1 = runInstanceWithParamters(objc,'show:name2:name3:name4:name5:name6:','我是','曾令达',' 喜欢这个热修复的','请帮我点个星','有问题可以联系我','  微信:81516741');
console.log('调用对象方法的返回值' + objc1);
//执行类方法
runClassWithParamters('TestObject','log:str:','调用Class方法:我在','马路边');
console.log('因为此时传入的参数是分母为零，所以下句代码不执行');
}else {//不为0 就执行原来的方法
runInvocation(originInvocation);
}
});
```


2.在 Appdelegate 里面执行如下代码

```- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//注册
[LDHotfixTool registerHotfix];
//加载本地js
NSString * jsPath = [[NSBundle mainBundle] pathForResource:@"fix" ofType:@"js"];
NSString * jsStr  = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];                                              
//用js修复
[LDHotfixTool evaluateScript:jsStr];
return YES;
}
```
### 3.核心文件 LDHotfix
##### 具体如何使用，请下载示例，使用非常简单，如有问题欢迎联系我,微信号 81516741

