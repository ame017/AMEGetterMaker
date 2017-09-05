# AMEGetterMaker
一个无需resign Xcode的懒加载插件<br>
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/introduce.png?raw=true)



## 版本更新记录
* 1.1.0
  <br>添加支持swift(测试中)
* 1.0.1
  <br>无视关键词 IBOutlet

## 关于本扩展
在写代码的时候,您可能会经常用到懒加载.<br>
不幸的是,苹果并没有提供快速生成懒加载的方法.<br>
安装这个扩展将会解决这个问题.<br>

例如:
```
//无视xib
@property (weak, nonatomic) IBOutlet xibSubView *subView;

//无视注释
@property (nonatomic, strong) UIView * view1;
/**
 多行注释也会过滤
 */
@property (nonatomic, strong) UIView * view2;
//assign属性会被过滤
@property (nonatomic, assign) BOOL hahaha;

@property (nonatomic, copy) NSString * sting;
```
↓↓↓
```
- (UIView *)view1{
    if(!_view1){
        _view1 = ({
            UIView * object = [[UIView alloc]init];
            object;
       });
    }
    return _view1;
}

- (UIView *)view2{
    if(!_view2){
        _view2 = ({
            UIView * object = [[UIView alloc]init];
            object;
       });
    }
    return _view2;
}

- (NSString *)sting{
    if(!_sting){
        _sting = ({
            NSString * object = [[NSString alloc]init];
            object;
       });
    }
    return _sting;
}
```

![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/objc-2.gif?raw=true)

## 在swift中使用
<br>目前支持将var转换成lazy var.

例如:
```
var button : UIButton!
var button1 : UIButton = UIButton()
var button2 = UIButton()
```
↓↓↓
```
lazy var button : UIButton = {
	let object = UIButton()
	return object
}()

lazy var button1 : UIButton = {
	let object = UIButton()
	return object
}()

lazy var button2 : UIButton = {
	let object = UIButton()
	return object
}()
 ```

![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/swift-2.gif?raw=true)

## 安装方法
#### Xcode8.0+
1.下载本项目并在您的Xcode中运行.<br>
2.在系统偏好设置-扩展中打开本插件(如图)<br>
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/setting.png?raw=true)<br>
3.你可以自己设置一个快捷键(推荐shift + G)<br>
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/binding.png?raw=true)<br>

#### Xcode7.0
请使用这个插件(仅支持Objc) -------> [getterMake-Xcode](https://github.com/ame017/getterMake-Xcode)
<br>
<br>

## 一些问题的说明
如果您的Xcode版本是 8.0+.<br>
如果您的macOS是10.11,请安装macOS Sierra (version 10.12)<br>

## 感谢
[hackxhj](https://github.com/hackxhj) 感谢这位大佬的项目给了我很多灵感来制作这个插件
