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
@property (nonatomic, assign) CGFloat originalAngle;
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
        self.originalAngle = atan2(layer.transform.m12, layer.transform.m11);
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
- (void)addMoveXAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    CGFloat offset = self.layer.position.x;
    NSMutableArray *array = [NSMutableArray array];
    [array reverseObjectEnumerator];
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAMoveX] offset:offset reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];
        positionAnimation.customizedValues = customizedValue;
        positionAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAMoveX param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        CGFloat targetMoveX = [[customizedValue lastObject] floatValue] - offset;
        param.moveX = reverse ? -targetMoveX : targetMoveX;
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    } else if (param.moveX != CGFLOAT_MAX && param.moveX != 0) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.x"];
        CGFloat x = param.moveX;
        if (reverse) {
            [self moveXAnimationCompletionWithX:x reverse:NO];
            x = -x;
        }
        positionAnimation.fromValue = @(self.layer.position.x);
        positionAnimation.toValue = @(self.layer.position.x + x);
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    }
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

- (void)addMoveYAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    CGFloat offset = self.layer.position.y;
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAMoveY] offset:offset reverse:reverse];
    if (customizedValue.count > 0) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.y"];
        positionAnimation.customizedValues = customizedValue;
        positionAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAMoveY param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        CGFloat targetY = [[customizedValue lastObject] floatValue] - offset;
        param.moveY = reverse ? -targetY : targetY;
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    } else if (param.moveY != CGFLOAT_MAX && param.moveY != 0) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position.y"];
        CGFloat y = param.moveY;
        if (reverse) {
            [self moveYAnimationCompletionWithY:y reverse:NO];
            y = - y;
        }
        positionAnimation.fromValue = @(self.layer.position.y);
        positionAnimation.toValue = @(self.layer.position.y + y);
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    }
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

- (void)addMoveXYAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    CGPoint oldOrigin = self.layer.frame.origin;
    CGSize oldSize = self.layer.frame.size;
    CGPoint offset = CGPointMake(oldOrigin.x + self.layer.anchorPoint.x * oldSize.width, oldOrigin.y + self.layer.anchorPoint.y * oldSize.height);
    NSArray *customizedValue = [YYAnimationParams pointValuesFromParam:[param.customizedParamData objectForKey:YYAMoveXY] offset:offset reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
        positionAnimation.customizedValues = customizedValue;
        positionAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAMoveY param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        CGPoint moveXY = [[customizedValue lastObject] CGPointValue];
        param.moveXY = reverse ? CGPointMake(offset.x - moveXY.x, offset.y - moveXY.y) : CGPointMake(moveXY.x - offset.x, moveXY.y - offset.y);
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    } else if ([param isMoveXYValid]) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
        CGPoint point = param.moveXY;
        if (reverse) {
            [self moveXYAnimationCompletionWithPoint:point reverse:NO];
            point = CGPointMake(-point.x, -point.y);
        }
        CGPoint newPosition = [self newPositionFromNewOrigin:CGPointMake(oldOrigin.x + point.x, oldOrigin.y + point.y)];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
        positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    }
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

- (void)addOriginXAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    CGFloat offset = self.layer.anchorPoint.x * self.layer.bounds.size.width;
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAOriginX] offset:offset reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position.x"];
        originAnimation.customizedValues = customizedValue;
        originAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAOriginX param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.originX = [[customizedValue lastObject] floatValue] - offset;
        if (reverse) {
            [self originXAnimationCompletionWithX:param.originX reverse:NO];
            self.originalRect = CGRectMake(param.originX, self.originalRect.origin.y, self.originalRect.size.width, self.originalRect.size.height);
        }
        [self addAnimation:originAnimation withAnimatorQueue:queue];
    } else if (param.originX != CGFLOAT_MAX) {
        YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position.x"];
        CGFloat originX = param.originX;
        if (reverse) {
            [self originXAnimationCompletionWithX:originX reverse:NO];
            originX = self.originalRect.origin.x;
        }
        originAnimation.fromValue = @(self.layer.position.x);
        originAnimation.toValue = @(originX + offset);
        [self addAnimation:originAnimation withAnimatorQueue:queue];
    }
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

