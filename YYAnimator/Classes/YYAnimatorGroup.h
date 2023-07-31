//
//  YYAnimatorGroup.h
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import <Foundation/Foundation.h>
#import "YYKeyframeAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@class YYAnimator, YYAnimatorQueue;

typedef void (^YYAnimatorGroupBlock)(void);
typedef void (^YYAnimationAssembleAction)(__weak YYAnimator *animator, __weak YYAnimatorQueue *animatorQueue, BOOL reverse);
typedef void (^YYAnimationCompletionAction)(__weak YYAnimator *animator, BOOL reverse);


@interface YYSpringParams : NSObject
@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) CGFloat stiffness;
@property (nonatomic, assign) CGFloat damping;
@property (nonatomic, assign) CGFloat initialVelocity;
@end

@interface YYCountingNumberParams : NSObject

@property (nonatomic, assign) CGFloat fromValue;
@property (nonatomic, assign) CGFloat toValue;
@property (nonatomic, copy) NSString *(^numberFormatBlock)(double numberValue);

@end

@interface YYAnimatorGroup : NSObject <NSCopying>

@property (nonatomic, weak) YYAnimator *animator;
@property (nonatomic, weak) YYAnimatorQueue *animatorQueue;
@property (nonatomic, assign) NSTimeInterval animationDelay;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) BOOL isReverse;
@property (nonatomic, copy) YYAnimatorGroupBlock preGroupBlock;
@property (nonatomic, copy) YYAnimatorGroupBlock postGroupBlock;
@property (nonatomic, copy) YYAnimationAssembleAction anchorAssembleAction;
@property (nonatomic, assign, readonly) BOOL shouldRemoveOnCompletion;

// 弹簧系数
@property (nonatomic, strong) YYSpringParams *springParams;

// 数字动画label格式
@property (nonatomic, strong) YYCountingNumberParams *countingNumberParams;


+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)groupWithAnimator:(YYAnimator *)animator andAnimatorQueue:(YYAnimatorQueue *)animatorQueue;
- (instancetype)initWithAnimator:(YYAnimator *)animator andAnimatorQueue:(YYAnimatorQueue *)animatorQueue NS_DESIGNATED_INITIALIZER;

- (void)addAnimation:(YYKeyframeAnimation *)animation;

- (void)addAnimationFunctionBlock:(YYKeyframeAnimationFunctionBlock)functionBlock;
- (void)addAnimationAssembleAction:(YYAnimationAssembleAction)action;
// 这里的CompletionAction是专门用来在执行完动画之后，对视图的属性进行修改的（是必须的操作），而上面的postGroupBlock,则是给调用者在每个组合动画结束后添加所需执行的逻辑
- (void)addAnimationCompletionAction:(YYAnimationCompletionAction)action;

- (void)animateWithAnimationKey:(NSString *)animationKey;

- (void)executeCompletionActions;
- (void)executePostGroupBlock;

@end

NS_ASSUME_NONNULL_END
