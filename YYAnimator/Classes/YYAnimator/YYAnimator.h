//
//  YYAnimator.h
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import <UIKit/UIKit.h>
#import "YYKeyframeAnimation.h"
#import "YYACountingLayer.h"

NS_ASSUME_NONNULL_BEGIN
@class YYAnimatorQueue,YYKeyframeAnimation;
@interface YYAnimator : NSObject

@property (nonatomic, weak, readonly) CALayer *layer;
@property (nonatomic, strong, readonly) YYACountingLayer *countingLayer;
@property (nonatomic, copy) dispatch_block_t finalCompeltion;
@property (nonatomic, assign) BOOL isPlaying;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)animatorWithView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view;

+ (instancetype)animatorWithLayer:(CALayer *)layer;
- (instancetype)initWithLayer:(CALayer *)layer NS_DESIGNATED_INITIALIZER;

- (void)addAnimationKeyframeFunctionBlock:(YYKeyframeAnimationFunctionBlock)functionBlock;

- (YYKeyframeAnimation *)basicAnimationForKeyPath:(NSString *)keypath;
- (void)addAnimation:(YYKeyframeAnimation *)animation withAnimatorQueue:(YYAnimatorQueue *)animatorQueue;

@end

NS_ASSUME_NONNULL_END
