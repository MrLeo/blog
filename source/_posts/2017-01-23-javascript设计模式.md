---
title: javascript设计模式
date: 2017-01-23 16:15:30
updated: 2017-01-23 16:15:30
categories: [前端,javascript]
tags: [前端,javascript,dev]
---

> 本文参考于`《javascript模式》`，因此会大量内容会和书中相同，手上有这本书的朋友可以直接看书。因为我的记忆习惯是抄书，所以我会先抄写下来再发到博客上。

# 单体模式

单体模式思想在于保证一个特定类仅有一个实例，意味着当你第二次使用同一个类创建信对象时，应得到和第一次创建对象完全相同。

## 方法一

```javascript
function Universe(){
    if(typeof Universe.instance==="object"){
        return Universe.instance; //防止被篡改
    }
    this.xx="xx";
    Universe.instance=this;
    return this;
}
var uni=new Universe();
var uni2=new Universe();
uni===uni2; //true
```

> **缺点**
> instance 属性暴露。

## 方法二

使用闭包

```javascript
function Universe(){
    var instance=this; //缓存this
    this.xx="xx";
    Universe=function(){ //重写此构造函数
        return instance; 
    }
}
var uni=new Universe();
var uni2=new Universe();
uni===uni2; //true
```

> **缺点**
> 因为重写了构造函数，constructor 还是指向了老的构造函数,且实例化后在添加原型属性也是不一样的。如下

```javascript
var uni = new Universe();
Universe.prototype.a = 1
var uni2 = new Universe();
console.log(uni === uni2) //true
console.log(uni.a) //undefinded
console.log(uni2.a) //undefinded
console.log(uni.constructor === Universe); //false
```

## 方法三

解决`方法二`问题。

```javascript
function Universe(){
    var instance;
    Universe=function Universe(){
        return instance ;
    }
    Universe.prototype=this; //保存原型属性
    instance=new Universe();
    instance.constructor=Universe;
    instance.xx="xx";
}
```

## 方法四

自运行函数。

```javascript
var Universe;
(function(){
    var instance;
    Universe=function Universe(){
        if(instance){
            return instance;
        }
        instance=this;
        this.xx="xx";
    }
})();
var uni = new Universe();
Universe.prototype.a = 1
var uni2 = new Universe();
console.log(uni === uni2) //true
console.log(uni.a)   //1
console.log(uni2.a)  //1
console.log(uni.constructor === Universe);  //true
```

***

# 工厂模式

工厂模式是为了创建对象。

## 例子

- 公共构造函数 CarMaker
- 名为factory的CarMaker静态方法来创建car对象

```javascript
var corolla=CarMaker.factory('compact');
var solstice=CarMaker.factory('convertible');
var cherokee=CarMaker.factory('suv');
corolla.drive() //I have 4 doors
solstice.drive() //I have 2 doors
cherokee.drive() //I have 6 doors
```

实现

```javascript
function CarMaker() {}
CarMaker.prototype.drive = function() {
    return "I have " + this.doors + " doors";
}
CarMaker.compact = function() {
    this.doors = 4;
}
CarMaker.convertible = function() {
    this.doors = 2
}
CarMaker.suv = function() {
    this.doors = 6;
}
CarMaker.factory = function(type) {
    if (typeof CarMaker[type] !== "function") {
        throw "Error"
    }
    if (typeof CarMaker[type].prototype.drive !== "function") {
        CarMaker[type].prototype = new CarMaker();
    }
    var newCar = new CarMaker[type]();
    return newCar;
}
var corolla = CarMaker.factory('compact');
console.log(corolla.drive()); //I have 4 doors
```

## 内置工厂对象

Object() 构造函数即为内置工厂对象。

***

# 迭代器模式

有一个包含某种数据集合的对象，该数据可能存储在一个复杂数据结构内部，而要提供一个简单方法讷讷感访问到数据结构中没一个元素。

- next() 下一个
- hasNext() 是否有下一个
- reWind() 重置指针
- current() 返回当前

```javascript
var agg = (function() {
    var index = 0;
    var data = [1, 2, 3, 4, 5, 6];
    var length = data.length;
    return {
        next: function() { //这里是从第一个数据开始输出 本例中为 1
            if (!this.hasNext()) {
                return null;
            }
            var element = data[index];
            index++;
            return element;
        },
        hasNext: function() {
            return index < length;
        },
        reWind: function() {
            index = 0;
        },
        current: function() {
            return data[index];
        }
    }
})();
while (agg.hasNext()) {
    console.log(agg.next()); //1,2,3,4,5,6
}
agg.reWind();  //此时重置指针到0
```

***

# 装饰者模式

