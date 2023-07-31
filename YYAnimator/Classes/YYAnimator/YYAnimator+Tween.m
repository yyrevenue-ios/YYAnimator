//
//  YYAnimator+Tween.m
//  YYAnimator
//
//  Created by LinSean on 2022/6/11.
//

#import "YYAnimator+Tween.h"
#import "YYAnimatorQueue.h"

@implementation YYAnimator (Tween)

- (void)updateCurrentAnimationDuration:(NSTimeInterval)duration
{
    [[self.animatorQueues lastObject] updateCurrentTurnGroupAnimationsDuration:duration];
}

- (void)updateCurrentAnimationDelay:(NSTimeInterval)duration
{
    [[self.animatorQueues lastObject] updateCurrentTurnGroupAnimationsDelay:duration];
}

- (void)updateCurrentAnimationIsReverse:(BOOL)reverse
{
    [[self.animatorQueues lastObject] updateCurrentTurnGroupIsReverse:reverse];
}

- (void)createOneAnimationWithDuration:(NSTimeInterval)duration
{
    YYAnimatorQueue *animatorQueue = [YYAnimatorQueue queueWithAnimator:self];
    [animatorQueue updateCurrentTurnGroupAnimationsDuration:duration];
    [self.animatorQueues addObject:animatorQueue];
}

- (void)createNewGroup
{
    [[self.animatorQueues lastObject] createNewGroup];
}

- (void)addAnimationWithParams:(YYAnimationParams *)params
{
    [self addAnimationAssembleAction:^(__weak YYAnimator *weakSelf, __weak YYAnimatorQueue *animatorQueue, BOOL reverse) {
        [weakSelf _prepareAnimationWithParams:params forQueue:animatorQueue reverse:reverse];
    }];
    [self addAnimationCompletionAction:^(__weak YYAnimator *weakSelf, BOOL reverse) {
        [weakSelf _prepareCompletionWithParams:params reverse:reverse];
    }];
    
    [self addAnimationConstraintAction:^(__weak YYAnimator *weakSelf, BOOL reverse) {
        [weakSelf _prepareConstraintWithParams:params reverse:reverse];
    }];
    
    if (params.anchor > 0) {
        [self updateAnimationAnchor:params.anchor immediately:NO];
    }
    
    if (params.preAnimationBlock) {
        [[self.animatorQueues lastObject] updateCurrentPreGroupAnimationBlock:params.preAnimationBlock];
    }
    if (params.postAnimationBlock) {
        [[self.animatorQueues lastObject] updateCurrentPostGroupAnimationBlock:params.postAnimationBlock];
    }
    if (params.repeat > 0) {
        [[self.animatorQueues lastObject] repeat:params.repeat andIsAnimation:NO];
    }
    if (params.delay > 0) {
        [[self.animatorQueues lastObject] updateCurrentTurnGroupAnimationsDelay:params.delay];
    }
    if (params.springDamping > 0 && params.springVelocity > 0) {
        [[self.animatorQueues lastObject] updateCurrentGroupSpringDamping:params.springDamping initialVelocity:params.springVelocity options:(UIViewAnimationOptions)params.springOptions];
    }
    if (params.countingNumberData) {
        YYCountingNumberParams *numberParams = [[YYCountingNumberParams alloc] init];
        numberParams.toValue = params.countingNumberData.toValue;
        numberParams.fromValue = params.countingNumberData.fromValue;
        numberParams.numberFormatBlock = params.countingNumberData.numberFormatBlock;
        [[self.animatorQueues lastObject] updateCountingNumberParams:numberParams];
    }
    if (params.animationOption > 0) {
        [self _addAnimationOption:params.animationOption];
    }
}