- (void)addOriginYAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    CGFloat offset = self.layer.anchorPoint.y * self.layer.bounds.size.height;
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAOriginY] offset:offset reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position.y"];
        originAnimation.customizedValues = customizedValue;
        originAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAOriginY param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.originY = [[customizedValue lastObject] floatValue] - offset;
        if (reverse) {
            [self originYAnimationCompletionWithY:param.originY reverse:NO];
            self.originalRect = CGRectMake(self.originalRect.origin.x, param.originY, self.originalRect.size.width, self.originalRect.size.height);
        }
        [self addAnimation:originAnimation withAnimatorQueue:queue];
    } else if (param.originY != CGFLOAT_MAX) {
        YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position.y"];
        CGFloat originY = param.originY;
        if (reverse) {
            [self originYAnimationCompletionWithY:originY reverse:NO];
            originY = self.originalRect.origin.y;
        }
        originAnimation.fromValue = @(self.layer.position.y);
        originAnimation.toValue = @(originY + offset);
        [self addAnimation:originAnimation withAnimatorQueue:queue];
    }
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

- (void)addOriginAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    CGPoint offset = CGPointMake(self.layer.anchorPoint.x * self.layer.bounds.size.width, self.layer.anchorPoint.y * self.layer.bounds.size.height);
    NSArray *customizedValue = [YYAnimationParams pointValuesFromParam:[param.customizedParamData objectForKey:YYAOrigin] offset:offset reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position"];
        originAnimation.customizedValues = customizedValue;
        originAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAOrigin param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        CGPoint p = [[customizedValue lastObject] CGPointValue];
        param.origin = CGPointMake(p.x - offset.x, p.y - offset.y);
        if (reverse) {
            [self originAnimationCompletionWithPoint:param.origin reverse:NO];
            self.originalRect = CGRectMake(param.origin.x, param.origin.y, self.originalRect.size.width, self.originalRect.size.height);
        }
        [self addAnimation:originAnimation withAnimatorQueue:queue];
    } else if ([param isOriginValid]) {
        YYKeyframeAnimation *originAnimation = [self basicAnimationForKeyPath:@"position"];
        CGPoint point = param.origin;
        CGPoint newOrigin = [self newPositionFromNewOrigin:CGPointMake(point.x, point.y)];
        if (reverse) {
            [self originAnimationCompletionWithPoint:point reverse:NO];
            newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
        }
        originAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
        originAnimation.toValue = [NSValue valueWithCGPoint:newOrigin];
        [self addAnimation:originAnimation withAnimatorQueue:queue];
    }
}

- (void)originAnimationCompletionWithPoint:(CGPoint)point reverse:(BOOL)reverse
{
    CGPoint newOrigin = [self newPositionFromNewOrigin:point];
    if (reverse) {
        newOrigin = [self newPositionFromNewOrigin:self.originalRect.origin];
    }
    self.layer.position = newOrigin;
}

- (void)addSizeAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams sizeValuesFromParam:[param.customizedParamData objectForKey:YYASize] offset:CGSizeZero reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size"];
        sizeAnimation.customizedValues = customizedValue;
        sizeAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYASize param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.size = [[customizedValue lastObject] CGSizeValue];
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    } else if ([param isSizeValid]) {
        [self addSizeAnimationToQueue:queue withSize:param.size reverse:reverse];
    }
}

- (void)addSizeAnimationToQueue:(YYAnimatorQueue *)queue withSize:(CGSize)size reverse:(BOOL)reverse
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

