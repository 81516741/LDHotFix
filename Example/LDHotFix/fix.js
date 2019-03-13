fixClassMethod
('ProbleClass1','test',
 function(instance, originInvocation, originArguments){
 console.log('类 方法被替 前执行');
 runInvocation(originInvocation);
 console.log('类 方法被替换了 后执行');
 });

fixInstanceMethod
('ProblemClass','divide:dd:',
function(instance, originInvocation, originArguments){
    console.log(instance)
    console.log(originInvocation)
    console.log(originArguments)
     if (originArguments[0] == '0') {
     var objc = runClassWithParamters('TestObject','instance:','创建TestObject对象');
     console.log('test对象是：' + objc);
     var objc1 = runInstanceWithParamters(objc,'show:name2:name3:name4:name5:name6:','我是','曾令达',' 喜欢这个热修复的','请帮我点个星','有问题可以联系我','  微信:81516741');
     console.log('调用对象方法的返回值' + objc1);
     runClassWithParamters('TestObject','log:str:','调用Class方法:我在','马路边');
     console.log('因为此时传入的参数是分母为零，所以下句代码不执行');
     }else {
        runInvocation(originInvocation);
     }
});

fixInstanceMethod
('ProblemClass','test:value2:value3:',
 function(instance, originInvocation, originArguments){
 console.log('在对象方法前执行');
 console.log('原样执行原来的方法');
 runInvocation(originInvocation);
 console.log('改变传参执行原来的方法');
 runInvocation(originInvocation,['Float(3.141592653)','Int(81516741)','就是替换了']);
 console.log('在对象方法后执行');
 });