- (void)_prepareAnimationWithParams:(YYAnimationParams *)params forQueue:(YYAnimatorQueue *)animatorQueue reverse:(BOOL)reverse
{
    if (params.moveX != 0) {
        [self addMoveXAnimationToQueue:animatorQueue withX:params.moveX reverse:reverse];
    }
    
    if (params.moveY != 0) {
        [self addMoveYAnimationToQueue:animatorQueue withY:params.moveY reverse:reverse];
    }
    
    if ([params isMoveXYValid]) {
        [self addMoveXYAnimationToQueue:animatorQueue withPoint:params.moveXY reverse:reverse];
    }
    
    if (params.originX != CGFLOAT_MAX) {
        [self addOriginXAnimationToQueue:animatorQueue withX:params.originX reverse:reverse];
    }
    
    if (params.originY != CGFLOAT_MAX) {
        [self addOriginYAnimationToQueue:animatorQueue WithY:params.originY reverse:reverse];
    }
    
    if ([params isOriginValid]) {
        [self addOriginAnimationToQueue:animatorQueue withPoint:params.origin reverse:reverse];
    }
    
    if ([params isSizeValid]) {
        [self addSizeAnimationToQueue:animatorQueue withSize:params.size reverse:reverse];
    }
    
    if ([params isCenterValid]) {
        [self addCenterAnimationToQueue:animatorQueue withPoint:params.center reverse:reverse];
    }
    
    if (params.customizedData) {
        [self addCustomizedPropertyAnimationToQueue:animatorQueue withCustomData:params.customizedData];
    }
    
    if ([params isFrameValid]) {
        [self addFrameAnimationToQueue:animatorQueue withFrame:params.frame reverse:reverse];
    }
    
    if (params.adjustWidth != 0) {
        [self addAdjustWidthAnimationToQueue:animatorQueue withWidth:params.adjustWidth reverse:reverse];
    }
    
    if (params.width > 0) {
        [self addChangeWidthAnimationToQueue:animatorQueue withWidth:params.width reverse:reverse];
    }
    
    if (params.height > 0) {
        [self addChangeHeightAnimationToQueue:animatorQueue withHeight:params.height reverse:reverse];
    }
    
    if (params.adjustHeight != 0) {
        [self addAdjustHeightAnimationToQueue:animatorQueue withHeight:params.adjustHeight reverse:reverse];
    }
    
    if (params.rotateAngle != 0) {
        [self addRotationZAnimationToQueue:animatorQueue withAngle:params.rotateAngle reverse:reverse];
    }
    
    if (params.alpha >= 0) {
        [self addAlphaAnimationToQueue:animatorQueue withAlpha:params.alpha reverse:reverse];
    }
    
    if (params.scale >= 0) {
        [self addScaleAnimationToQueue:animatorQueue withScale:params.scale reverse:reverse];
    }
    
    if (params.widthConstraint > 0) {
        [self addChangeWidthAnimationToQueue:animatorQueue withWidth:params.widthConstraint reverse:reverse];
    }
    
    if (params.heightConstraint > 0) {
        [self addChangeHeightAnimationToQueue:animatorQueue withHeight:params.heightConstraint reverse:reverse];
    }
    
    if (params.topConstraint != CGFLOAT_MAX) {
        [self addChangeTopConstraintAnimationToQueue:animatorQueue withTop:params.topConstraint reverse:reverse];
    }
    
    if (params.bottomConstraint != CGFLOAT_MAX) {
        [self addChangeBottomConstraintAnimationToQueue:animatorQueue withBottom:params.bottomConstraint reverse:reverse];
    }
    
    if (params.leftConstraint != CGFLOAT_MAX) {
        [self addChangeLeftConstraintAnimationToQueue:animatorQueue withLeft:params.leftConstraint reverse:reverse];
    }
    
    if (params.rightConstraint != CGFLOAT_MAX) {
        [self addChangeRightConstraintAnimationToQueue:animatorQueue withRight:params.rightConstraint reverse:reverse];
    }

    if (params.leadingConstraint != CGFLOAT_MAX) {
        [self addChangeLeadingConstraintAnimationToQueue:animatorQueue withLeading:params.leadingConstraint reverse:reverse];
    }
    
    if (params.trailingConstraint != CGFLOAT_MAX) {
        [self addChangeTrailingConstraintAnimationToQueue:animatorQueue withTrailing:params.trailingConstraint reverse:reverse];
    }
    
    if (params.centerXConstraint != CGFLOAT_MAX) {
        [self addChangeCenterXConstraintAnimationToQueue:animatorQueue withCenterX:params.centerXConstraint reverse:reverse];
    }
    
    if (params.centerYConstraint != CGFLOAT_MAX) {
        [self addChangeCenterYConstraintAnimationToQueue:animatorQueue withCenterY:params.centerYConstraint reverse:reverse];
    }
    
    if (params.countingNumberData) {
        [self addCountingNumberAnimationToQueue:animatorQueue withCountingNumberData:params.countingNumberData];
    }
    
    if (params.countingNumberValue != CGFLOAT_MAX) {
        [self addCountingNumberAnimationToQueue:animatorQueue withValue:params.countingNumberValue reverse:reverse];
    }
    
    if (params.bezier) {
        [self addBezierPathAnimationToQueue:animatorQueue withPath:params.bezier reverse:reverse];
    }
}