- (void)addCenterAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams pointValuesFromParam:[param.customizedParamData objectForKey:YYACenter] offset:CGPointZero reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *positionAnimation = [self basicAnimationForKeyPath:@"position"];
        positionAnimation.customizedValues = customizedValue;
        positionAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYACenter param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.center = [[customizedValue lastObject] CGPointValue];
        if (reverse) {
            [self centerAnimationCompletionWithPoint:param.center reverse:NO];
            self.originalRect = CGRectMake(param.center.x - self.layer.anchorPoint.x * self.originalRect.size.width, param.center.y - self.layer.anchorPoint.y * self.originalRect.size.height, self.originalRect.size.width, self.originalRect.size.height);
        }
        [self addAnimation:positionAnimation withAnimatorQueue:queue];
    } else if ([param isCenterValid]) {
        [self addCenterAnimationToQueue:queue withPoint:param.center reverse:reverse];
    }
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
    [queue setShouldRemoveOnCompletion:NO];
    [self addAnimation:positionAnimation withAnimatorQueue:queue];
}

- (void)addFrameAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    if ([param isFrameValid]) {
        CGPoint targetCenter = CGPointMake(param.frame.origin.x + param.frame.size.width * 0.5, param.frame.origin.y + param.frame.size.height * 0.5);
        [self addCenterAnimationToQueue:queue withPoint:targetCenter reverse:reverse];
        [self addSizeAnimationToQueue:queue withSize:param.frame.size reverse:reverse];
    }
}

- (void)frameAnimationCompletionWithFrame:(CGRect)frame reverse:(BOOL)reverse
{
    [self sizeAnimationCompletionWithSize:frame.size reverse:reverse];
    CGPoint targetCenter = CGPointMake(frame.origin.x + frame.size.width * 0.5, frame.origin.y + frame.size.height * 0.5);
    [self centerAnimationCompletionWithPoint:targetCenter reverse:reverse];
}

- (void)addAdjustWidthAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAAdjustWidth] offset:self.layer.bounds.size.width reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.width"];
        sizeAnimation.customizedValues = customizedValue;
        sizeAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAAdjustWidth param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.adjustWidth = [[customizedValue lastObject] floatValue] - self.layer.bounds.size.width;
        if (reverse) {
            param.adjustWidth = -param.adjustWidth;
        }
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    } else if (param.adjustWidth != 0 && param.adjustWidth != CGFLOAT_MAX) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.width"];
        CGFloat width = param.adjustWidth;
        if (reverse) {
            [self adjustWidthAnimationCompletionWithWidth:width reverse:NO];
            width = -width;
        }
        sizeAnimation.fromValue = @(self.layer.bounds.size.width);
        sizeAnimation.toValue = @(MAX(self.layer.bounds.size.width + width, 0));
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    }
}

- (void)adjustWidthAnimationCompletionWithWidth:(CGFloat)width reverse:(BOOL)reverse
{
    if (reverse) {
        width = -width;
    }
    
    CGRect bounds = CGRectMake(0, 0, MAX(self.layer.bounds.size.width+width, 0), self.layer.bounds.size.height);
    self.layer.bounds = bounds;
}

- (void)addChangeWidthAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAWidth] offset:0 reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.width"];
        sizeAnimation.customizedValues = customizedValue;
        sizeAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAWidth param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.width = [[customizedValue lastObject] floatValue];
        if (reverse) {
            self.originalRect = CGRectMake(self.originalRect.origin.x, self.originalRect.origin.y, param.width, self.originalRect.size.width);
        }
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    } else if (param.width != CGFLOAT_MAX) {
        [self addChangeWidthAnimationToQueue:queue withWidth:param.width reverse:reverse];
    }
}

- (void)addChangeWidthAnimationToQueue:(YYAnimatorQueue *)queue withWidth:(CGFloat)width reverse:(BOOL)reverse
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.width"];
    if (reverse) {
        [self changeWidthAnimationCompletionWithWidth:width reverse:NO];
        width = self.originalRect.size.width;
    }
    sizeAnimation.fromValue = @(self.layer.bounds.size.width);
    sizeAnimation.toValue = @(MAX(width, 0));
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