可以在运行时候添加附加功能到对象中，他的一个方便特征在于其预期行为的可定制和可配置特性。

**例子** 假设在开发一个销售商品的Web应用，每一笔信销售都是一个人新的 sale 对象。该对象“知道”有关项目的价格，并可以通过 getPrice() 方法返回加个。

根据不同情况，可以用额外的功能装饰此对象。

假设客户在魁北克省，买房需要支付联邦税和魁北克省税，则此时需要调用联邦税装饰者和魁北克省税装饰者。

```javascript
var sale=new Sale(100);
sale=sale.decorate("fedtax"); //联邦税
sale=sale.decorate("quebec"); //魁北克省税
sale=sale.decorate("miney"); //转为美元格式
sale.getPrice(); //返回价格
```

并且装饰是可选的，例如不再魁北克省有可能没有省税。

## 方法一

```javascript
function Sale(price) {
    this.price = price;
}
Sale.prototype.getPrice = function() {
    return this.price;
};
Sale.decorators = {}; //储存装饰者的对象
//装饰者
Sale.decorators.fedtax = {
    getPrice: function() {
        var price = this.uber.getPrice();
        return price * 0.8; //对price进行处理
    },
}
Sale.decorators.quebec = {
    getPrice: function() {
        var price = this.uber.getPrice();
        return price * 0.7; //对price进行处理
    },
}
Sale.decorators.money = {
    getPrice: function() {
        var price = this.uber.getPrice();
        return "$" + price * 0.9; //对price进行处理
    },
}
/*decorate() 方法
调用装饰者方法 sale.=sale.decorate("fedtax");
fedtax字符串对应 Sale.decorators中的对象属性。新装饰对象 newobj 将继承目前我们所拥有的对象，这就是ixiangthis
为了完成继承部分代码，此时需要一个临时构造函数，先设置 newobj 的 uber 属性，以便于自对象可以访问到父对象。之后从装饰者中
将所有的额外属性复制到新装饰的对象 newobj 中，最后返回 newobj。
*/
Sale.prototype.decorate = function(decorate) {
    var F = function() {};
    var overrides = this.constructor.decorators[decorate]; //获取装饰者对象
    F.prototype = this;
    var newobj = new F();
    newobj.uber = F.prototype;
    for (var key in overrides) {
        if (overrides.hasOwnProperty) { //判断对象是不是自身的
            newobj[key] = overrides[key];
        }
    }
    return newobj;
};
var sale = new Sale(100);
sale = sale.decorate("fedtax"); //联邦税
sale = sale.decorate("quebec"); //魁北克省税
sale = sale.decorate("money"); //转为美元格式
console.log(sale.getPrice()); //$50.4
```

## 方法二

此方法使用列表实现，而且相对来说比较好理解一点。本质就是把装饰者名称保存到一个列表中并且一次调用此列表中的方法。

```javascript
function Sale(price) {
    this.price = price;
    this.decorateList = [];
}
Sale.decorators = {};
Sale.decorators.fedtax = {
    getPrice: function(price) {
        var price = this.uber.getPrice();
        return price * 0.8; //对price进行处理
    },
}
Sale.decorators.quebec = {
    getPrice: function(price) {
        var price = this.uber.getPrice();
        return price * 0.7; //对price进行处理
    },
}
Sale.decorators.money = {
    getPrice: function(price) {
        var price = this.uber.getPrice();
        return "$" + price * 0.9; //对price进行处理
    },
}
Sale.prototype.decorate = function(decorator) {
    this.decorateList.push(decorator);
};
Sale.prototype.getPrice = function() {
    var price = this.price;
    this.decorateList.forEach(function(name) {
        price = Sale.decorators[name].getPrice(price);
    });
    return price;
};
var sale = new Sale(100);
sale = sale.decorate("fedtax"); //联邦税
sale = sale.decorate("quebec"); //魁北克省税
sale = sale.decorate("money"); //转为美元格式
console.log(sale.getPrice()); //$50.4
```

***

# 策略模式

策略模式支持在运行时候选择算法。例如用在表单验证问题上，可以创建一个具有 validate() 方法的验证器对象，无论表单具体类型是什么，该方法都会被调用，并且返回结果或者错误信息。

