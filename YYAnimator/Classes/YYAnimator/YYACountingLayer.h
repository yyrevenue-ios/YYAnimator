//
//  YYACountingLayer.h
//  YYAnimator
//
//  Created by yezhicheng on 2023/1/12.
//

#import <QuartzCore/QuartzCore.h>

extern NSString * _Nonnull const YYCountingAnimationKey;

NS_ASSUME_NONNULL_BEGIN

@interface YYACountingLayer : CALayer

@property (nonatomic, weak) UILabel *numberLabel;
@property (nonatomic, assign) double countingNumber;
@property (nonatomic, assign) double startNumber;
@property (nonatomic, assign) double endNumber;
@property (nonatomic, copy) NSString *(^numberFormatBlock)(double numberValue);


@end

NS_ASSUME_NONNULL_END