- (void)_prepareCompletionWithParams:(YYAnimationParams *)params reverse:(BOOL)reverse
{
    if (params.moveX != 0) {
        [self moveXAnimationCompletionWithX:params.moveX reverse:reverse];
    }
    
    if (params.moveY != 0) {
        [self moveYAnimationCompletionWithY:params.moveY reverse:reverse];
    }
    
    if ([params isMoveXYValid]) {
        [self moveXYAnimationCompletionWithPoint:params.moveXY reverse:reverse];
    }
    
    if (params.originX != CGFLOAT_MAX) {
        [self originXAnimationCompletionWithX:params.originX reverse:reverse];
    }
    
    if (params.originY != CGFLOAT_MAX) {
        [self originYAnimationCompletionWithY:params.originY reverse:reverse];
    }
    
    if ([params isOriginValid]) {
        [self originAnimationCompletionWithPoint:params.origin reverse:reverse];
    }
    
    if ([params isSizeValid]) {
        [self sizeAnimationCompletionWithSize:params.size reverse:reverse];
    }
    
    if ([params isCenterValid]) {
        [self centerAnimationCompletionWithPoint:params.center reverse:reverse];
    }
    
    if ([params isFrameValid]) {
        [self frameAnimationCompletionWithFrame:params.frame reverse:reverse];
    }
    
    if (params.width > 0) {
        [self changeWidthAnimationCompletionWithWidth:params.width reverse:reverse];
    }
    
    if (params.height > 0) {
        [self changeHeightAnimationCompletionWithHeight:params.height reverse:reverse];
    }
    
    if (params.adjustWidth != 0) {
        [self adjustWidthAnimationCompletionWithWidth:params.adjustWidth reverse:reverse];
    }
    
    if (params.adjustHeight != 0) {
        [self adjustHeightAnimationCompletionWithHeight:params.adjustHeight reverse:reverse];
    }
    
    if (params.rotateAngle != 0) {
        [self rotationZAnimationWithAngle:params.rotateAngle reverse:reverse];
    }
    
    if (params.alpha >= 0) {
        [self alphaAnimationCompletionWithAlpha:params.alpha reverse:reverse];
    }
    
    if (params.scale >= 0) {
        [self scaleAnimationCompletionWithScale:params.scale reverse:reverse];
    }
    
    if (params.widthConstraint > 0) {
        [self changeWidthAnimationCompletionWithWidth:params.widthConstraint reverse:reverse];
    }
    
    if (params.heightConstraint > 0) {
        [self changeHeightAnimationCompletionWithHeight:params.heightConstraint reverse:reverse];
    }
    
    if (params.topConstraint != CGFLOAT_MAX) {
        [self changeTopCompletionWithTop:params.topConstraint reverse:reverse];
    }
    
    if (params.bottomConstraint != CGFLOAT_MAX) {
        [self changeBottomCompletionWithBottom:params.bottomConstraint reverse:reverse];
    }
    
    if (params.leftConstraint != CGFLOAT_MAX) {
        [self changeLeftCompletionWithLeft:params.leftConstraint reverse:reverse];
    }
    
    if (params.rightConstraint != CGFLOAT_MAX) {
        [self changeRightCompletionWithRight:params.rightConstraint reverse:reverse];
    }
    
    if (params.leadingConstraint != CGFLOAT_MAX) {
        [self changeLeadingCompletionWithLeading:params.leadingConstraint reverse:reverse];
    }
    
    if (params.trailingConstraint != CGFLOAT_MAX) {
        [self changeTrailingCompletionWithTrailing:params.trailingConstraint reverse:reverse];
    }
    
    if (params.centerXConstraint != CGFLOAT_MAX) {
        [self changeCenterXCompletionWithCenterX:params.centerXConstraint reverse:reverse];
    }
    if (params.centerYConstraint != CGFLOAT_MAX) {
        [self changeCenterYCompletionWithCenterY:params.centerYConstraint reverse:reverse];
    }
    if (params.bezier) {
        [self bezierAnimationCompletionWithPath:params.bezier reverse:reverse];
    }
}

