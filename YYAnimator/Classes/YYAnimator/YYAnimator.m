//
//  YYAnimator.m
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import "YYAnimator.h"
#import "YYAnimatorQueue.h"
#import "YYKeyframeAnimation.h"
#import "YYAnimationParams.h"
#import "UIView+TweenStudio.h"

#define YYAngle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface YYAnimator ()

@property (nonatomic, strong) NSMutableArray <YYAnimatorQueue *> *animatorQueues;
@property (nonatomic, assign) CGRect originalRect;
@property (nonatomic, assign) CGFloat originalAlpha;
@property (nonatomic, assign) CGFloat originalScale;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong, readwrite) YYACountingLayer *countingLayer;

@end

@implementation YYAnimator

+ (instancetype)animatorWithView:(UIView *)view {
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view {
    _view = view;
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)self.view;
        self.countingLayer = [YYACountingLayer layer];
        self.countingLayer.numberLabel = label;
        self.countingLayer.frame = label.bounds;
        [self.view.layer addSublayer:self.countingLayer];
    }
    return [self initWithLayer:view.layer];
}

+ (instancetype)animatorWithLayer:(CALayer *)layer {
    return [[self alloc] initWithLayer:layer];
}

- (instancetype)initWithLayer:(CALayer *)layer {
    if (self = [super init]) {
        _originalRect = layer.frame;
        _originalAlpha = layer.opacity;
        NSNumber *scaleValue = [layer valueForKeyPath: @"transform.scale.x"];
        if (scaleValue) {
            _originalScale = [scaleValue floatValue];
        } else {
            _originalScale = 1.0;
        }
        _layer = layer;
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"animator dealloc");
}

- (NSMutableArray<YYAnimatorQueue *> *)animatorQueues {
    if (!_animatorQueues) {
        _animatorQueues = [NSMutableArray array];
    }
    
    return _animatorQueues;
}

- (YYKeyframeAnimation *)basicAnimationForKeyPath:(NSString *)keypath {
    YYKeyframeAnimation *animation = [YYKeyframeAnimation animationWithKeyPath:keypath];
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    
    return animation;
}

- (void)addAnimation:(YYKeyframeAnimation *)animation withAnimatorQueue:(YYAnimatorQueue *)animatorQueue {
    [animatorQueue addAnimation:animation];
}

- (void)addAnimationKeyframeFunctionBlock:(YYKeyframeAnimationFunctionBlock)functionBlock {
    [self addAnimationAssembleAction:^(YYAnimator *__weak  _Nonnull animator, YYAnimatorQueue *__weak  _Nonnull animatorQueue, BOOL reverse) {
        [animatorQueue addAnimationFunctionBlock:functionBlock];
    }];
}

- (void)addAnimationAssembleAction:(YYAnimationAssembleAction)action {
    [[self.animatorQueues lastObject] addAnimationAssembleAction:action];
}

- (void)addAnimationCompletionAction:(YYAnimationCompletionAction)action {
    [[self.animatorQueues lastObject] addAnimationCompletionAction:action];
}

- (void)addAnimationConstraintAction:(YYAnimationCompletionAction)action
{
    [[self.animatorQueues lastObject] addAnimationConstraintAction:action];
}