- (void)addChangeHeightAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAHeight] offset:0 reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.height"];
        sizeAnimation.customizedValues = customizedValue;
        sizeAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAHeight param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.height = [[customizedValue lastObject] floatValue];
        if (reverse) {
            self.originalRect = CGRectMake(self.originalRect.origin.x, self.originalRect.origin.y, self.originalRect.size.width, param.height);
        }
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    } else if (param.height != CGFLOAT_MAX) {
        [self addChangeHeightAnimationToQueue:queue withHeight:param.height reverse:reverse];
    }
}

- (void)addChangeHeightAnimationToQueue:(YYAnimatorQueue *)queue withHeight:(CGFloat)height reverse:(BOOL)reverse
{
    YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.height"];
    if (reverse) {
        [self changeHeightAnimationCompletionWithHeight:height reverse:NO];
        height = self.originalRect.size.height;
    }
    sizeAnimation.fromValue = @(self.layer.bounds.size.height);
    sizeAnimation.toValue = @(MAX(height, 0));
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

- (void)addAdjustHeightAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAAdjustHeight] offset:self.layer.bounds.size.height reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.height"];
        sizeAnimation.customizedValues = customizedValue;
        sizeAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAAdjustHeight param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.adjustHeight = [[customizedValue lastObject] floatValue] - self.layer.bounds.size.height;
        if (reverse) {
            param.adjustHeight = -param.adjustHeight;
        }
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    } else if (param.adjustHeight != 0 && param.adjustHeight != CGFLOAT_MAX) {
        YYKeyframeAnimation *sizeAnimation = [self basicAnimationForKeyPath:@"bounds.size.height"];
        CGFloat height = param.adjustHeight;
        if (reverse) {
            [self adjustHeightAnimationCompletionWithHeight:height reverse:NO];
            height = -height;
        }
        sizeAnimation.fromValue = @(self.layer.bounds.size.height);
        sizeAnimation.toValue = @(MAX(self.layer.bounds.size.height + height, 0));
        [self addAnimation:sizeAnimation withAnimatorQueue:queue];
    }
}

- (void)adjustHeightAnimationCompletionWithHeight:(CGFloat)height reverse:(BOOL)reverse
{
    if (reverse) {
        height = -height;
    }
    
    CGRect bounds = CGRectMake(0, 0, self.layer.bounds.size.width, MAX(self.layer.bounds.size.height+height, 0));
    self.layer.bounds = bounds;
}

- (void)addRotationZAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYARotateAngle] offset:0 reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *rotationAnimation = [self basicAnimationForKeyPath:@"transform.rotation.z"];
        NSMutableArray *angles = [NSMutableArray arrayWithCapacity:customizedValue.count];
        [customizedValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [angles addObject:@(YYAngle2Rad([obj doubleValue]))];
        }];
        rotationAnimation.customizedValues = angles;
        rotationAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYARotateAngle param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.rotateAngle = [[customizedValue lastObject] floatValue];
        if (reverse) {
            self.originalAngle = [[angles lastObject] floatValue];
        }
        [self addAnimation:rotationAnimation withAnimatorQueue:queue];
    } else if (param.rotateAngle != CGFLOAT_MAX) {
        YYKeyframeAnimation *rotationAnimation = [self basicAnimationForKeyPath:@"transform.rotation.z"];
        CGFloat angle = param.rotateAngle;
        CGFloat targetRotation = YYAngle2Rad(angle);
        CGFloat originalRotation = self.originalAngle;
        if (reverse) {
            [self rotationZAnimationWithAngle:(-angle) reverse:NO];
            originalRotation = targetRotation;
            targetRotation = self.originalAngle;
        }
        rotationAnimation.fromValue = @(originalRotation);
        rotationAnimation.toValue = @(targetRotation);
        [self addAnimation:rotationAnimation withAnimatorQueue:queue];
    }
}

