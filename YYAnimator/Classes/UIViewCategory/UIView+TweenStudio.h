//
//  UIView+TweenStudio.h
//  YYAnimator
//
//  Created by LinSean on 2022/6/11.
//

#import <UIKit/UIKit.h>
#import "YYAnimator+Tween.h"
#import "YYAnimationParams.h"

typedef NSString * YYAnimatorParamKey NS_TYPED_EXTENSIBLE_ENUM;

/// 水平位移
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAMoveX;
/// 垂直位移
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAMoveY;
/// 水平&垂直位移
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAMoveXY;
/// originX - 目标x
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAOriginX;
/// originY - 目标y
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAOriginY;
/// origin
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAOrigin;
/// size
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYASize;
/// center
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYACenter;
/// customizedData
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYACustomizedData;
/// frame - 为支持动画的平滑移动，frame的origin会根据size进行调整
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAFrame;
/// 旋转角度
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYARotateAngle;
/// 透明度
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAAlpha;
/// 放大倍数
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAScale;
/// 重复次数
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYARepeat;
/// 延迟执行时间
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYADelay;
/// 增加或减少宽度
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAAdjustWidth;
/// 目标宽度
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAWidth;
/// 目标高度
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAHeight;
/// 增加或减少高度
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAAdjustHeight;
/// 弹性Damping
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYASpringDamping;
/// 弹性Velocity
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYASpringVelocity;
/// 弹性Options
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYASpringOptions;
/// 动画开始前回调
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAPreAnimationBlock;
/// 动画结束后回调
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAPostAnimationBlock;
/// 动画过程控制
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAAnimationOption;
// 顶部约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYATopConstraint;
/// 底部约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYABottomConstraint;
/// 左约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYALeftConstraint;
/// 右约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYARightConstraint;
/// 前约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYALeadingConstraint;
/// 后约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYATrailingConstraint;
/// 宽度约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAWidthConstraint;
/// 高度约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAHeightConstraint;
/// centerX约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYACenterXConstraint;
/// centerY约束
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYACenterYConstraint;
/// 锚点位置
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYAAnchor;
/// 数字动画对象
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYACountingNumberData;

/// 数字动画目标value
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYACountingNumberValue;

/// 贝塞尔曲线
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYABezier;
UIKIT_EXTERN YYAnimatorParamKey const _Nonnull YYABezierOption;

#define YYAPoint(x,y) [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define YYASize(w,h) [NSValue valueWithCGSize:CGSizeMake(w, h)]
#define YYARect(x,y,w,h) [NSValue valueWithCGRect:CGRectMake(x, y, w, h)]

NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nullable(^YYTweenAnimatorBlock)(NSTimeInterval duration, NSDictionary<YYAnimatorParamKey, id> *);
typedef UIView *_Nullable(^YYTweenDelayAnimatorBlock)(NSTimeInterval duration, NSTimeInterval delay, NSDictionary<YYAnimatorParamKey, id> *);

@interface UIView (TweenStudio)

@property (nonatomic, copy, readonly) YYTweenAnimatorBlock yya_to NS_SWIFT_UNAVAILABLE("Swift unavailable");

@property (nonatomic, copy, readonly) YYTweenAnimatorBlock yya_from NS_SWIFT_UNAVAILABLE("Swift unavailable");

@property (nonatomic, copy, readonly) YYTweenAnimatorBlock yya_add
    NS_SWIFT_UNAVAILABLE("Swift unavailable");

@property (nonatomic, copy, readonly) YYTweenAnimatorBlock yya_then;
@property (nonatomic, copy, readonly) YYTweenDelayAnimatorBlock yya_thenAfter;

- (void)playAnimations NS_SWIFT_UNAVAILABLE("Swift unavailable");
- (void)removeAnimator;

@end

NS_ASSUME_NONNULL_END