- (void)updateAnimationAnchor:(YYAnimationAnchor)anchor immediately:(BOOL)immediately
{
    switch (anchor) {
        case YYAnimationAnchorCenter:
        {
            CGPoint centerPoint = CGPointMake(0.5, 0.5);
            if (immediately) {
                [self _updateAnimationAnchorPoint:centerPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:centerPoint];
            }
        }
            break;
        case YYAnimationAnchorTop:
        {
            CGPoint topPoint = CGPointMake(0.5, 0.0);
            if (immediately) {
                [self _updateAnimationAnchorPoint:topPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:topPoint];
            }
        }
            break;
        case YYAnimationAnchorBottom:
        {
            CGPoint bottomPoint = CGPointMake(0.5, 1.0);
            if (immediately) {
                [self _updateAnimationAnchorPoint:bottomPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:bottomPoint];
            }
        }
            break;
        case YYAnimationAnchorLeft:
        {
            CGPoint leftPoint = CGPointMake(0.0, 0.5);
            if (immediately) {
                [self _updateAnimationAnchorPoint:leftPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:leftPoint];
            }
        }
            break;
        case YYAnimationAnchorRight:
        {
            CGPoint rightPoint = CGPointMake(1.0, 0.5);
            if (immediately) {
                [self _updateAnimationAnchorPoint:rightPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:rightPoint];
            }
        }
            break;
        case YYAnimationAnchorTopLeft:
        {
            CGPoint topLeftPoint = CGPointMake(0.0, 0.0);
            if (immediately) {
                [self _updateAnimationAnchorPoint:topLeftPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:topLeftPoint];
            }
        }
            break;
        case YYAnimationAnchorTopRight:
        {
            CGPoint topRightPoint = CGPointMake(1.0, 0.0);
            if (immediately) {
                [self _updateAnimationAnchorPoint:topRightPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:topRightPoint];
            }
        }
            break;
        case YYAnimationAnchorBottomLeft:
        {
            CGPoint bottomLeftPoint = CGPointMake(0.0, 1.0);
            if (immediately) {
                [self _updateAnimationAnchorPoint:bottomLeftPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:bottomLeftPoint];
            }
        }
            break;
        case YYAnimationAnchorBottomRight:
        {
            CGPoint bottomRightPoint = CGPointMake(1.0, 1.0);
            if (immediately) {
                [self _updateAnimationAnchorPoint:bottomRightPoint animator:self];
            } else {
                [self _preSetAnchorWithPoint:bottomRightPoint];
            }
        }
            break;
    }
}

- (void)_preSetAnchorWithPoint:(CGPoint)anchorPoint {
    __weak typeof(self) wSelf = self;
    YYAnimationAssembleAction action = ^void(__weak YYAnimator *animator, __weak YYAnimatorQueue *animatorQueue, BOOL reverse) {
        [wSelf _updateAnimationAnchorPoint:anchorPoint animator:animator];
    };
    
    [[self.animatorQueues lastObject] updateAnchorWithAction:action];
}

- (void)_updateAnimationAnchorPoint:(CGPoint)anchorPoint animator:(YYAnimator *)animator
{
    if (CGPointEqualToPoint(anchorPoint, animator.layer.anchorPoint)) {
        return;
    }
    CGPoint newPoint = CGPointMake(animator.layer.bounds.size.width * anchorPoint.x,
                                   animator.layer.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(animator.layer.bounds.size.width * animator.layer.anchorPoint.x,
                                   animator.layer.bounds.size.height * animator.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, animator.layer.affineTransform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, animator.layer.affineTransform);
    
    CGPoint position = animator.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    animator.layer.position = position;
    animator.layer.anchorPoint = anchorPoint;
}

- (void)animateWithAnimatorQueue:(YYAnimatorQueue *)animatorQueue {
    self.isPlaying = YES;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        if (animatorQueue.shouldRemoveOnCompletion) {
            [self.layer removeAnimationForKey:animatorQueue.animationKey];
        }
        [self queueGroupDidFinishAnimationsWithAnimatorQueue:animatorQueue];
    }];
    NSAssert([self.animatorQueues containsObject:animatorQueue], @"current queue not exists");
    [animatorQueue animateWithAnimationKey:animatorQueue.animationKey];
    [CATransaction commit];
    [animatorQueue executeCompletionActions];
}

- (void)queueGroupDidFinishAnimationsWithAnimatorQueue:(YYAnimatorQueue *)animatorQueue {
    BOOL reverse = [animatorQueue isCurrentTurnGroupReverse];
    if ([animatorQueue isEmptiedAfterTryToRemoveCurrentTurnGroup]) {
        [self executeConstraintCompletionActionsWithAnimatorQueue:animatorQueue reverse:reverse];
        [self.animatorQueues removeObject:animatorQueue];
        if (!self.animatorQueues.count) {
            self.isPlaying = NO;
            [self.animatorQueues addObject:[YYAnimatorQueue queueWithAnimator:self]];
            if (self.finalCompeltion) {
                self.finalCompeltion();
            }
        }
    } else {
        [self animateWithAnimatorQueue:animatorQueue];
    }
}


- (void)executeConstraintCompletionActionsWithAnimatorQueue:(YYAnimatorQueue *)animatorQueue reverse:(BOOL)reverse {
    [animatorQueue executeConstraintActionsReverse:reverse];
}

