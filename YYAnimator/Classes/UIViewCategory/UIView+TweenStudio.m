//
//  UIView+TweenStudio.m
//  YYAnimator
//
//  Created by LinSean on 2022/6/11.
//

#import "UIView+TweenStudio.h"
#import <objc/runtime.h>
#import "YYAnimator.h"


YYAnimatorParamKey const YYAMoveX = @"moveX";
YYAnimatorParamKey const YYAMoveY = @"moveY";
YYAnimatorParamKey const YYAMoveXY = @"moveXY";
YYAnimatorParamKey const YYAOriginX = @"originX";
YYAnimatorParamKey const YYAOriginY = @"originY";
YYAnimatorParamKey const YYAOrigin = @"origin";
YYAnimatorParamKey const YYASize= @"size";
YYAnimatorParamKey const YYACenter = @"center";
YYAnimatorParamKey const YYACustomizedData = @"customizedData";
YYAnimatorParamKey const YYAFrame = @"frame";
YYAnimatorParamKey const YYARotateAngle = @"rotateAngle";
YYAnimatorParamKey const YYAAlpha = @"alpha";
YYAnimatorParamKey const YYAScale = @"scale";
YYAnimatorParamKey const YYARepeat = @"repeat";
YYAnimatorParamKey const YYADelay = @"delay";
YYAnimatorParamKey const YYAAdjustWidth = @"adjustWidth";
YYAnimatorParamKey const YYAWidth = @"width";
YYAnimatorParamKey const YYAHeight = @"height";
YYAnimatorParamKey const YYAAdjustHeight = @"adjustHeight";
YYAnimatorParamKey const YYASpringDamping = @"damping";
YYAnimatorParamKey const YYASpringVelocity = @"velocity";
YYAnimatorParamKey const YYASpringOptions = @"springOptions";
YYAnimatorParamKey const YYAPreAnimationBlock = @"preAnimationBlock";
YYAnimatorParamKey const YYAPostAnimationBlock = @"postAnimationBlock";
YYAnimatorParamKey const YYAAnimationOption = @"animationOption";
YYAnimatorParamKey const YYABezier = @"bezier";
YYAnimatorParamKey const YYABezierOption = @"bezierOption";

//auto layout
YYAnimatorParamKey const YYATopConstraint = @"topConstraint";
YYAnimatorParamKey const YYABottomConstraint = @"bottomConstraint";
YYAnimatorParamKey const YYALeftConstraint = @"leftConstraint";
YYAnimatorParamKey const YYARightConstraint = @"rightConstraint";
YYAnimatorParamKey const YYALeadingConstraint = @"leadingConstraint";
YYAnimatorParamKey const YYATrailingConstraint = @"trailingConstraint";
YYAnimatorParamKey const YYAWidthConstraint = @"widthConstraint";
YYAnimatorParamKey const YYAHeightConstraint = @"heightConstraint";
YYAnimatorParamKey const YYACenterXConstraint = @"centerXConstraint";
YYAnimatorParamKey const YYACenterYConstraint = @"centerYConstraint";

// anchor
YYAnimatorParamKey const YYAAnchor = @"anchor";

// 数字动画对象
YYAnimatorParamKey const YYACountingNumberData = @"countingNumberData";

// 数字动画目标value
YYAnimatorParamKey const _Nonnull YYACountingNumberValue = @"countingNumberValue";

@interface UIView (TweenStudio)

@property (nonatomic, assign) BOOL isProducing;

@end

@implementation UIView (TweenStudio)

static const char *kAnimatorTweenStudioMapKey;
static const char *kAnimatorTweenProduceKey;

- (YYAnimator *)tweenAnimator
{
    YYAnimator * animator = objc_getAssociatedObject(self, &kAnimatorTweenStudioMapKey);
    if (!animator) {
        animator = [YYAnimator animatorWithView:self];
        __weak typeof(self) wself = self;
        animator.finalCompeltion = ^ {
            [wself removeAnimator];
        };
        objc_setAssociatedObject(self, &kAnimatorTweenStudioMapKey, animator, OBJC_ASSOCIATION_RETAIN);
    }

    return animator;
}

