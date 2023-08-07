//
//  YYAnimatorProtocol.h
//  YYAnimator
//
//  Created by LinSean on 2022/6/11.
//

#import <Foundation/Foundation.h>
#import "YYAnimatorQueue.h"
#import "YYAnimatorGroup.h"
#import "YYAnimationParams.h"


@protocol YYAnimatorProtocol <NSObject>

@optional
// 前向引用方法
@property (nonatomic, strong) NSMutableArray <YYAnimatorQueue *> *animatorQueues;
@property (nonatomic, assign) CGRect originalRect;
@property (nonatomic, assign) CGFloat originalAlpha;
@property (nonatomic, weak) UIView *view;

- (void)animateWithAnimatorQueue:(YYAnimatorQueue *)animatorQueue;

- (void)addAnimationAssembleAction:(YYAnimationAssembleAction)action;
- (void)addAnimationCompletionAction:(YYAnimationCompletionAction)action;
- (void)addAnimationConstraintAction:(YYAnimationCompletionAction)action;

- (void)addMoveXAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)moveXAnimationCompletionWithX:(float)x reverse:(BOOL)reverse;

- (void)addMoveYAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)moveYAnimationCompletionWithY:(float)y reverse:(BOOL)reverse;

- (void)addMoveXYAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)moveXYAnimationCompletionWithPoint:(CGPoint)point reverse:(BOOL)reverse;

- (void)addOriginXAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)originXAnimationCompletionWithX:(CGFloat)originX reverse:(BOOL)reverse;

- (void)addOriginYAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)originYAnimationCompletionWithY:(CGFloat)originY reverse:(BOOL)reverse;

- (void)addOriginAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)originAnimationCompletionWithPoint:(CGPoint)point reverse:(BOOL)reverse;

- (void)addSizeAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)sizeAnimationCompletionWithSize:(CGSize)size reverse:(BOOL)reverse;

- (void)addCenterAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)centerAnimationCompletionWithPoint:(CGPoint)point reverse:(BOOL)reverse;

- (void)addCustomizedPropertyAnimationToQueue:(YYAnimatorQueue *)queue withCustomData:(YYAnimatorCustomizedData *)customData;

- (void)addFrameAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)frameAnimationCompletionWithFrame:(CGRect)frame reverse:(BOOL)reverse;

- (void)addAdjustWidthAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)adjustWidthAnimationCompletionWithWidth:(CGFloat)width reverse:(BOOL)reverse;

- (void)addChangeWidthAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)addChangeWidthAnimationToQueue:(YYAnimatorQueue *)queue withWidth:(CGFloat)width reverse:(BOOL)reverse;
- (void)changeWidthAnimationCompletionWithWidth:(CGFloat)width reverse:(BOOL)reverse;

- (void)addChangeHeightAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)addChangeHeightAnimationToQueue:(YYAnimatorQueue *)queue withHeight:(CGFloat)height reverse:(BOOL)reverse;
- (void)changeHeightAnimationCompletionWithHeight:(CGFloat)height reverse:(BOOL)reverse;

- (void)addAdjustHeightAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)adjustHeightAnimationCompletionWithHeight:(CGFloat)height reverse:(BOOL)reverse;

- (void)addRotationZAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)rotationZAnimationWithAngle:(float)angle reverse:(BOOL)reverse;

- (void)addAlphaAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)alphaAnimationCompletionWithAlpha:(CGFloat)alpha reverse:(BOOL)reverse;

- (void)addScaleAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse;
- (void)scaleAnimationCompletionWithScale:(CGFloat)scale reverse:(BOOL)reverse;

- (void)changeHeightConstraint:(CGFloat)height reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)changeWidthConstraint:(CGFloat)width reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeTopConstraintAnimationToQueue:(YYAnimatorQueue *)queue withTop:(CGFloat)top reverse:(BOOL)reverse;
- (void)changeTopCompletionWithTop:(CGFloat)top reverse:(BOOL)reverse;
- (void)changeTopConstraint:(CGFloat)top reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeBottomConstraintAnimationToQueue:(YYAnimatorQueue *)queue withBottom:(CGFloat)bottom reverse:(BOOL)reverse;
- (void)changeBottomCompletionWithBottom:(CGFloat)bottom reverse:(BOOL)reverse;
- (void)changeBottomConstraint:(CGFloat)bottom reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeLeftConstraintAnimationToQueue:(YYAnimatorQueue *)queue withLeft:(float)left reverse:(BOOL)reverse;
- (void)changeLeftCompletionWithLeft:(float)left reverse:(BOOL)reverse;
- (void)changeLeftConstraint:(float)left reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeRightConstraintAnimationToQueue:(YYAnimatorQueue *)queue withRight:(float)right reverse:(BOOL)reverse;
- (void)changeRightCompletionWithRight:(float)right reverse:(BOOL)reverse;
- (void)changeRightConstraint:(float)right reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeLeadingConstraintAnimationToQueue:(YYAnimatorQueue *)queue withLeading:(float)leading reverse:(BOOL)reverse;
- (void)changeLeadingCompletionWithLeading:(float)leading reverse:(BOOL)reverse;
- (void)changeLeadingConstraint:(float)leading reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeTrailingConstraintAnimationToQueue:(YYAnimatorQueue *)queue withTrailing:(float)trailing reverse:(BOOL)reverse;
- (void)changeTrailingCompletionWithTrailing:(float)trailing reverse:(BOOL)reverse;
- (void)changeTrailingConstraint:(float)trailing reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeCenterXConstraintAnimationToQueue:(YYAnimatorQueue *)queue withCenterX:(CGFloat)centerX reverse:(BOOL)reverse;
- (void)changeCenterXCompletionWithCenterX:(CGFloat)centerX reverse:(BOOL)reverse;
- (void)changeCenterXConstraint:(CGFloat)centerX reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)addChangeCenterYConstraintAnimationToQueue:(YYAnimatorQueue *)queue withCenterY:(CGFloat)centerY reverse:(BOOL)reverse;
- (void)changeCenterYCompletionWithCenterY:(CGFloat)centerY reverse:(BOOL)reverse;
- (void)changeCenterYConstraint:(CGFloat)centerY reverse:(BOOL)reverse updateLayout:(BOOL)updateLayout;

- (void)updateAnimationAnchor:(YYAnimationAnchor)anchor immediately:(BOOL)immediately;

- (void)addCountingNumberAnimationToQueue:(YYAnimatorQueue *)queue withCountingNumberData:(YYAnimatorCountingNumberData *)countingNumberData;

- (void)addCountingNumberAnimationToQueue:(YYAnimatorQueue *)queue withValue:(CGFloat)value reverse:(BOOL)reverse;

- (void)addBezierPathAnimationToQueue:(YYAnimatorQueue *)queue withPath:(UIBezierPath *)path reverse:(BOOL)reverse;
- (void)bezierAnimationCompletionWithPath:(UIBezierPath *)path reverse:(BOOL)reverse;


- (CGPoint)newPositionFromNewOrigin:(CGPoint)newOrigin;
- (CGPoint)newPositionFromNewCenter:(CGPoint)newCenter;

@end