#pragma mark - UI Data Method
- (CGPoint)newPositionFromNewOrigin:(CGPoint)newOrigin {
    CGPoint anchor = self.layer.anchorPoint;
    CGSize size = self.layer.bounds.size;
    CGPoint newPosition;
    newPosition.x = newOrigin.x + anchor.x * size.width;
    newPosition.y = newOrigin.y + anchor.y * size.height;
    
    return newPosition;
}

- (CGPoint)newPositionFromNewCenter:(CGPoint)newCenter {
    CGPoint anchor = self.layer.anchorPoint;
    CGSize size = self.layer.bounds.size;
    CGPoint newPosition;
    newPosition.x = newCenter.x + (anchor.x - 0.5) * size.width;
    newPosition.y = newCenter.y + (anchor.y - 0.5) * size.height;
    
    return newPosition;
}


# pragma mark - 添加动效方法
- (void)addMoveXAnimationToQueue:(YYAnimatorQueue *)queue withX:(float)x reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];
    
    if (reverse) {
        [self moveXAnimationCompletionWithX:x reverse:NO];
        x = -x;
    }
    
    positionAnimation.fromValue = @(self.layer.position.x);
    positionAnimation.toValue = @(self.layer.position.x + x);
    
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)moveXAnimationCompletionWithX:(float)x reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    if (reverse) {
        position.x -= x;
    } else {
        position.x += x;
    }
    self.layer.position = position;
}

- (void)addMoveYAnimationToQueue:(YYAnimatorQueue *)queue withY:(float)y  reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.y"];
    
    if (reverse) {
        [self moveYAnimationCompletionWithY:y reverse:NO];
        y = -y;
    }
    
    positionAnimation.fromValue = @(self.layer.position.y);
    positionAnimation.toValue = @(self.layer.position.y + y);
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)moveYAnimationCompletionWithY:(float)y reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    if (reverse) {
        position.y -= y;
    } else {
        position.y += y;
    }
    
    self.layer.position = position;
}

- (void)addMoveXYAnimationToQueue:(YYAnimatorQueue *)queue withPoint:(CGPoint)point reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
    
    if (reverse) {
        [self moveXYAnimationCompletionWithPoint:point reverse:NO];
        point = CGPointMake(-point.x, -point.y);
    }
    
    CGPoint oldOrigin = self.layer.frame.origin;
    CGPoint newPosition = [self newPositionFromNewOrigin:CGPointMake(oldOrigin.x + point.x, oldOrigin.y + point.y)];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)moveXYAnimationCompletionWithPoint:(CGPoint)point reverse:(BOOL)reverse
{
    CGPoint position = self.layer.position;
    if (reverse) {
        position.x -= point.x;
        position.y -= point.y;
    } else {
        position.x += point.x;
        position.y += point.y;
    }
    self.layer.position = position;
}

- (void)addOriginXAnimationToQueue:(YYAnimatorQueue *)queue withX:(CGFloat)originX reverse:(BOOL)reverse
{
    YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position"];
    
    CGPoint newOrigin = [self newPositionFromNewOrigin:CGPointMake(originX, self.originalRect.origin.y)];
    if (reverse) {
        [self originXAnimationCompletionWithX:originX reverse:NO];
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    }
    originAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    originAnimation.toValue = [NSValue valueWithCGPoint:newOrigin];
    [self addAnimation:originAnimation withAnimatorQueue:queue];
}

- (void)originXAnimationCompletionWithX:(CGFloat)originX reverse:(BOOL)reverse
{
    CGPoint newOrigin = CGPointZero;
    if (reverse) {
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    } else {
        newOrigin = [self newPositionFromNewOrigin:CGPointMake(originX, self.originalRect.origin.y)];
    }
    self.layer.position = newOrigin;
}

- (void)addOriginYAnimationToQueue:(YYAnimatorQueue *)queue WithY:(CGFloat)originY reverse:(BOOL)reverse
{
    YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position"];
    
    CGPoint newOrigin = [self newPositionFromNewOrigin:CGPointMake(self.originalRect.origin.x, originY)];
    if (reverse) {
        [self originYAnimationCompletionWithY:originY reverse:NO];
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    }
    originAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    originAnimation.toValue = [NSValue valueWithCGPoint:newOrigin];
    [self addAnimation:originAnimation withAnimatorQueue:queue];
}