- (void)removeAnimator
{
    objc_setAssociatedObject(self, &kAnimatorTweenStudioMapKey, nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)setIsProducing:(BOOL)isProducing
{
    objc_setAssociatedObject(self, &kAnimatorTweenProduceKey, @(isProducing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isProducing
{
    return [objc_getAssociatedObject(self, &kAnimatorTweenProduceKey) boolValue];
}


- (YYTweenAnimatorBlock)yya_to
{
    __weak typeof(self) wSelf = self;
    YYTweenAnimatorBlock animator = ^(NSTimeInterval duration, NSDictionary<YYAnimatorParamKey, id> *params) {
        [wSelf.tweenAnimator createOneAnimationWithDuration:duration];
        [wSelf.tweenAnimator updateCurrentAnimationIsReverse:NO];
        [wSelf.tweenAnimator addAnimationWithParams:[wSelf produceAnimationParams:params]];
        [wSelf playAnimations];
        return wSelf;
    };
    return animator;
}

- (YYTweenAnimatorBlock)yya_from
{
    __weak typeof(self) wSelf = self;
    YYTweenAnimatorBlock animator = ^(NSTimeInterval duration, NSDictionary<YYAnimatorParamKey, id> *params) {
        [wSelf.tweenAnimator createOneAnimationWithDuration:duration];
        [wSelf.tweenAnimator updateCurrentAnimationIsReverse:YES];
        [wSelf.tweenAnimator addAnimationWithParams:[wSelf produceAnimationParams:params]];
        [wSelf playAnimations];
        return wSelf;
    };
    return animator;
}

- (YYTweenAnimatorBlock)yya_add
{
    __weak typeof(self) wSelf = self;
    YYTweenAnimatorBlock animator = ^(NSTimeInterval duration, NSDictionary<YYAnimatorParamKey, id> *params) {
        if (wSelf.isProducing) {
            [wSelf.tweenAnimator createNewGroup];
        } else {
            [wSelf.tweenAnimator createOneAnimationWithDuration:duration];
        }
        wSelf.isProducing = YES;
        [wSelf.tweenAnimator updateCurrentAnimationDuration:duration];
        [wSelf.tweenAnimator updateCurrentAnimationIsReverse:NO];
        [wSelf.tweenAnimator addAnimationWithParams:[wSelf produceAnimationParams:params]];
        return wSelf;
    };
    return animator;
}

- (YYTweenAnimatorBlock)yya_then
{
    __weak typeof(self) wSelf = self;
    YYTweenAnimatorBlock animator = ^(NSTimeInterval duration, NSDictionary<YYAnimatorParamKey, id> *params) {
        [wSelf.tweenAnimator createNewGroup];
        [wSelf.tweenAnimator updateCurrentAnimationDuration:duration];
        [wSelf.tweenAnimator updateCurrentAnimationIsReverse:NO];
        [wSelf.tweenAnimator addAnimationWithParams:[wSelf produceAnimationParams:params]];
        return wSelf;
    };
    return animator;
}

- (YYTweenDelayAnimatorBlock)yya_thenAfter
{
    __weak typeof(self) wSelf = self;
    YYTweenDelayAnimatorBlock animator = ^(NSTimeInterval duration, NSTimeInterval delay, NSDictionary<YYAnimatorParamKey, id> *params) {
        [wSelf.tweenAnimator createNewGroup];
        [wSelf.tweenAnimator updateCurrentAnimationDuration:duration];
        [wSelf.tweenAnimator updateCurrentAnimationIsReverse:NO];
        [wSelf.tweenAnimator updateCurrentAnimationDelay:delay];
        [wSelf.tweenAnimator addAnimationWithParams:[wSelf produceAnimationParams:params]];
        return wSelf;
    };
    return animator;
}

- (void)playAnimations
{
    self.isProducing = NO;
    [self.tweenAnimator play];
}


- (YYAnimationParams *)produceAnimationParams:(NSDictionary<YYAnimatorParamKey, id> *)params
{
    YYAnimationParams *newParams = [[YYAnimationParams alloc] init];
    if (params[YYAMoveX]) {
        newParams.moveX = [params[YYAMoveX] floatValue];
    }
    if (params[YYAMoveY]) {
        newParams.moveY = [params[YYAMoveY] floatValue];
    }
    if (params[YYAMoveXY]) {
        id xyPoint = params[YYAMoveXY];
        if ([xyPoint isKindOfClass:NSValue.class]) {
            newParams.moveXY = [xyPoint CGPointValue];
        } else {
            NSAssert(NO,@"point must NSValue class");
        }
    }
    if (params[YYAWidth]) {
        newParams.width = [params[YYAWidth] floatValue];
    }
    if (params[YYAHeight]) {
        newParams.height = [params[YYAHeight] floatValue];
    }
    if (params[YYACenter]) {
        id centerPoint = params[YYACenter];
        if ([centerPoint isKindOfClass:NSValue.class]) {
            newParams.center = [centerPoint CGPointValue];
        } else {
            NSAssert(NO,@"point must NSValue class");
        }
    }
    
    if (params[YYASize]) {
        id size = params[YYASize];
        if ([size isKindOfClass:NSValue.class]) {
            newParams.size = [size CGSizeValue];
        } else {
            NSAssert(NO,@"size must NSValue class");
        }
    }
    
    if (params[YYAOrigin]) {
        id originPoint = params[YYAOrigin];
        if ([originPoint isKindOfClass:NSValue.class]) {
            newParams.origin = [originPoint CGPointValue];
        } else {
            NSAssert(NO,@"point must NSValue class");
        }
    }
    
    if (params[YYAOriginX]) {
        newParams.originX = [params[YYAOriginX] floatValue];
    }
    
    if (params[YYAOriginY]) {
        newParams.originY = [params[YYAOriginY] floatValue];
    }
    
    if (params[YYAFrame]) {
        id frame = params[YYAFrame];
        if ([frame isKindOfClass:NSValue.class]) {
            newParams.frame = [frame CGRectValue];
        } else {
            NSAssert(NO,@"frame must NSValue class");
        }
    }
    
    if (params[YYAAdjustWidth]) {
        newParams.adjustWidth = [params[YYAAdjustWidth] floatValue];
    }
    if (params[YYAAdjustHeight]) {
        newParams.adjustHeight = [params[YYAAdjustHeight] floatValue];
    }
    if (params[YYARotateAngle]) {
        newParams.rotateAngle = [params[YYARotateAngle] floatValue];
    }
    if (params[YYAAlpha]) {
        newParams.alpha = [params[YYAAlpha] floatValue];
    }
    if (params[YYAScale]) {
        newParams.scale = [params[YYAScale] floatValue];
    }
    if (params[YYACustomizedData]) {
        newParams.customizedData = params[YYACustomizedData];
    }
    
    if (params[YYARepeat]) {
        newParams.repeat = [params[YYARepeat] unsignedIntValue];
    }
    if (params[YYADelay]) {
        newParams.delay = [params[YYADelay] doubleValue];
    }
    if (params[YYASpringDamping]) {
        newParams.springDamping = [params[YYASpringDamping] doubleValue];
    }
    if (params[YYASpringVelocity]) {
        newParams.springVelocity = [params[YYASpringVelocity] doubleValue];
    }
    if (params[YYASpringOptions]) {
        newParams.springOptions = [params[YYASpringOptions] integerValue];
    }
    
    if (params[YYAPreAnimationBlock]) {
        newParams.preAnimationBlock = params[YYAPreAnimationBlock];
    }
    if (params[YYAPostAnimationBlock]) {
        newParams.postAnimationBlock = params[YYAPostAnimationBlock];
    }
    if (params[YYAAnimationOption]) {
        newParams.animationOption = (YYAnimationOption)[params[YYAAnimationOption] integerValue];
    }
    if (params[YYATopConstraint]) {
        newParams.topConstraint = [params[YYATopConstraint] floatValue];
    }
    if (params[YYABottomConstraint]) {
        newParams.bottomConstraint = [params[YYABottomConstraint] floatValue];
    }
    if (params[YYALeftConstraint]) {
        newParams.leftConstraint = [params[YYALeftConstraint] floatValue];
    }
    if (params[YYARightConstraint]) {
        newParams.rightConstraint = [params[YYARightConstraint] floatValue];
    }
    if (params[YYALeadingConstraint]) {
        newParams.leadingConstraint = (YYAnimationOption)[params[YYALeadingConstraint] floatValue];
    }
    if (params[YYATrailingConstraint]) {
        newParams.trailingConstraint = (YYAnimationOption)[params[YYATrailingConstraint] floatValue];
    }
    if (params[YYAHeightConstraint]) {
        newParams.heightConstraint = [params[YYAHeightConstraint] floatValue];
        newParams.anchor = YYAnimationAnchorTop;
    }
    if (params[YYAWidthConstraint]) {
        newParams.widthConstraint = [params[YYAWidthConstraint] floatValue];
        newParams.anchor = YYAnimationAnchorLeft;
    }
    
    if(params[YYACenterXConstraint]) {
        newParams.centerXConstraint = [params[YYACenterXConstraint] floatValue];
    }
    
    if(params[YYACenterYConstraint]) {
        newParams.centerYConstraint = [params[YYACenterYConstraint] floatValue];
    }
    
    // anchor
    if (params[YYAAnchor]) {
        newParams.anchor = [params[YYAAnchor] unsignedIntValue];
    }
    
    if (params[YYACountingNumberData]) {
        newParams.countingNumberData = params[YYACountingNumberData];
    }
    
    if (params[YYACountingNumberValue]) {
        newParams.countingNumberValue = [params[YYACountingNumberValue] floatValue];
    }
    
    if (params[YYABezier]) {
        if (!params[YYABezierOption]) {
            if ([params[YYABezier] isKindOfClass:NSArray.class]) {
                NSInteger pathCount = [(NSArray *)params[YYABezier] count] - 1;
                newParams.bezierOption = (pathCount % 3) == 0 ? YYBezierOptionCubic : (pathCount % 2 == 0 ? YYBezierOptionQuad : YYBezierOptionThrough);
            } else {
                newParams.bezierOption = YYBezierOptionQuad;
            }
        } else {
            newParams.bezierOption = (YYBezierOption)[params[YYABezierOption] integerValue];
            if (newParams.bezierOption < YYBezierOptionQuad || newParams.bezierOption > YYBezierOptionThrough) {
                newParams.bezierOption = YYBezierOptionQuad;
            }
        }
        newParams.bezier = [YYAnimationParams bezierFromParam:params[YYABezier] option:newParams.bezierOption];
    }
    return newParams;
}

- (CGPoint)pointFromParam:(id)param
{
    if ([param isKindOfClass:NSValue.class]) {
        return [param CGPointValue];
    } else if ([param isKindOfClass:NSString.class]) {
        NSString *string = param;
        NSArray *arr = [string componentsSeparatedByString:@","];
        return CGPointMake([arr.firstObject floatValue], [arr.lastObject floatValue]);
    }
    return CGPointZero;
}

@end