- (void)_prepareConstraintWithParams:(YYAnimationParams *)params reverse:(BOOL)reverse
{
    if (params.widthConstraint > 0) {
        [self changeWidthConstraint:params.widthConstraint reverse:reverse updateLayout:YES];
    }
    if (params.heightConstraint > 0) {
        [self changeHeightConstraint:params.heightConstraint reverse:reverse updateLayout:YES];
    }
    if (params.topConstraint != CGFLOAT_MAX) {
        [self changeTopConstraint:params.topConstraint reverse:reverse updateLayout:YES];
    }
    if (params.bottomConstraint != CGFLOAT_MAX) {
        [self changeBottomConstraint:params.bottomConstraint reverse:reverse updateLayout:YES];
    }
    if (params.leftConstraint != CGFLOAT_MAX) {
        [self changeLeftConstraint:params.leftConstraint reverse:reverse updateLayout:YES];
    }
    if (params.rightConstraint != CGFLOAT_MAX) {
        [self changeRightConstraint:params.rightConstraint reverse:reverse updateLayout:YES];
    }
    if (params.leadingConstraint != CGFLOAT_MAX) {
        [self changeLeadingConstraint:params.leadingConstraint reverse:reverse updateLayout:YES];
    }
    if (params.trailingConstraint != CGFLOAT_MAX) {
        [self changeTrailingConstraint:params.trailingConstraint reverse:reverse updateLayout:YES];
    }
    if (params.centerXConstraint != CGFLOAT_MAX) {
        [self changeCenterXConstraint:params.centerXConstraint reverse:reverse updateLayout:YES];
    }
    if (params.centerYConstraint != CGFLOAT_MAX) {
        [self changeCenterYConstraint:params.centerYConstraint reverse:reverse updateLayout:YES];
    }
}

- (void)_addAnimationOption:(YYAnimationOption)option
{
    switch(option) {
        case YYAnimationOptionEaseIn:
            [self easeIn];
            break;
        case YYAnimationOptionEaseOut:
            [self easeOut];
            break;
        case YYAnimationOptionEaseInOut:
            [self easeInOut];
            break;
        case YYAnimationOptionSpring:
            [self spring];
            break;
        case YYAnimationOptionEaseBack:
            [self easeBack];
            break;
        case YYAnimationOptionBounce:
            [self bounce];
            break;
    }
}

- (void)play
{
    [self animateWithAnimatorQueue:[self.animatorQueues lastObject]];
}

@end