- (void)originYAnimationCompletionWithY:(CGFloat)originY reverse:(BOOL)reverse
{
    CGPoint newOrigin = CGPointZero;
    if (reverse) {
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    } else {
        newOrigin = [self newPositionFromNewOrigin:CGPointMake(self.originalRect.origin.x, originY)];
    }
    self.layer.position = newOrigin;
}

- (void)addOriginAnimationToQueue:(YYAnimatorQueue *)queue withPoint:(CGPoint)point reverse:(BOOL)reverse
{
    YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position"];
    
    CGPoint newOrigin = [self newPositionFromNewOrigin:CGPointMake(point.x, point.y)];
    if (reverse) {
        [self originAnimationCompletionWithPoint:point reverse:NO];
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    }
    
    originAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    originAnimation.toValue = [NSValue valueWithCGPoint:newOrigin];
    [self addAnimation:originAnimation withAnimatorQueue:queue];
}

- (void)originAnimationCompletionWithPoint:(CGPoint)point reverse:(BOOL)reverse
{
    CGPoint newOrigin = [self newPositionFromNewOrigin:CGPointMake(point.x, point.y)];
    if (reverse) {
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    }
    self.layer.position = newOrigin;
}

- (void)addSizeAnimationToQueue:(YYAnimatorQueue *)queue withSize:(CGSize)size reverse:(BOOL)reverse;
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size"];
    
    NSValue *toValue = [NSValue valueWithCGSize:CGSizeMake(size.width, size.height)];
    if (reverse) {
        [self sizeAnimationCompletionWithSize:size reverse:NO];
        toValue = [NSValue valueWithCGSize:CGSizeMake(self.originalRect.size.width, self.originalRect.size.height)];
    }
    
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.layer.bounds.size];
    sizeAnimation.toValue = toValue;
    [self addAnimation:sizeAnimation withAnimatorQueue:queue];
}

- (void)sizeAnimationCompletionWithSize:(CGSize)size reverse:(BOOL)reverse;
{
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    if (reverse) {
        bounds = CGRectMake(0, 0, self.originalRect.size.width, self.originalRect.size.height);
    }
    self.layer.bounds = bounds;
}

- (void)addCenterAnimationToQueue:(YYAnimatorQueue *)queue withPoint:(CGPoint)point reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
    
    CGPoint newPosition = [self newPositionFromNewCenter:point];
    if (reverse) {
        [self centerAnimationCompletionWithPoint:point reverse:NO];
        newPosition = [self newPositionFromNewOrigin:CGPointMake(self.originalRect.origin.x, self.originalRect.origin.y)];
    }
    
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)centerAnimationCompletionWithPoint:(CGPoint)point  reverse:(BOOL)reverse
{
    if (reverse) {
        self.layer.position = [self newPositionFromNewOrigin:CGPointMake(self.originalRect.origin.x, self.originalRect.origin.y)];
    } else {
        self.layer.position = point;
    }
}

- (void)addCustomizedPropertyAnimationToQueue:(YYAnimatorQueue *)queue withCustomData:(YYAnimatorCustomizedData *)customData
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:customData.keyPath];
    
    positionAnimation.customizedValues = [customData.values copy];
    
    if (customData.property == YYAnimatorCustomPropertyRotation) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[customData.values count]];
        [customData.values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array addObject:@(YYAngle2Rad([obj doubleValue]))];
        }];
        positionAnimation.customizedValues = array;
    }
    positionAnimation.customizedKeyTimes = [customData.keyTimes copy];
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)addFrameAnimationToQueue:(YYAnimatorQueue *)queue withFrame:(CGRect)frame reverse:(BOOL)reverse
{
    [self addCenterAnimationToQueue:queue withPoint:frame.origin reverse:reverse];
    [self addSizeAnimationToQueue:queue withSize:frame.size reverse:reverse];
}

- (void)frameAnimationCompletionWithFrame:(CGRect)frame reverse:(BOOL)reverse
{
    [self sizeAnimationCompletionWithSize:frame.size reverse:reverse];
    [self centerAnimationCompletionWithPoint:frame.origin reverse:reverse];
}

