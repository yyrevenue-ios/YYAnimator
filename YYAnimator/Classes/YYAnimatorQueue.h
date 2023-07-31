//
//  YYAnimatorQueue.h
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import <Foundation/Foundation.h>
#import "YYAnimatorGroup.h"

NS_ASSUME_NONNULL_BEGIN

@class YYAnimator, YYKeyframeAnimation;

typedef void (^YYAnimatorQueueCompleteBlock)(void);

@interface YYAnimatorQueue : NSObject

@property (nonatomic, weak) YYAnimator *animator;
@property (nonatomic, copy) YYAnimatorQueueCompleteBlock completeBlock;
@property (nonatomic, copy, readonly) NSString *animationKey;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)queueWithAnimator:(YYAnimator *)animator;
- (instancetype)initWithAnimator:(YYAnimator *)animator NS_DESIGNATED_INITIALIZER;

- (void)addAnimation:(YYKeyframeAnimation *)animation;

- (void)updateCurrentTurnGroupAnimationsDuration:(NSTimeInterval)duration;

- (void)addAnimationFunctionBlock:(YYKeyframeAnimationFunctionBlock)functionBlock;

- (void)updateCountingNumberParams:(YYCountingNumberParams *)params;

// 当前动画组，用于动画组合
- (void)addAnimationAssembleAction:(YYAnimationAssembleAction)action;

- (void)addAnimationCompletionAction:(YYAnimationCompletionAction)action;

- (void)addAnimationConstraintAction:(YYAnimationCompletionAction)action;

- (void)updateAnchorWithAction:(YYAnimationAssembleAction)action;

- (void)animateWithAnimationKey:(NSString *)animationKey;
- (void)executeCompletionActions;
- (void)executeConstraintActionsReverse:(BOOL)reverse;
- (BOOL)isEmptiedAfterTryToRemoveCurrentTurnGroup;

// 动画时间控制
- (void)thenAfter:(NSTimeInterval)time;
- (void)createNewGroup;

- (void)repeat:(NSInteger)count andIsAnimation:(BOOL)isAnimation;

- (void)updateCurrentTurnGroupAnimationsDelay:(NSTimeInterval)delay;
- (void)updateCurrentTurnGroupIsReverse:(BOOL)reverse;
- (BOOL)isCurrentTurnGroupReverse;

- (void)updateCurrentPreGroupAnimationBlock:(YYAnimatorGroupBlock)block;

- (void)updateCurrentPostGroupAnimationBlock:(YYAnimatorGroupBlock)block;

- (void)updateCurrentGroupSpringDamping:(CGFloat)dampingRatio initialVelocity:(CGFloat)initialVelocity options:(UIViewAnimationOptions)options;

- (BOOL)shouldRemoveOnCompletion;

@end

NS_ASSUME_NONNULL_END
