//
//  YYAnimationParams.h
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YYAnimationOption) {
    YYAnimationOptionEaseIn = 1,
    YYAnimationOptionEaseOut,
    YYAnimationOptionEaseInOut,
    YYAnimationOptionSpring,
    YYAnimationOptionEaseBack,
    YYAnimationOptionBounce
};

typedef NS_ENUM(NSInteger, YYAnimatorCustomProperty) {
    YYAnimatorCustomPropertyCenter,
    YYAnimatorCustomPropertyWidth,
    YYAnimatorCustomPropertyHeight,
    YYAnimatorCustomPropertYYcale,
    YYAnimatorCustomPropertyAlpha,
    YYAnimatorCustomPropertyOriginX,
    YYAnimatorCustomPropertyOriginY,
    YYAnimatorCustomPropertyRotation,
};

typedef NS_ENUM(NSInteger, YYAnimationAnchor) {
    YYAnimationAnchorCenter,    // Default
    YYAnimationAnchorTop,
    YYAnimationAnchorBottom,
    YYAnimationAnchorLeft,
    YYAnimationAnchorRight,
    YYAnimationAnchorTopLeft,
    YYAnimationAnchorTopRight,
    YYAnimationAnchorBottomLeft,
    YYAnimationAnchorBottomRight
};

@interface YYAnimatorCustomizedData : NSObject
@property (nonatomic, assign) YYAnimatorCustomProperty property;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *keyTimes;
@property (nonatomic, copy, readonly) NSString *keyPath;

- (instancetype)initWithProperty:(YYAnimatorCustomProperty)property values:(NSArray *)values keyTimes:(NSArray *)keyTimes;
@end

@interface YYAnimatorCountingNumberData : NSObject

@property (nonatomic, assign) CGFloat fromValue;
@property (nonatomic, assign) CGFloat toValue;
@property (nonatomic, copy) NSString *(^numberFormatBlock)(double numberValue);

@end

@interface YYAnimationParams : NSObject

// 水平位移
@property (nonatomic, assign) CGFloat moveX;

// 垂直位移
@property (nonatomic, assign) CGFloat moveY;

// 水平&垂直位移
@property (nonatomic, assign) CGPoint moveXY;

// originX
@property (nonatomic, assign) CGFloat originX;

// originY
@property (nonatomic, assign) CGFloat originY;

// origin
@property (nonatomic, assign) CGPoint origin;

// size
@property (nonatomic, assign) CGSize size;

// center
@property (nonatomic, assign) CGPoint center;

// 自定义center
@property (nonatomic, strong) YYAnimatorCustomizedData *customizedData;

// frame - 为支持动画的平滑移动，frame的origin会根据size进行调整
@property (nonatomic, assign) CGRect frame;

// 旋转角度
@property (nonatomic, assign) CGFloat rotateAngle;

// 透明度
@property (nonatomic, assign) CGFloat alpha;

// 放大倍数
@property (nonatomic, assign) CGFloat scale;

// 重复次数
@property (nonatomic, assign) NSUInteger repeat;

// 延迟执行时间
@property (nonatomic, assign) NSTimeInterval delay;

// 增加或减少宽度
@property (nonatomic, assign) CGFloat adjustWidth;

// 宽度
@property (nonatomic, assign) CGFloat width;

// 高度
@property (nonatomic, assign) CGFloat height;

// 增加或减少高度
@property (nonatomic, assign) CGFloat adjustHeight;

// 动画开始前回调
@property (nonatomic, copy) dispatch_block_t preAnimationBlock;

// 动画结束后回调
@property (nonatomic, copy) dispatch_block_t postAnimationBlock;

// 动画过程控制
@property (nonatomic, assign) YYAnimationOption animationOption;

// 弹性damping
@property (nonatomic, assign) CGFloat springDamping;

// 弹性Velocity
@property (nonatomic, assign) CGFloat springVelocity;

// 弹性options
@property (nonatomic, assign) NSUInteger springOptions;

// 顶部约束
@property (nonatomic, assign) CGFloat topConstraint;

// 底部约束
@property (nonatomic, assign) CGFloat bottomConstraint;

// 左约束
@property (nonatomic, assign) CGFloat leftConstraint;

// 右约束
@property (nonatomic, assign) CGFloat rightConstraint;

// 前约束
@property (nonatomic, assign) CGFloat leadingConstraint;

// 后约束
@property (nonatomic, assign) CGFloat trailingConstraint;

// 高度约束
@property (nonatomic, assign) CGFloat heightConstraint;

// 宽度约束
@property (nonatomic, assign) CGFloat widthConstraint;

//centerX约束
@property (nonatomic, assign) CGFloat centerXConstraint;

//centerY约束
@property (nonatomic, assign) CGFloat centerYConstraint;

// 动画锚点
@property (nonatomic, assign) YYAnimationAnchor anchor;

// 数字动画对象
@property (nonatomic, strong) YYAnimatorCountingNumberData *countingNumberData;

// 数字动画值
@property (nonatomic, assign) CGFloat countingNumberValue;

- (BOOL)isMoveXYValid;

- (BOOL)isOriginValid;

- (BOOL)isSizeValid;

- (BOOL)isCenterValid;

- (BOOL)isFrameValid;

@end

NS_ASSUME_NONNULL_END
