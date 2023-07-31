//
//  YYAnimatorGroup.m
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import "YYAnimatorGroup.h"
#import "YYAnimator.h"

@implementation YYSpringParams
@end

@implementation YYCountingNumberParams
@end

@interface YYAnimatorGroup ()

@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@property (nonatomic, strong) NSMutableArray <YYKeyframeAnimation *> *animations;
@property (nonatomic, strong) NSMutableArray <YYAnimationAssembleAction> *animationAssembleActions;
@property (nonatomic, strong) NSMutableArray <YYAnimationCompletionAction> *animationCompletionActions;

@end

@implementation YYAnimatorGroup

+ (instancetype)groupWithAnimator:(YYAnimator *)animator andAnimatorQueue:(YYAnimatorQueue *)animatorQueue {
    return [[self alloc] initWithAnimator:animator andAnimatorQueue:animatorQueue];
}

- (instancetype)initWithAnimator:(YYAnimator *)animator andAnimatorQueue:(YYAnimatorQueue *)animatorQueue {
    if (self = [super init]) {
        _animator = animator;
        _animatorQueue = animatorQueue;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    typeof(self) copYYelf = [[self.class allocWithZone:zone] initWithAnimator:self.animator andAnimatorQueue:self.animatorQueue];
    copYYelf.animationDelay = self.animationDelay;
    copYYelf.isReverse = self.isReverse;
    copYYelf.animationDuration = self.animationDuration;
    copYYelf.preGroupBlock = [self.preGroupBlock copy];
    copYYelf.postGroupBlock = [self.postGroupBlock copy];
    copYYelf.animationGroup = [self.animationGroup copy];
    copYYelf.animations = [[NSMutableArray alloc] initWithArray:self.animations copyItems:YES];
    copYYelf.animationAssembleActions = [[NSMutableArray alloc] initWithArray:self.animationAssembleActions copyItems:YES];
    copYYelf.animationCompletionActions = [[NSMutableArray alloc] initWithArray:self.animationCompletionActions copyItems:YES];
    copYYelf.anchorAssembleAction = [self.anchorAssembleAction copy];
    
    return copYYelf;
}

- (CAAnimationGroup *)animationGroup
{
    if (!_animationGroup) {
        _animationGroup = [CAAnimationGroup animation];
    }
    return _animationGroup;
}

- (NSMutableArray<YYKeyframeAnimation *> *)animations
{
    if (!_animations) {
        _animations = [NSMutableArray array];
    }
    return _animations;
}

- (NSMutableArray<YYAnimationAssembleAction> *)animationAssembleActions
{
    if (!_animationAssembleActions) {
        _animationAssembleActions = [NSMutableArray array];
    }
    return _animationAssembleActions;
}

- (NSMutableArray<YYAnimationCompletionAction> *)animationCompletionActions {
    if (!_animationCompletionActions) {
        _animationCompletionActions = [NSMutableArray array];
    }
    
    return _animationCompletionActions;
}

- (void)addAnimation:(YYKeyframeAnimation *)animation
{
    [self.animations addObject:animation];
}

- (void)addAnimationFunctionBlock:(YYKeyframeAnimationFunctionBlock)functionBlock
{
    for (YYKeyframeAnimation *animation in self.animations) {
        animation.functionBlock = functionBlock;
    }
}

// AssembleAction是用于创建KeyAnimation的，只在执行到当前group的时候，才会通过block回调进行创建
// 因为创建好KeyAnimation后，才会去计算对应的Values，所以也可以同构AssembleAction修改当前group的functionBlock，用于后面values的计算
- (void)addAnimationAssembleAction:(YYAnimationAssembleAction)action
{
    [self.animationAssembleActions addObject:action];
}

- (void)addAnimationCompletionAction:(YYAnimationCompletionAction)action
{
    [self.animationCompletionActions addObject:action];
}

- (void)animateWithAnimationKey:(NSString *)animationKey
{
    // 执行动画组合前执行的block
    if (self.preGroupBlock) {
        self.preGroupBlock();
    }
    
    // 进行Anchor的修改
    if (self.anchorAssembleAction) {
        self.anchorAssembleAction(self.animator, self.animatorQueue, NO);
    }
    
    self.animationGroup.duration = self.animationDuration;
    
    // 1. 创建当前group的所有KeyFrameAnimation
    // 2. 修改functionBlock（easeIn, easeout等） ,functionBlock则是用于计算过程值的, 因为下面才会计算过程值，所以这里修改functionBlock对后面所有的keyframe的values的计算都生效
    for (YYAnimationAssembleAction action in self.animationAssembleActions) {
        action(self.animator, self.animatorQueue, self.isReverse);
    }
    
    for (YYKeyframeAnimation *animation in self.animations) {
        animation.duration = self.animationGroup.duration;
        if (animation.customizedValues.count > 0) {
            animation.values = [animation.customizedValues copy];
            animation.keyTimes = [animation.customizedKeyTimes copy];
            self.animationGroup.removedOnCompletion = NO;
            self.animationGroup.fillMode = kCAFillModeForwards;
        } else {
            [animation calculate];
        }
    }
    
    self.animationGroup.beginTime = CACurrentMediaTime() + self.animationDelay;
    
    CABasicAnimation *baseAnimation = [self processCountingNumberAnimationWithKey:YYCountingAnimationKey];
    if (baseAnimation) {
        self.animator.countingLayer.startNumber = self.countingNumberParams.fromValue;
        self.animator.countingLayer.endNumber = self.countingNumberParams.toValue;
        self.animator.countingLayer.numberFormatBlock = self.countingNumberParams.numberFormatBlock;
        [self.animator.countingLayer addAnimation:baseAnimation forKey:YYCountingAnimationKey];
    }
    
    self.animationGroup.animations = [self processedAnimation];
    
    [self.animator.layer addAnimation:self.animationGroup forKey:animationKey];
}

- (void)executeCompletionActions
{
    NSTimeInterval delay = MAX(self.animationGroup.beginTime - CACurrentMediaTime(), 0.0);
    BOOL reverse = self.isReverse;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (YYAnimationCompletionAction action in self.animationCompletionActions) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            action(self.animator, reverse);
            [CATransaction commit];
        }
    });
}

