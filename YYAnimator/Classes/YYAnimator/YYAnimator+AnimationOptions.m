//
//  YYAnimator+AnimationOptions.m
//  YYAnimator
//
//  Created by LinSean on 2022/7/11.
//

#import "YYAnimator+AnimationOptions.h"
#import "YYKeyframeAnimationFunctions.h"

@implementation YYAnimator (AnimationOptions)

#pragma mark - 动画过程控制
- (YYAnimator *)easeIn {
    return self.easeInQuad;
}

- (YYAnimator *)easeOut {
    return self.easeOutQuad;
}

- (YYAnimator *)easeInOut {
    return self.easeInOutQuad;
}

- (YYAnimator *)easeBack {
    return self.easeOutBack;
}

- (YYAnimator *)spring {
    return self.easeOutElastic;
}

- (YYAnimator *)bounce {
    return self.easeOutBounce;
}

- (YYAnimator *)easeInQuad {
    [self addAnimationKeyframeFunctionBlock:^double(double t, double b, double c, double d) {
        return YYKeyframeAnimationFunctionEaseIn(t, b, c, d);
    }];
    
    return self;
}

- (YYAnimator *)easeOutQuad {
    [self addAnimationKeyframeFunctionBlock:^double(double t, double b, double c, double d) {
        return YYKeyframeAnimationFunctionEaseOut(t, b, c, d);
    }];
    
    return self;
}

- (YYAnimator *)easeInOutQuad {
    [self addAnimationKeyframeFunctionBlock:^double(double t, double b, double c, double d) {
        return YYKeyframeAnimationFunctionEaseInOut(t, b, c, d);
    }];
    
    return self;
}

- (YYAnimator *)easeOutBack {
    [self addAnimationKeyframeFunctionBlock:^double(double t, double b, double c, double d) {
        return YYKeyframeAnimationFunctionEaseOutBack(t, b, c, d);
    }];
    
    return self;
}

- (YYAnimator *)easeOutElastic {
    [self addAnimationKeyframeFunctionBlock:^double(double t, double b, double c, double d) {
        return YYKeyframeAnimationFunctionEaseOutElastic(t, b, c, d);
    }];
    
    return self;
}

- (YYAnimator *)easeOutBounce {
    [self addAnimationKeyframeFunctionBlock:^double(double t, double b, double c, double d) {
        return YYKeyframeAnimationFunctionEaseOutBounce(t, b, c, d);
    }];
    
    return self;
}

@end