- (void)rotationZAnimationWithAngle:(float)angle reverse:(BOOL)reverse
{
    CGFloat currentScale = [[self.layer valueForKeyPath: @"transform.scale.x"] floatValue];
    CATransform3D scaleTransform = CATransform3DMakeScale(currentScale, currentScale, 1.0);
    CGFloat finalAngle = reverse ? self.originalAngle : YYAngle2Rad(angle);
    self.layer.transform = CATransform3DRotate(scaleTransform, finalAngle, 0, 0, 1);
}

- (void)addAlphaAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAAlpha] offset:0 reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *alphaAnimation = [self basicAnimationForKeyPath:@"opacity"];
        alphaAnimation.customizedValues = customizedValue;
        alphaAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAAlpha param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.alpha = [[customizedValue lastObject] floatValue];
        if (reverse) {
            self.originalAlpha = param.alpha;
        }
        [self addAnimation:alphaAnimation withAnimatorQueue:queue];
    } else if (param.alpha >= 0) {
        YYKeyframeAnimation *alphaAnimation = [self basicAnimationForKeyPath:@"opacity"];
        CGFloat alpha = param.alpha;
        if (reverse) {
            [self alphaAnimationCompletionWithAlpha:alpha reverse:NO];
            alpha = self.originalAlpha;
        }
        alphaAnimation.fromValue = @(self.layer.opacity);
        alphaAnimation.toValue = @(alpha);
        [self addAnimation:alphaAnimation withAnimatorQueue:queue];
    }
}

- (void)alphaAnimationCompletionWithAlpha:(CGFloat)alpha reverse:(BOOL)reverse
{
    if (reverse) {
        alpha = self.originalAlpha;
    }
    self.layer.opacity = alpha;
}

- (void)addScaleAnimationToQueue:(YYAnimatorQueue *)queue withParam:(YYAnimationParams *)param reverse:(BOOL)reverse
{
    NSArray *customizedValue = [YYAnimationParams numValuesFromParam:[param.customizedParamData objectForKey:YYAScale] offset:0 reverse:reverse];
    if (customizedValue.count > 1) {
        YYKeyframeAnimation *scaleAnimation = [self basicAnimationForKeyPath:@"transform.scale"];
        scaleAnimation.customizedValues = customizedValue;
        scaleAnimation.customizedKeyTimes = [YYAnimationParams customizedTimesForKey:YYAScale param:param.customizedParamData animDuration:[queue currentGroupAnimationDuration] reverse:reverse];
        param.scale = [[customizedValue lastObject] floatValue];
        [self addAnimation:scaleAnimation withAnimatorQueue:queue];
        if (reverse) {
            self.originalScale = param.scale;
        }
    } else if (param.scale >= 0) {
        YYKeyframeAnimation *scaleAnimation = [self basicAnimationForKeyPath:@"transform.scale"];
        CGFloat scale = param.scale;
        if (reverse) {
            [self scaleAnimationCompletionWithScale:scale reverse:NO];
            scale = self.originalScale;
        }
        CGFloat currentScale = [[self.layer valueForKeyPath: @"transform.scale.x"] floatValue];
        scaleAnimation.fromValue = @(currentScale);
        scaleAnimation.toValue = @(scale);
        [self addAnimation:scaleAnimation withAnimatorQueue:queue];
    }
}

- (void)scaleAnimationCompletionWithScale:(CGFloat)scale reverse:(BOOL)reverse
{
    if (reverse) {
        scale = self.originalScale;
    }
    CGFloat currentScale = [[self.layer valueForKeyPath: @"transform.scale.x"] floatValue];
    if (currentScale == 0) {
        CATransform3D transform = self.layer.transform;
        CGFloat originalRotation = atan2(transform.m12, transform.m11);
        CATransform3D zRotation = CATransform3DMakeRotation(originalRotation, 0, 0, 1.0);
        self.layer.transform = CATransform3DScale(zRotation, scale, scale, 1.0);
    } else {
        CGFloat targetScale = scale / currentScale;
        self.layer.transform = CATransform3DScale(self.layer.transform, targetScale, targetScale, 1.0);
    }
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
