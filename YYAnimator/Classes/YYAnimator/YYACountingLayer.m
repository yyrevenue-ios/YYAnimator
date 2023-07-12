//
//  YYACountingLayer.m
//  YYAnimator
//
//  Created by yezhicheng on 2023/1/12.
//

#import "YYACountingLayer.h"

NSString *const YYCountingAnimationKey = @"countingNumber";

@implementation YYACountingLayer
@dynamic numberLabel;
@dynamic countingNumber;
@dynamic startNumber;
@dynamic endNumber;
@dynamic numberFormatBlock;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:YYCountingAnimationKey]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.startNumber > self.endNumber) {
        if (self.countingNumber >= self.endNumber) {
            self.numberLabel.text = [NSString stringWithFormat:@"%.f",self.countingNumber];
            if (self.numberFormatBlock) {
                self.numberLabel.text = self.numberFormatBlock(self.countingNumber);
            }
        }
    } else {
        if (self.countingNumber > self.startNumber) {
            self.numberLabel.text = [NSString stringWithFormat:@"%.f",self.countingNumber];
            if (self.numberFormatBlock) {
                self.numberLabel.text = self.numberFormatBlock(self.countingNumber);
            }
        }
    }
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if (self.presentationLayer) {
        if ([event isEqualToString:YYCountingAnimationKey]) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:YYCountingAnimationKey];
            animation.fromValue = [self.presentationLayer valueForKey:YYCountingAnimationKey];
            return animation;
        }
    }
    return [super actionForKey:event];
}

@end