- (void)addAdjustWidthAnimationToQueue:(YYAnimatorQueue *)queue withWidth:(CGFloat)width reverse:(BOOL)reverse
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size"];
    if (reverse) {
        [self adjustWidthAnimationCompletionWithWidth:width reverse:NO];
        width = -width;
    }
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.layer.bounds.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(MAX(self.layer.bounds.size.width + width, 0), self.layer.bounds.size.height)];
    [self addAnimation:sizeAnimation withAnimatorQueue:queue];
}

- (void)adjustWidthAnimationCompletionWithWidth:(CGFloat)width reverse:(BOOL)reverse
{
    if (reverse) {
        width = -width;
    }
    
    CGRect bounds = CGRectMake(0, 0, MAX(self.layer.bounds.size.width+width, 0), self.layer.bounds.size.height);
    self.layer.bounds = bounds;
}

- (void)addChangeWidthAnimationToQueue:(YYAnimatorQueue *)queue withWidth:(CGFloat)width reverse:(BOOL)reverse
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size"];
    if (reverse) {
        [self changeWidthAnimationCompletionWithWidth:width reverse:NO];
        width = self.originalRect.size.width;
    }
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.layer.bounds.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(MAX(width, 0), self.layer.bounds.size.height)];
    [self addAnimation:sizeAnimation withAnimatorQueue:queue];
}

- (void)changeWidthAnimationCompletionWithWidth:(CGFloat)width reverse:(BOOL)reverse
{
    if (reverse) {
        width = self.originalRect.size.width;
    }
    
    CGRect bounds = CGRectMake(0, 0, MAX(width, 0), self.layer.bounds.size.height);
    self.layer.bounds = bounds;
}

- (void)addChangeHeightAnimationToQueue:(YYAnimatorQueue *)queue withHeight:(CGFloat)height reverse:(BOOL)reverse
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size"];
    if (reverse) {
        [self changeHeightAnimationCompletionWithHeight:height reverse:NO];
        height = self.originalRect.size.height;
    }
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.layer.bounds.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(self.layer.bounds.size.width, MAX(height, 0))];
    [self addAnimation:sizeAnimation withAnimatorQueue:queue];
}

- (void)changeHeightAnimationCompletionWithHeight:(CGFloat)height reverse:(BOOL)reverse
{
    if (reverse) {
        height = self.originalRect.size.height;
    }
    
    CGRect bounds = CGRectMake(0, 0, self.layer.bounds.size.width, MAX(height, 0));
    self.layer.bounds = bounds;
}

- (void)addAdjustHeightAnimationToQueue:(YYAnimatorQueue *)queue withHeight:(CGFloat)height reverse:(BOOL)reverse
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size"];
    if (reverse) {
        [self adjustHeightAnimationCompletionWithHeight:height reverse:NO];
        height = -height;
    }
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.layer.bounds.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(self.layer.bounds.size.width, MAX(self.layer.bounds.size.height + height, 0))];
    [self addAnimation:sizeAnimation withAnimatorQueue:queue];
}

- (void)adjustHeightAnimationCompletionWithHeight:(CGFloat)height reverse:(BOOL)reverse
{
    if (reverse) {
        height = -height;
    }
    
    CGRect bounds = CGRectMake(0, 0, self.layer.bounds.size.width, MAX(self.layer.bounds.size.height+height, 0));
    self.layer.bounds = bounds;
}

- (void)addRotationZAnimationToQueue:(YYAnimatorQueue *)queue withAngle:(float)angle reverse:(BOOL)reverse
{
    YYKeyframeAnimation *rotationAnimation = [self basicAnimationForKeyPath:@"transform.rotation.z"];
    if (reverse) {
        [self rotationZAnimationWithAngle:angle reverse:NO];
        angle = -angle;
    }
    CATransform3D transform = self.layer.transform;
    CGFloat originalRotation = atan2(transform.m12, transform.m11);
    rotationAnimation.fromValue = @(originalRotation);
    rotationAnimation.toValue = @(originalRotation + YYAngle2Rad(angle));
    [self addAnimation:rotationAnimation withAnimatorQueue:queue];
}