```javascript
var validator = {
    // 所有可以的验证规则处理类存放的地方，后面会单独定义
    types: {},
    // 验证类型所对应的错误消息
    messages: [],
    // 当然需要使用的验证类型
    config: {},
    // 暴露的公开验证方法
    // 传入的参数是 key => value对
    validate: function (data) {
        var i, msg, type, checker, result_ok;
        // 清空所有的错误信息
        this.messages = [];
        for (i in data) {
            if (data.hasOwnProperty(i)) {
                type = this.config[i];  // 根据key查询是否有存在的验证规则
                checker = this.types[type]; // 获取验证规则的验证类
                if (!type) {
                    continue; // 如果验证规则不存在，则不处理
                }
                if (!checker) { // 如果验证规则类不存在，抛出异常
                    throw {
                        name: "ValidationError",
                        message: "No handler to validate type " + type
                    };
                }
                result_ok = checker.validate(data[i]); // 使用查到到的单个验证类进行验证
                if (!result_ok) {
                    msg = "Invalid value for *" + i + "*, " + checker.instructions;
                    this.messages.push(msg);
                }
            }
        }
        return this.hasErrors();
    },
    // helper
    hasErrors: function () {
        return this.messages.length !== 0;
    }
};
//然后剩下的工作，就是定义types里存放的各种验证类了
// 验证给定的值是否不为空
validator.types.isNonEmpty = {
    validate: function (value) {
        return value !== "";
    },
    instructions: "传入的值不能为空"
};
// 验证给定的值是否是数字
validator.types.isNumber = {
    validate: function (value) {
        return !isNaN(value);
    },
    instructions: "传入的值只能是合法的数字，例如：1, 3.14 or 2010"
};
// 验证给定的值是否只是字母或数字
validator.types.isAlphaNum = {
    validate: function (value) {
        return !/[^a-z0-9]/i.test(value);
    },
    instructions: "传入的值只能保护字母和数字，不能包含特殊字符"
};
//使用的时候，我们首先要定义需要验证的数据集合，然后还需要定义每种数据需要验证的规则类型，代码如下：
var data = {
    first_name: "Tom",
    last_name: "Xu",
    age: "unknown",
    username: "TomXu"
};
validator.config = {
    first_name: 'isNonEmpty',
    age: 'isNumber',
    username: 'isAlphaNum'
};
//最后获取验证结果 
validator.validate(data);
if (validator.hasErrors()) {
    console.log(validator.messages.join("\n"));
}
```

> 策略模式定义及例子实现参考与《javascript模式》及 [汤姆大叔的博客](http://www.cnblogs.com/TomXu/archive/2012/03/05/2358552.html)

***

# 外观模式

外观模式即让多个方法一起被调用

例如。 stopPropagation() 和 preventDefault() 兼容性一起调用。

```javascript
var myEvent = {
    stop: function(e) {
        if (typeof e.preventDefault() === "function") {
            e.preventDefault();
        }
        if (typeof e.stopPropagation() === "function") {
            e.stopPropagation();
        }
        //for IE
        if (typeof e.returnValue === "boolean") {
            e.returnValue = false;
        }
        if (typeof e.cancelBubble === "boolean") {
            e.cancelBubble = true;
        }
    },
}
```

***

# 代理模式

在代理模式中，一个对象充当另外一个对象的接口，和外观模式区别是：外观模式是合并调用多个方法。
代理模式是介于对象的客户端和对象本身之间，并且对该对象的访问进行保护。

## 包裹例子

现在有个包裹，卖家要把这个包裹寄给gary，则需要通过快递公司寄过来，此时快递公司就是一个 `proxy`

```javascript
var package = function(receiver) {
    this.receiver = receiver;
}
var seller = function(package) {
    this.package = package;
    this.send = function(gift) {
        return package.receiver + "你的包裹:" + gift;
    }
}
var express = function(package) {
    this.package = package;
    this.send = function(packageName) {
        return new seller(package).send(packageName);
    }
}
//调用
var ems = new express(new package("gary"));
console.log(ems.send("键盘")); //gary你的包裹:键盘
```

## 论坛权限管理例子

本例子参考与 [大熊君](http://www.tuicool.com/articles/eyqeUjn)

- 权限列表
- 发帖 1
- 帖子审核 2
- 删帖 3
- 留言、回复 4

|用户|代码|权限|
|--|--|--|--|
|注册用户|001|1 4|
|论坛管理员|002|2 3 4|
|系统管理员|003|1 2 3 4|
|游客|000|null|

**用户类**

```javascript
function User(name, code) {
    this.name = name;
    this.code = code;
}
User.prototype.getName = function() {
    return this.name;
};
User.prototype.getCode = function() {
    return this.code;
};
User.prototype.post = function() {
    //发帖功能
};
User.prototype.remove = function() {
    // 删帖功能
};
User.prototype.check = function() {
    //审核
};
User.prototype.comment = function() {
    //留言回复
};
```

**论坛类**

```javascript
function Forum(user) {
    this.user=user;
}
Forum.prototype.getUser = function () {
    return this.user;
};
Forum.prototype.post = function () {
    var code=this.user.getCode();
    if(code=="001"||code=="003"){
        return this.user.post();
    }else{
        return false;
    }
};
Forum.prototype.remove = function () {
    var code=this.user.getCode();
    if(code=="002"||code=="003"){
        return this.user.remove();
    }else{
        return false;
    }
};
Forum.prototype.check = function () {
    var code=this.user.getCode();
    if(code=="002"||code=="003"){
        return this.user.check();
    }else{
        return false;
    }
};
Forum.prototype.comment = function () {
    var code=this.user.getCode();
    if(code=="001"||code=="002"||code=="003"){
        return this.user.comment();
    }else{
        return false;
    }
};
```

**运行**

```javascript
new Forum(new User("administartor","003"));
```

***

# 中介者模式

中介者模式可以让多个对象之间松耦合，并降低维护成本

例如：游戏程序，两名玩家分别给与半分钟时间来竞争决出胜负（谁按键的次数多胜出，这里玩家1按1，玩家2按0）

- 计分板（scoreboard)
- 中介者 （mediator)

