//
//  YYAnimator+Tween.h
//  YYAnimator
//
//  Created by LinSean on 2022/6/11.
//

#import "YYAnimator.h"
#import "YYAnimationParams.h"
#import "YYAnimatorProtocol.h"
#import "YYAnimator+AnimationOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYAnimator (Tween) <YYAnimatorProtocol>

- (void)updateCurrentAnimationDuration:(NSTimeInterval)duration;
- (void)updateCurrentAnimationDelay:(NSTimeInterval)duration;
- (void)updateCurrentAnimationIsReverse:(BOOL)reverse;

- (void)createOneAnimationWithDuration:(NSTimeInterval)duration;
- (void)createNewGroup;

- (void)addAnimationWithParams:(YYAnimationParams *)params;

- (void)play;

@end

NS_ASSUME_NONNULL_END
