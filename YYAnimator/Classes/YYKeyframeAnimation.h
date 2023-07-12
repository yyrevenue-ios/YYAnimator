//
//  YYKeyframeAnimation.h
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef double(^YYKeyframeAnimationFunctionBlock)(double t, double b, double c, double d);

@interface YYKeyframeAnimation : CAKeyframeAnimation

@property (nonatomic, copy) YYKeyframeAnimationFunctionBlock functionBlock;

@property (nonatomic, strong) NSArray *customizedValues;
@property (nonatomic, strong) NSArray *customizedKeyTimes;

@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

- (void)calculate;

@end

NS_ASSUME_NONNULL_END