中介者知道所有其他对象的信息。他与输入设备（此时是键盘）进行通信并处理键盘上的按键时间，之后还将消息通知玩家。玩家玩游戏同时（每一分都更新自己分数）还要通知中介者他所做的事情。中介者将更新后的分数传达给计分板。

除了中介者莫有对象知道其他对象。

**图示**

![](http://oj7lzlt0w.bkt.clouddn.com/mediatorpattern.jpg)

```javascript
function Player(name) {
    this.points = 0;
    this.name = name;
}
Player.prototype.play = function() {
    this.points += 1;
    mediator.played();
};
var scoreboard = {
    element: "这里是获取的element用于展示分数",
    update: function(score) { //更新分数
        var msg;
        for (var key in score) {
            if (score.hasOwnProperty(key)) {
                msg += score[key];
            }
        }
        this.element.innerText = msg;
    },
}
var mediator = {
    players: {}, //玩家对象
    setup: function() {
        var players = this.players;
        players.home = new Player("home");
        players.guest = new Player('guest');
    },
    played: function() {
        var players = this.players;
        var score = {
            home: players.home.points,
            guest: players.guest.points
        }
    },
    keypress: function(e) {
        e = e || window.event;
        if (e.which === 49) { //or keycode   对应按键 1
            mediator.players.home.play();
            return;
        }
        if (e.which === 48) { // 对应按键 0
            mediator.player.guest.play();
            return;
        }
    },
}
//运行
mediator.setup();
window.onkeypress = mediator.keypress;
setTimeout(function() { //设置30秒游戏时间
    window.onkeypress = null;
    alert("game end");
}, 30000);
```

***

# 观察者模式

观察者模式在 javascript 中使用非常广泛。所有的浏览器时间就是该模式的实现，node.js中的events也是此模式实现。

此模式另一个名称是 `订阅/发布模式`。

设计这种模式原因是促进形成松散耦合，在这种模式中，并不是一个对象调用另一个对象的方法，而是一个对象订阅另一个对象的特定活动并在状态改编后获得通知。订阅者因此也成为观察者，而被观察的对象成为发布者或者主题。当发生了一个重要事件时候发布者会通知（调用）所有订阅者并且可能经常已事件对象的形式传递消息。

参考：[nodejs的EventEmitter](http://garychang.cn/2016/12/15/nodejsEventEmitter/)

***

# 小结

1. 单体模式
    > 针对一个类仅创建一个对象。

1. 工厂模式
    > 根据字符串制定类型在运行时创建对象的方法。

1. 迭代器模式
    > 提供一个API来遍历或者操作复杂的自定义数据结构。

1. 装饰者模式
    > 通过从预定义装饰者对象中添加功能，从而在运行时侯调整对象

1. 策略模式
    > 在悬在最佳策略以处理特定任务的时候仍然保持相同的接口。

1. 外观模式
    > 通过把常用方法包装到一个新方法中，从来提供一个更为便利的API。

1. 代理模式
    > 通过包装一个对象从而控制对它的访问，其中主要方法是将方位聚集为租或者仅当真正必要时侯才执行访问，从未避免高昂的操作开销。

1. 终结者模式
    > 通过是你的对象之间相互不直接“通话”，而是通过一个中介者对子昂进行通信，从而形成松散耦合。

1. 观察者模式
    > 通过创建“可观察”的对象，当发生一个感兴趣的事件时可将改时间通告给所有观察者从而形成松散耦合。




[参考]: http://garychang.cn/2017/01/14/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/#单体模式 "单体模式"