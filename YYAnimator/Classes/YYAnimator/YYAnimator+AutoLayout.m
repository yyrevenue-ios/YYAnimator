//
//  YYAnimator+AutoLayout.m
//  YYAnimator
//
//  Created by yezhicheng on 2023/1/4.
//

#import "YYAnimator+AutoLayout.h"
#import "YYAnimatorQueue.h"
#import "YYKeyframeAnimation.h"
#import "YYAnimationParams.h"

@implementation YYAnimator (AutoLayout)

- (void)addChangeTopConstraintAnimationToQueue:(YYAnimatorQueue *)queue withTop:(CGFloat)top reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.y"];
    
    if (reverse) {
        [self changeTopCompletionWithTop:top reverse:NO];
        top = -top;
    }
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeTop];
    CGFloat topConstant = constraint ? constraint.constant : 0;
    
    positionAnimation.fromValue = @(self.layer.position.y);
    CGFloat offset = reverse ? top + topConstant : top - topConstant;
    positionAnimation.toValue = @(self.layer.position.y + offset);
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeTopCompletionWithTop:(CGFloat)top reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeTop];
    CGFloat topConstant = constraint ? constraint.constant : 0;
    if (reverse) {
        position.y -= (top - topConstant);
    } else {
        position.y += (top - topConstant);
    }
    
    self.layer.position = position;
}

- (void)changeTopConstraint:(CGFloat)top reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:top layoutAttr:NSLayoutAttributeTop isReplace:YES];
    }
}

- (void)addChangeBottomConstraintAnimationToQueue:(YYAnimatorQueue *)queue withBottom:(CGFloat)bottom reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.y"];
    
    if (reverse) {
        [self changeBottomCompletionWithBottom:bottom reverse:NO];
        bottom = -bottom;
    }
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeBottom];
    CGFloat bottomConstant = constraint ? constraint.constant : 0;
    
    positionAnimation.fromValue = @(self.layer.position.y);
    CGFloat offset = reverse ? bottom + bottomConstant : (bottom - bottomConstant);
    positionAnimation.toValue = @(self.layer.position.y + offset);
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeBottomCompletionWithBottom:(CGFloat)bottom reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeBottom];
    CGFloat bottomConstant = constraint ? constraint.constant : 0;
    if (reverse) {
        position.y = position.y - (bottom - bottomConstant);
    } else {
        position.y = position.y + (bottom - bottomConstant);
    }
    
    self.layer.position = position;
}

- (void)changeBottomConstraint:(CGFloat)bottom reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    if(updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:bottom layoutAttr:NSLayoutAttributeBottom isReplace:YES];
    }
}

- (void)addChangeLeftConstraintAnimationToQueue:(YYAnimatorQueue *)queue withLeft:(float)left reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];

    if (reverse) {
        [self changeLeftCompletionWithLeft:left reverse:NO];
        left = -left;
    }

    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeLeft];
    CGFloat leftConstant = constraint ? constraint.constant : 0;
    CGFloat offset = reverse ? left + leftConstant : left - leftConstant;
    positionAnimation.fromValue = @(self.layer.position.x);
    positionAnimation.toValue = @(self.layer.position.x + offset);

    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeLeftCompletionWithLeft:(float)left reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeLeft];
    CGFloat leftConstant = constraint ? constraint.constant : 0;
    if (reverse) {
        position.x -= (left - leftConstant);
    } else {
        position.x += (left - leftConstant);
    }
    self.layer.position = position;
}

- (void)changeLeftConstraint:(float)left reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:left layoutAttr:NSLayoutAttributeLeft isReplace:YES];
    }
}

- (void)addChangeRightConstraintAnimationToQueue:(YYAnimatorQueue *)queue withRight:(float)right reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];

    if (reverse) {
        [self changeRightCompletionWithRight:right reverse:NO];
        right = -right;
    }

    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeRight];
    CGFloat rightConstant = constraint ? constraint.constant : 0;
    
    positionAnimation.fromValue = @(self.layer.position.x);
    CGFloat offset = reverse ? right + rightConstant : (right - rightConstant);
    positionAnimation.toValue = @(self.layer.position.x + offset);

    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeRightCompletionWithRight:(float)right reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeRight];
    CGFloat rightConstant = constraint ? constraint.constant : 0;
    if (reverse) {
        position.x = position.x - (right - rightConstant);
    } else {
        position.x = position.x + (right - rightConstant);
    }
    self.layer.position = position;
}

- (void)changeRightConstraint:(float)right reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:right layoutAttr:NSLayoutAttributeRight isReplace:YES];
    }
}

- (void)addChangeLeadingConstraintAnimationToQueue:(YYAnimatorQueue *)queue withLeading:(float)leading reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];

    if (reverse) {
        [self changeLeadingCompletionWithLeading:leading reverse:NO];
        leading = -leading;
    }

    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeLeading];
    CGFloat leadingConstant = constraint ? constraint.constant : 0;
    CGFloat offset = reverse ? leading + leadingConstant : leading - leadingConstant;
    positionAnimation.fromValue = @(self.layer.position.x);
    positionAnimation.toValue = @(self.layer.position.x + offset);

    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeLeadingCompletionWithLeading:(float)leading reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeLeading];
    CGFloat leadingConstant = constraint ? constraint.constant : 0;
    if (reverse) {
        position.x -= (leading - leadingConstant);
    } else {
        position.x += (leading - leadingConstant);
    }
    self.layer.position = position;
}