- (void)executePostGroupBlock
{
    if (self.postGroupBlock) {
        self.postGroupBlock();
    }
}

- (BOOL)shouldRemoveOnCompletion
{
    return self.animationGroup.isRemovedOnCompletion;
}

- (NSArray<CAAnimation *> *)processedAnimation
{
    if (!self.springParams) {
        return self.animations;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.animations.count];
    for (YYKeyframeAnimation *keyFrameAnimation in self.animations) {
        CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:keyFrameAnimation.keyPath];
        animation.fromValue = keyFrameAnimation.fromValue;
        animation.toValue = keyFrameAnimation.toValue;
        animation.mass = self.springParams.mass;
        animation.stiffness = self.springParams.stiffness;
        animation.damping = self.springParams.damping;
        animation.initialVelocity = self.springParams.initialVelocity;
        [array addObject:animation];
    }
    return array;
}

- (CABasicAnimation *)processCountingNumberAnimationWithKey:(NSString *)key
{
    __block YYKeyframeAnimation *keyFrameAnimation;
    [self.animations enumerateObjectsUsingBlock:^(YYKeyframeAnimation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.keyPath isEqualToString:key]) {
            keyFrameAnimation = obj;
        }
    }];
    if (!keyFrameAnimation) {
        return nil;
    }
    if (!self.animator.countingLayer) {
        NSAssert(NO, @"counting number view must UILabel view");
        return nil;
    }
    [self.animations removeObject:keyFrameAnimation];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    animation.fromValue = keyFrameAnimation.fromValue;
    animation.toValue = keyFrameAnimation.toValue;
    animation.duration = self.animationDuration;
    animation.beginTime = CACurrentMediaTime() + self.animationDelay;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    return animation;
}

@end
