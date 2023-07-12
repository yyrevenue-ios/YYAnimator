//
//  YYAnimator+AnimationOptions.h
//  YYAnimator
//
//  Created by LinSean on 2022/7/11.
//

#import <YYAnimator/YYAnimator.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYAnimator (AnimationOptions)

#pragma mark - 动画过程控制
- (YYAnimator *)easeIn;
- (YYAnimator *)easeOut;
- (YYAnimator *)easeInOut;
- (YYAnimator *)easeBack;
- (YYAnimator *)spring;
- (YYAnimator *)bounce;

@end

NS_ASSUME_NONNULL_END
