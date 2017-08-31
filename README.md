# AMEGetterMaker
A lazyload getter maker without resign<br>
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/introduce.png?raw=true)



## Version update
* 1.1.0
  <br>Add support for swift(test function)
* 1.0.1
  <br>Ignore IBOutlet

## What is this?
Every time you may use lazyload.However, apple do not provide the method to quickly make getter.
So this plug-in may solve your problem.

e.g.
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

![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/usage.gif?raw=true)

## To use in swift
<br>Now support var to lazy var.

e.g.
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
 
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/swiftIntro.gif?raw=true)

## Installation
#### Xcode8.0+
1.Download the project and run it in Xcode.<br>
2.Enable this plug-in in setting<br>
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/setting.png?raw=true)<br>
3.You can Bind shortcuts in Xcode setting (shift + G)<br>
![](https://github.com/ame017/AMEGetterMaker/blob/master/intro/binding.png?raw=true)<br>

#### Xcode7.0
You can use this plug-in -------> [getterMake-Xcode](https://github.com/ame017/getterMake-Xcode)
<br>
<br>

## Trouble Shooting
If your Xcode is 8.0+.<br>
Please install macOS Sierra (version 10.12) if your macOS is 10.11.<br>

Now swift version not provide.May come soon.<br>

## Special thanks to
[hackxhj](https://github.com/hackxhj) Give me a lot of inspiration to finish this plug-in
