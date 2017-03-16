# WHDropDownView
UINavigationController, UIViewController, UITabBarController, every VC can add this View.

>###开门见山，先看效果图

![下拉内容，内容为新闻](http://upload-images.jianshu.io/upload_images/2963444-263805e8982e33e8.gif =375x667)


现在的移动端，用户的**“使用时长”**越来越得到重视。大量的App也使出浑身解数提高用户在自身App的使用时长。
**“内容页”**应用而生，内容页有很多形式，新闻，资讯，热点，微博，都可以充当内容页的主体，在一定程度上提高了用户的使用时长。
如何在现有的客户端UI上完美嵌入内容页，是很多App都在思考的问题。
因为现在大部分App的主体框架是TabBar载体。自然而然想到增加一个Tab。例如百度云，爱奇艺。
![百度云<看吧>](http://upload-images.jianshu.io/upload_images/2963444-19692e50cb0e287f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/310)


个人感觉这种方式不够优雅，于是也趁着hackday，写了一份下**拉内容页**。

---

>###WHDropDownView 动画

说说动画实现和难点吧。UI分为两部分：

1. indicatorView（boomup，waggle）
2. contentView（拖动动画）

####boomup动画

![boomup.gif](http://upload-images.jianshu.io/upload_images/2963444-63a593135d5060d6.gif?imageMogr2/auto-orient/strip)


boomup是3个简单动画叠加的：
- 蓝色半透明底的 **transform.scale** 从 0.0 到1.0

~~~
    self.image = [UIImage imageNamed:@"sparkle.png"];
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView  animateWithDuration:0.25
                           delay:0
          usingSpringWithDamping:1
           initialSpringVelocity:10
                         options:0
                      animations:^{
                          
                          self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                      }
                      completion:^(BOOL finished) {
                          self.image = nil;
                      }];
~~~

- icon 外圈环等角度7个大点和小点

~~~
    [self popOutsideWithDuration];
    
    CGFloat radius  = self.iconImageView.bounds.size.height*1.3/2; // ring radius
    CGFloat igniteFromRadius = radius*0.4;
    CGFloat igniteToRadius   = radius*0.7;
    
    NSArray *sparks = [self createSparks:igniteFromRadius];
    for (TTSpark *spark in sparks) {
        [spark animateIgniteShow:igniteToRadius duration:1.0 delay:0.05];
        [spark animateIgniteHide:0.8 delay:0.2];
    }
~~~

- icon 的 **transform.scale** 从 0.0 到1.0

~~~
    self.iconImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView  animateWithDuration:0.35
                           delay:0.25
          usingSpringWithDamping:1
           initialSpringVelocity:10
                         options:0
                      animations:^{
                          
                          self.iconImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                      }
                      completion:nil];
~~~

代码略多，在此就不粘全了。

出现场景：

- 每次切换到这个VC
- 第一次进入这个VC

####waggle动画

![wanggle.gif](http://upload-images.jianshu.io/upload_images/2963444-18531588aab08992.gif?imageMogr2/auto-orient/strip)

- icon 的3D左翻转 ，3次

~~~
    [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        
        self.iconImageView.image = [UIImage imageNamed:newOne];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
            
            self.iconImageView.image = [UIImage imageNamed:lastOne];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5f delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
                
                self.iconImageView.image = [UIImage imageNamed:newOne];
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }];
~~~

- 整个indicator的Z轴旋转

~~~
    CGFloat fromRotation = 0;
    CGFloat byRotation = 0.06;
    CGFloat toRotation = -0.06;
    
    CAKeyframeAnimation *circleTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    circleTransform.duration = 5;
    circleTransform.repeatCount  = 1;
    circleTransform.autoreverses = NO;
    
    circleTransform.values = @[
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, byRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, toRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, byRotation/2, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, toRotation/2, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, fromRotation, 0.0, 0.0, 1.0)],
                               ];
    
    [self.layer addAnimation:circleTransform forKey:@"shakeAnimation"];
~~~

- 整个indicator的Y轴拉伸

~~~
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    scaleY.values   = @[@1.0, @1.04, @1.01, @1.04, @1.01, @1.04, @1.02, @1.04, @1.01, @1.02, @1.0];
    scaleY.autoreverses = NO;
    scaleY.duration= 5;
    scaleY.repeatCount = 1;
    
    [self.layer addAnimation:scaleY forKey:@"scaleY"];
~~~

出现场景：

- 每隔15秒静止（无下拉等用户操作）就waggle一下
- 下拉内容页隐藏的时候

####拖动动画
下拉回退有两种行为，点击/拖动。分别是用

- UITapGestureRecognizer
- UIPanGestureRecognizer

---
>###WHDropDownView 接入说明

无论是 **UINavigationController, UIViewController, UITabBarController** 都能完美嵌入，界面右上角悬挂绳索饰品，下拉点击就出内容页。

- 接入只需要一句代码，在要展示的 VC 的 viewDidLoad 调用

~~~
//传入UINavigationController, UIViewController, UITabBarController, 的View
- (void)showDropDownViewOn:(UIView *)bottomView;
~~~

- 在你认为合适的时机调用 **boomup** 动画（比如viewDidAppear:）


~~~
//WHDropDownView.h
@interface WHDropDownView : UIView

+ (WHDropDownView *)sharedInstance;
//传入UINavigationController, UIViewController, UITabBarController, 的View
- (void)showDropDownViewOn:(UIView *)bottomView;

- (void)boomup;

@end
~~~

- 下拉内容页 **WHDropDownContentView**，你可以自定义里面cell的样式和填充内容
- icon 图目前使用的本地图，有需求建议改成线上可配
- 3r-party：**Masonry** ，非必需，可以改成任何布局框架，代码也不多

---

