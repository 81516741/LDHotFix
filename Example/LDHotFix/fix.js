//hook 类方法
fixClassMethod
('ProbleClass1','classMethod',
 function(instance, originInvocation, originArguments){
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