- (void)rotationZAnimationWithAngle:(float)angle reverse:(BOOL)reverse
{
    if (reverse) {
        angle = -angle;
    }
    
    CATransform3D transform = self.layer.transform;
    self.layer.transform = CATransform3DRotate(self.layer.transform, YYAngle2Rad(angle), 0, 0, 1.0);
}

- (void)addAlphaAnimationToQueue:(YYAnimatorQueue *)queue withAlpha:(CGFloat)alpha reverse:(BOOL)reverse
{
    YYKeyframeAnimation *alphaAnimation = [self basicAnimationForKeyPath:@"opacity"];
    if (reverse) {
        [self alphaAnimationCompletionWithAlpha:alpha reverse:NO];
        alpha = self.originalAlpha;
    }
    alphaAnimation.fromValue = @(self.layer.opacity);
    alphaAnimation.toValue = @(alpha);
    [self addAnimation:alphaAnimation withAnimatorQueue:queue];
}

- (void)alphaAnimationCompletionWithAlpha:(CGFloat)alpha reverse:(BOOL)reverse
{
    if (reverse) {
        alpha = self.originalAlpha;
    }
    self.layer.opacity = alpha;
}

- (void)addScaleAnimationToQueue:(YYAnimatorQueue *)queue withScale:(CGFloat)scale reverse:(BOOL)reverse
{
    YYKeyframeAnimation *boundsAnimation = [self basicAnimationForKeyPath:@"transform.scale"];
    if (reverse) {
        [self scaleAnimationCompletionWithScale:scale reverse:NO];
        scale = self.originalScale;
    }
    CGFloat currentScale = [[self.layer valueForKeyPath: @"transform.scale.x"] floatValue];
    boundsAnimation.fromValue = @(currentScale);
    boundsAnimation.toValue = @(scale);
    [self addAnimation:boundsAnimation withAnimatorQueue:queue];
}

- (void)scaleAnimationCompletionWithScale:(CGFloat)scale reverse:(BOOL)reverse
{
    if (reverse) {
        scale = self.originalScale;
    }
    CGFloat currentScale = [[self.layer valueForKeyPath: @"transform.scale.x"] floatValue];
    CGFloat targetScale = scale / currentScale;
    self.layer.transform = CATransform3DScale(self.layer.transform, targetScale, targetScale, 1.0);
}


- (void)addCountingNumberAnimationToQueue:(YYAnimatorQueue *)queue withCountingNumberData:(YYAnimatorCountingNumberData *)countingNumberData
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:YYCountingAnimationKey];
    positionAnimation.fromValue = @(countingNumberData.fromValue);
    positionAnimation.toValue = @(countingNumberData.toValue);
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)addCountingNumberAnimationToQueue:(YYAnimatorQueue *)queue withValue:(CGFloat)value reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:YYCountingAnimationKey];
    CGFloat labelValue = 0;
    if ([self.view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)self.view;
        labelValue = [label.text floatValue];
    }
    if (reverse) {
        positionAnimation.fromValue = @(value);
        positionAnimation.toValue = @(labelValue);
    } else {
        positionAnimation.fromValue = @(labelValue);
        positionAnimation.toValue = @(value);
    }
   
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)addBezierPathAnimationToQueue:(YYAnimatorQueue *)queue withPath:(UIBezierPath *)path reverse:(BOOL)reverse
{
    YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
    if (reverse) {
        [self bezierAnimationCompletionWithPath:path reverse:NO];
        positionAnimation.path = [path bezierPathByReversingPath].CGPath;
    } else {
        positionAnimation.path = path.CGPath;
    }
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)bezierAnimationCompletionWithPath:(UIBezierPath *)path reverse:(BOOL)reverse
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(path.CGPath, (__bridge void *)points, getKeyPointsFromBezierpath);
    if (reverse) {
        self.layer.position = [[points firstObject] CGPointValue];
    } else {
        self.layer.position = [[points lastObject] CGPointValue];
    }
}

void getKeyPointsFromBezierpath(void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    if (type != kCGPathElementCloseSubpath)
    {
       if ((type == kCGPathElementAddLineToPoint) ||
           (type == kCGPathElementMoveToPoint))
           [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
       else if (type == kCGPathElementAddQuadCurveToPoint)
           [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
       else if (type == kCGPathElementAddCurveToPoint)
           [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
    }
}

@end
