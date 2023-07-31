//
//  YYAnimatorQueue.m
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import "YYAnimatorQueue.h"
#import "YYAnimator.h"

@interface YYAnimatorQueue ()

@property (nonatomic, strong) NSMutableArray <YYAnimatorGroup *> *animatorGroups;
@property (nonatomic, copy) NSString *animationKey;
@property (nonatomic, strong) NSMutableArray <YYAnimationCompletionAction> *animationConstraintActions;

@end

@implementation YYAnimatorQueue

+ (instancetype)queueWithAnimator:(YYAnimator *)animator
{
    return [[self alloc] initWithAnimator:animator];
}

- (instancetype)initWithAnimator:(YYAnimator *)animator
{
    if (self = [super init]) {
        _animator = animator;
    }
    
    return self;
}

- (NSMutableArray<YYAnimatorGroup *> *)animatorGroups
{
    if (!_animatorGroups) {
        _animatorGroups = [NSMutableArray arrayWithObject:[YYAnimatorGroup groupWithAnimator:self.animator andAnimatorQueue:self]];
    }
    
    return _animatorGroups;
}

- (NSMutableArray<YYAnimationCompletionAction> *)animationConstraintActions {
    if (!_animationConstraintActions) {
        _animationConstraintActions = [NSMutableArray array];
    }
    
    return _animationConstraintActions;
}

- (void)updateCurrentTurnGroupAnimationsDuration:(NSTimeInterval)duration {
    [self.animatorGroups lastObject].animationDuration = duration;
}

// 执行动画，所以从左到右，取firstObject
- (void)animateWithAnimationKey:(NSString *)animationKey
{
    [[self.animatorGroups firstObject] animateWithAnimationKey:animationKey];
}

- (void)updateAnchorWithAction:(YYAnimationAssembleAction)action {
    [self.animatorGroups lastObject].anchorAssembleAction = action;
}

// 执行动画，上面的方法会触发这个方法执行，所以从左到右，取firstObject
- (void)addAnimation:(YYKeyframeAnimation *)animation
{
    [[self.animatorGroups firstObject] addAnimation:animation];
}

- (void)addAnimationFunctionBlock:(YYKeyframeAnimationFunctionBlock)functionBlock
{
    [[self.animatorGroups firstObject] addAnimationFunctionBlock:functionBlock];
}

// 设置动画，以最新的Group为目标，所以取lastObject
- (void)addAnimationAssembleAction:(YYAnimationAssembleAction)action
{
    [[self.animatorGroups lastObject] addAnimationAssembleAction:action];
}

- (void)appendAnimationAssembleAction:(YYAnimationAssembleAction)action
{
    [self.animatorGroups addObject:[YYAnimatorGroup groupWithAnimator:self.animator andAnimatorQueue:self]];
    [self addAnimationAssembleAction:action];
}

- (void)addAnimationCompletionAction:(YYAnimationCompletionAction)action
{
    [[self.animatorGroups lastObject] addAnimationCompletionAction:action];
}

- (void)addAnimationConstraintAction:(YYAnimationCompletionAction)action
{
    [self.animationConstraintActions addObject:action];
}

- (void)executeCompletionActions
{
    [[self.animatorGroups firstObject] executeCompletionActions];
}

- (void)executeConstraintActionsReverse:(BOOL)reverse
{
    for (YYAnimationCompletionAction action in self.animationConstraintActions) {
        action(self.animator, reverse);
    }
}

- (BOOL)isEmptiedAfterTryToRemoveCurrentTurnGroup
{
    if (self.animatorGroups.count) {
        [[self.animatorGroups firstObject] executePostGroupBlock];
        [self.animatorGroups removeObjectAtIndex:0];
    }
    
    if (self.animatorGroups.count) {
        return NO;
    } else {
        if (self.completeBlock) {
            self.completeBlock();
        }
        return YES;
    }
}

- (BOOL)shouldRemoveOnCompletion
{
    YYAnimatorGroup *group = [self.animatorGroups firstObject];
    if (group) {
        return group.shouldRemoveOnCompletion;
    }
    return YES;
}

- (NSString *)animationKey
{
    return [NSString stringWithFormat:@"%p_%@", self, @(self.animatorGroups.count)];
}

- (void)thenAfter:(NSTimeInterval)time
{
    [self updateCurrentTurnGroupAnimationsDuration:time];
    [self createNewGroup];
}

- (void)createNewGroup
{
    YYAnimatorGroup *group = [YYAnimatorGroup groupWithAnimator:self.animator andAnimatorQueue:self];
    [self.animatorGroups addObject:group];
}

- (void)repeat:(NSInteger)count andIsAnimation:(BOOL)isAnimation
{
    for (NSInteger index = 0; index < count - 1; index++) {
        YYAnimatorGroup *animatorGroup = [[self.animatorGroups lastObject] copy];
        [self.animatorGroups addObject:animatorGroup];
    }
    
    // isAnimation 判断是否还须继续添加动画组
    if (!isAnimation) {
        [self.animatorGroups addObject:[YYAnimatorGroup groupWithAnimator:self.animator andAnimatorQueue:self]];
    }
}

- (void)updateCurrentPreGroupAnimationBlock:(YYAnimatorGroupBlock)block
{
    [self.animatorGroups lastObject].preGroupBlock = block;
}

- (void)updateCurrentPostGroupAnimationBlock:(YYAnimatorGroupBlock)block
{
    [self.animatorGroups lastObject].postGroupBlock = block;
}

- (void)updateCurrentTurnGroupAnimationsDelay:(NSTimeInterval)delay
{
    [self.animatorGroups lastObject].animationDelay = delay;
}

- (void)updateCurrentTurnGroupIsReverse:(BOOL)reverse
{
    [self.animatorGroups lastObject].isReverse = reverse;
}

- (BOOL)isCurrentTurnGroupReverse
{
    return [self.animatorGroups lastObject].isReverse;
}

- (void)updateCurrentGroupSpringDamping:(CGFloat)dampingRatio initialVelocity:(CGFloat)initialVelocity options:(UIViewAnimationOptions)options
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:dampingRatio initialSpringVelocity:initialVelocity options:options animations:^{
        view.frame = CGRectMake(1, 0, 0, 0);
    } completion:nil];
    CASpringAnimation *springAnimation = [view.layer animationForKey:@"position"];
    YYSpringParams *params = [YYSpringParams new];
    params.mass = springAnimation.mass;
    params.stiffness = springAnimation.stiffness;
    params.initialVelocity = springAnimation.initialVelocity;
    params.damping = springAnimation.damping;
    [self.animatorGroups lastObject].springParams = params;
}

- (void)updateCountingNumberParams:(YYCountingNumberParams *)params
{
    [self.animatorGroups lastObject].countingNumberParams = params;
}

@end
