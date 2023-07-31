//
//  YYAnimDemoInputView.h
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/14.
//  Copyright © 2023 8474644. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YYAnimDemoInputView : UIView

+ (instancetype)inputViewFor:(NSString *)text value:(NSNumber *)value;
+ (instancetype)inputViewFor:(NSString *)text origin:(NSNumber *)origin target:(NSNumber *)target;

@property (nonatomic, strong) NSString *propKey;
- (NSString *)originValue;
- (NSString *)targetValue;

@end