- (void)changeLeadingConstraint:(float)leading reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:leading layoutAttr:NSLayoutAttributeLeading isReplace:YES];
    }
}

- (void)addChangeTrailingConstraintAnimationToQueue:(YYAnimatorQueue *)queue withTrailing:(float)trailing reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];

    if (reverse) {
        [self changeTrailingCompletionWithTrailing:trailing reverse:NO];
        trailing = -trailing;
    }

    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeTrailing];
    CGFloat trailingConstant = constraint ? constraint.constant : 0;
    
    positionAnimation.fromValue = @(self.layer.position.x);
    CGFloat offset = reverse ? (trailing + trailingConstant) : (trailing - trailingConstant);
    positionAnimation.toValue = @(self.layer.position.x + offset);

    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeTrailingCompletionWithTrailing:(float)trailing reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeTrailing];
    CGFloat trailingConstant = constraint ? constraint.constant : 0;
    if (reverse) {
        position.x = position.x - (trailing - trailingConstant);
    } else {
        position.x = position.x + (trailing - trailingConstant);
    }
    self.layer.position = position;
}

- (void)changeTrailingConstraint:(float)trailing reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:trailing layoutAttr:NSLayoutAttributeTrailing isReplace:YES];
    }
}

- (void)changeHeightConstraint:(CGFloat)height reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    [self updateAnimationAnchor:YYAnimationAnchorCenter immediately:YES];
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:height layoutAttr:NSLayoutAttributeHeight isReplace:YES];
    }
}

- (void)changeWidthConstraint:(CGFloat)width reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    [self updateAnimationAnchor:YYAnimationAnchorCenter immediately:YES];
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:width layoutAttr:NSLayoutAttributeWidth isReplace:YES];
    }
}

- (void)addChangeCenterXConstraintAnimationToQueue:(YYAnimatorQueue *)queue withCenterX:(CGFloat)centerX reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
    
    CGPoint newPosition = [self newPositionFromNewCenter:CGPointMake(centerX, self.layer.position.y)];
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeCenterX];
    CGFloat centerXConstant = constraint ? constraint.constant : 0;
    CGFloat offset = (centerX - centerXConstant);
    if (reverse) {
        self.layer.position = CGPointMake(self.layer.position.x+offset, self.layer.position.y);
    }
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x + (reverse ? -offset : offset), newPosition.y)];
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeCenterXCompletionWithCenterX:(CGFloat)centerX reverse:(BOOL)reverse
{
    if (reverse) {
        self.layer.position = [self newPositionFromNewOrigin:CGPointMake(self.originalRect.origin.x, self.originalRect.origin.y)];
    } else {
        NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeCenterX];
        CGFloat centerXConstant = constraint ? constraint.constant : 0;
        self.layer.position = CGPointMake(self.layer.position.x + (centerX - centerXConstant), self.layer.position.y);
    }
}

- (void)changeCenterXConstraint:(CGFloat)centerX reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:centerX layoutAttr:NSLayoutAttributeCenterX isReplace:YES];
    }
}

- (void)addChangeCenterYConstraintAnimationToQueue:(YYAnimatorQueue *)queue withCenterY:(CGFloat)centerY reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
    
    CGPoint newPosition = [self newPositionFromNewCenter:CGPointMake(self.layer.position.x, centerY)];
    NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeCenterY];
    CGFloat centerYConstant = constraint ? constraint.constant : 0;
    CGFloat offset = (centerY - centerYConstant);
    if (reverse) {
        self.layer.position = CGPointMake(self.layer.position.x, self.layer.position.y+offset);
    }
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(newPosition.x, self.layer.position.y + (reverse ? -offset : offset))];
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)changeCenterYCompletionWithCenterY:(CGFloat)centerY reverse:(BOOL)reverse
{
    if (reverse) {
        self.layer.position = [self newPositionFromNewOrigin:CGPointMake(self.originalRect.origin.x, self.originalRect.origin.y)];
    } else {
        NSLayoutConstraint *constraint =  [self getConstraintWithLayoutAttr:NSLayoutAttributeCenterY];
        CGFloat centerYConstant = constraint ? constraint.constant : 0;
        self.layer.position = CGPointMake(self.layer.position.x, self.layer.position.y + (centerY - centerYConstant));
    }
}

- (void)changeCenterYConstraint:(CGFloat)centerY reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;
{
    if (updateLayout && !reverse) {
        [self updateLayoutConstraintWithValue:centerY layoutAttr:NSLayoutAttributeCenterY isReplace:YES];
    }
}

- (void)updateLayoutConstraintWithValue:(CGFloat)value layoutAttr:(NSLayoutAttribute)layoutAttr isReplace:(BOOL)isReplace
{
    NSLayoutConstraint *constraint = [self getConstraintWithLayoutAttr:layoutAttr];
    if (constraint) {
        if (isReplace) {
            constraint.constant = value;
        } else {
            constraint.constant += value;
        }
    }
}

- (NSLayoutConstraint *)getConstraintWithLayoutAttr:(NSLayoutAttribute)layoutAttr
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint  *existingConstraint in [self.view.superview constraints]) {
        if (existingConstraint.firstItem == self.view) {
            [array addObject:existingConstraint];
        }
    }
    [array addObjectsFromArray:[self.view constraints]];
    if (array.count) {
        for (NSLayoutConstraint  *existingConstraint in array) {
            if (existingConstraint.firstAttribute == layoutAttr) {
                return existingConstraint;
            }
        }
    }
    
    return nil;
}


@end
