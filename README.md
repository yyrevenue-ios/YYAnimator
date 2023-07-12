# YYAnimator 矢量动画库

  YYAnimator是使用OC和swift写的简易动画库，为了提升动画的开发效率，能够使用很少的代码来实现动画，且能够让代码更简洁清晰，可读性更高。就如iOS本来提供了Constraint相关接口，但使用Masonry和SnapKit能够帮我们只用关注最关键的几个要素，让代码更简洁易懂并节省开发时间。
 
  YYAnimator主要是构建补间动画，补间动画Flash时代的专业词汇，意思是在起始状态和终点状态之间补全中间过程。现在的动画本质上也是一样的，YYAnimator主要就是参考Flash时代的动画实现。
  
  动画主要包含四个要素：动画目标（target）、起始状态、终点状态、补间时间和效果。动画目标就就是我们需要执行动画的view，view的起始状态我们new或init的时候已经设置了，补间效果默认是匀速运动，所以大多数动画只需要终点状态和动画时长就可以了。
   
  举个例子：我们让一个view在2秒内从当前位置移动到x坐标为200的位置。这里我们有三个要点：**运动时长，运动的类型（x坐标位移），运动的终点(x的终点值）**。对应的代码为：

OC代码
```
view.yya_to(2, @{YYAMoveX: @(200)});
```
Swift代码
```
view.yya.to(2,[.moveX: 200])
```

代码和动画的对应演示效果，我们写了一个预览页面，可以很方便的查看动画和对应代码。大家可以点击这个链接：https://web.yy.com/yyanimatorshow/index.html


要执行多个并行动画，可以在参数里加入多个动画属性，例如在移动X坐标，同时让scale扩大2倍。代码示例：

多个动画OC示例
```
view.yya_to(2, @{YYAMoveX: @(200),YYAScale:@(2)});
```

多个动画Swift示例
```
view.yya.to(2,[.moveX: 200,.scale: 2])
```

上面yya的to动画例子是从view的初始位置，移动到目标位置的代码演示。还有一种动画是将目前view的初始位置作为动画的终点，再设置一个起始位置作为起始点，这个就是from动画，只要代码将yya_to换成yya_from就可以。上面是演示x坐标移动的例子，同理alpha，size，rotation等也一样，只要将YYAMoveX替换成对应动画的常量就可以，都会有代码提示很方便开发。

**串行动画**则可以通过yya_add的方式添加动画，然后调用playAnimations执行。例如让一个view 3秒坐标移动到（120,120）同时旋转120度，然后2秒再缩放2倍，示例代码如下：

串行动画OC:
```
view.yya_add(3, @{YYAMoveXY : [NSValue valueWithCGPoint:CGPointMake(120, 120)], YYARotateAngle : @(120)});
view.yya_add(2, @{YYAScale : @(2)});
[view playAnimations];
```

串行动画Swift
```
animatorView.yya.add(3, [.moveXY : CGPoint(x: 120, y: 120), .rotateAngle : 120])
animatorView.yya.add(2, [.scale : 2])
animatorView.yya.playAnimations()
```

需要在动画执行前或执行后执行代码，可以加入对应的block回调，分别是YYAPreAnimationBlock和YYAPostAnimation。示例代码：
```
view.yya_to(2, @{YYAMoveX: @(200),YYAPostAnimationBlock: ^{
        //这里执行自己的代码
    }});
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YSAnimator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YYAnimator'
```

## Author

8474644, linxiangyu2@yy.com

## License

YYAnimator is available under the MIT license. See the LICENSE file for more info.
