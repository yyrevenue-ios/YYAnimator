//
//  YYAnimDemoController.m
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/14.
//  Copyright © 2023 8474644. All rights reserved.
//

#import "YYAnimDemoController.h"
#import "YYDemoConfigData.h"
#import <Masonry/Masonry.h>
#import "YYAnimDemoInputView.h"
#import <YYAnimator/UIView+TweenStudio.h>


@interface NSDictionary (Safe)
@end

@implementation NSDictionary (Safe)

// 如果不存在此key, 就返回0
- (CGFloat)floatWithKey:(NSString *)key
{
    return [self floatWithKey:key or:0];
}

// 如果不存在此key, 就返回defaultValue
- (CGFloat)floatWithKey:(NSString *)key or:(CGFloat)defaultValue
{
    NSNumber *value = [self valueForKey:key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return defaultValue;
}

- (NSString *)ocValueForOrigin:(NSString *)origin
{
    for (NSString *key in self) {
        NSString *toReplace = [NSString stringWithFormat:@"\"%@\"", key];
        origin = [origin stringByReplacingOccurrencesOfString:toReplace withString:[[self valueForKey:key] stringValue]];
    }
    return origin;
}

- (NSString *)convertToCode:(NSString *)ocValue
{
    NSMutableString *codes = [NSMutableString string];
    for (NSString *key in self) {
        if ([key isEqualToString:@"time"]) {
            continue;
        } else if ([key isEqualToString:@"repeat"]) {
            if ([self floatWithKey:@"repeat"] > 1) {
                [codes appendFormat:@"repeat : %@,", @(ceilf([self floatWithKey:@"repeat"]))];
            }
        } else if ([key isEqualToString:@"delay"]) {
            if ([self floatWithKey:@"delay"] > 0) {
                [codes appendFormat:@"delay : %@,", [self valueForKey:key]];
            }
        } else {
            [codes appendFormat:@"%@ : %@ ,", key, ocValue ? ocValue : [self valueForKey:key]];
        }
    }
    NSString *result = [codes substringToIndex:(codes.length - 1)];
    return result;
}

@end

@interface YYAnimDemoController ()

@property (nonatomic, strong) YYDemoConfigData *data;
@property (nonatomic, strong) UIView *animAreaView;
@property (nonatomic, strong) UIView *placeHolderView;
@property (nonatomic, strong) UIView *animateView;
@property (nonatomic, strong) UITextView *codeView;
@property (nonatomic, strong) NSMutableArray *propInputArray;

@end

@implementation YYAnimDemoController


- (void)setConfigData:(YYDemoConfigData *)data
{
    self.data = data;
    if (data) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@： %@", data.title, data.key];
        [self setupViews];
        [self createAnimateView];
    }
}

#pragma mark - 点击执行动画

- (void)clickFrom:(id)sender
{
    [self resetAnimateView];
    
    NSDictionary *inputParam = [self readInputValuesIsOrigin:NO];
    NSTimeInterval animateTime = [inputParam floatWithKey:@"time" or:1];
    NSDictionary *animateParam = [self convertParamFromInput:inputParam];

    self.animateView.yya_from(animateTime, animateParam);
    
    [self updateCodeArea:YES time:animateTime inputParam:inputParam animateParam:animateParam];
}

- (void)clickTo:(id)sender
{
    [self resetAnimateView];
    
    NSDictionary *inputParam = [self readInputValuesIsOrigin:NO];
    NSTimeInterval animateTime = [inputParam floatWithKey:@"time" or:1];
    NSDictionary *animateParam = [self convertParamFromInput:inputParam];
    
    self.animateView.yya_to(animateTime, animateParam);
    
    [self updateCodeArea:NO time:animateTime inputParam:inputParam animateParam:animateParam];
}

#pragma mark - 读取参数输入框的值
- (NSDictionary *)readInputValuesIsOrigin:(BOOL)isOrigin
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:self.propInputArray.count];
    for (YYAnimDemoInputView *inputView in self.propInputArray) {
        NSString *value = isOrigin ? [inputView originValue] : [inputView targetValue];
        [dict setValue:(value ? @([value floatValue]) : nil) forKey:inputView.propKey];
    }
    return dict;
}

#pragma mark - 输入的参数 转为 yya_to yya_from接口的参数
/// 参数
- (NSDictionary *)convertParamFromInput:(NSDictionary *)target
{
    id singleValue;
    if ([self.data.key isEqualToString:YYAMoveXY] || [self.data.key isEqualToString:YYAOrigin]) {
        singleValue = [NSValue valueWithCGPoint:CGPointMake([target floatWithKey:@"x"], [target floatWithKey:@"y"])];
    }
    else if ([self.data.key isEqualToString:YYAFrame]) {
        singleValue = [NSValue valueWithCGRect:CGRectMake([target floatWithKey:@"x"], [target floatWithKey:@"y"], [target floatWithKey:@"width"], [target floatWithKey:@"height"])];
    }
    else if ([self.data.key isEqualToString:YYASize]) {
        singleValue = [NSValue valueWithCGSize:CGSizeMake([target floatWithKey:@"width"], [target floatWithKey:@"height"])];
    }
    else if ([self.data.key isEqualToString:YYACenter]) {
        singleValue = [NSValue valueWithCGPoint:CGPointMake([target floatWithKey:@"centerX"], [target floatWithKey:@"centerY"])];
    }
    else if ([self.data.key isEqualToString:YYACountingNumberData]) {
        YYAnimatorCountingNumberData *data = [[YYAnimatorCountingNumberData alloc] init];
        data.fromValue = [[self readInputValuesIsOrigin:YES] floatWithKey:@"value"];
        data.toValue = [[self readInputValuesIsOrigin:NO] floatWithKey:@"value"];
        int showNumLength = 2;
        NSString *originText = self.data.showContent;
        data.numberFormatBlock = ^NSString * _Nonnull(double numberValue) {
           int value = ceilf(powf(10, showNumLength) * numberValue);
           NSString *countText = [NSString stringWithFormat:@"%0.2f", value / powf(10, showNumLength)];
            return [originText stringByReplacingOccurrencesOfString:@"$value" withString:countText];
        };
        singleValue = data;
    }
    else {
        NSNumber *value = [target valueForKey:self.data.targetProperty.allKeys[0]];
        singleValue = value ? value : @(0);
    }
    NSDictionary *res = @{self.data.key : singleValue, YYARepeat : @([target floatWithKey:@"repeat" or:1]), YYADelay : @([target floatWithKey:@"delay"])};
    return res;
}

#pragma mark - 重置为origin状态
- (void)resetAnimateView
{
    self.animateView.transform = CGAffineTransformIdentity;
    NSDictionary *origin = [self readInputValuesIsOrigin:YES];
    CGRect initicalRect = [self initialRect];
    initicalRect.origin.x = [origin floatWithKey:@"x" or:initicalRect.origin.x];
    initicalRect.origin.y = [origin floatWithKey:@"y" or:initicalRect.origin.y];
    initicalRect.size.width = [origin floatWithKey:@"width" or:initicalRect.size.width];
    initicalRect.size.height = [origin floatWithKey:@"height" or:initicalRect.size.height];
    self.animateView.frame = initicalRect;
    self.placeHolderView.frame = initicalRect;
    self.animateView.alpha = [origin floatWithKey:@"alpha" or:1.0];
    if ([origin valueForKey:@"scale"]) {
        CGFloat scale = [origin floatWithKey:@"scale" or:1.0];
        self.animateView.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if ([origin valueForKey:@"rotation"]) {
        CGFloat angle = [origin floatWithKey:@"rotation" or:0] * 2 * M_PI;
        self.animateView.transform = CGAffineTransformRotate(self.animateView.transform, angle);
    }
}

#pragma mark - 更新对应代码

- (void)updateCodeArea:(BOOL)isFrom time:(NSTimeInterval)time inputParam:(NSDictionary *)inputParam animateParam:(NSDictionary *)animParam
{
    NSString *code = self.data.oCValue ? [animParam convertToCode:[inputParam ocValueForOrigin:self.data.oCValue]] : [animParam convertToCode:nil];
    self.codeView.text = [NSString stringWithFormat:@"self.animateView.yya_%@(%@, @{%@});", isFrom ? @"from" : @"to", @(time), code];
    CGFloat h = self.codeView.contentSize.height;
    [self.codeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];
}

#pragma mark - 动画的对象
- (void)createAnimateView
{
    if ([self.data.showContent hasPrefix:@"http"]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self initialRect]];
        __weak typeof(imageView) wView = imageView;
        NSURLSession *session = [NSURLSession sharedSession];
        [[session downloadTaskWithURL:[NSURL URLWithString:self.data.showContent] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:location.path];
            dispatch_async(dispatch_get_main_queue(), ^{
                wView.image = image;
            });
        }] resume];
        self.animateView = imageView;
    } else if (![self.data.showContent hasPrefix:@"#"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:[self initialRect]];
        label.clipsToBounds = NO;
        self.animateView = label;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:[self initialRect]];
        view.backgroundColor = [self colorFromHex:self.data.showContent];
        self.animateView = view;
    }
    [self.animAreaView addSubview:self.animateView];
    
    UIView *placeHolder = [[UIView alloc] initWithFrame:[self initialRect]];
    CAShapeLayer *border = [CAShapeLayer layer];
    border.bounds = placeHolder.bounds;
    border.position = CGPointMake(placeHolder.bounds.size.width * 0.5, placeHolder.bounds.size.height * 0.5);
    border.path = [UIBezierPath bezierPathWithRoundedRect:placeHolder.bounds cornerRadius:0].CGPath;
    border.lineWidth = 1.0;
    border.lineDashPhase = 0.1;
    border.lineDashPattern = @[@2, @2];
    border.fillColor = [UIColor clearColor].CGColor;
    border.strokeColor = [UIColor blueColor].CGColor;
    [placeHolder.layer addSublayer:border];
    self.placeHolderView = placeHolder;
    [self.animAreaView addSubview:placeHolder];
}

- (UIColor *)colorFromHex:(NSString *)hex
{
    if (hex.length == 7) {
        const char *rStr = [[hex substringWithRange:NSMakeRange(1, 2)] cStringUsingEncoding:NSUTF8StringEncoding];
        const char *gStr = [[hex substringWithRange:NSMakeRange(3, 2)] cStringUsingEncoding:NSUTF8StringEncoding];
        const char *bStr = [[hex substringWithRange:NSMakeRange(5, 2)] cStringUsingEncoding:NSUTF8StringEncoding];
        int r,g,b;
        sscanf(rStr, "%x", &r);
        sscanf(gStr, "%x", &g);
        sscanf(bStr, "%x", &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1];
    }
    return [UIColor lightGrayColor];
}

- (CGRect)initialRect
{
    CGRect frame = CGRectMake(0, 0, 40, 40);
    if ([self.data.initialLayout isEqualToString:@"center"]) {
        frame.origin = CGPointMake(CGRectGetWidth(self.animAreaView.bounds) * 0.5 - 20, CGRectGetHeight(self.animAreaView.bounds) * 0.5 - 20);
    }
    return frame;
}

#pragma mark - 说明 & 参数输入框 & 动画区
- (void)setupViews
{
    CGRect fullBounds = [UIScreen mainScreen].bounds;
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 16;
    if (self.data.ps.length > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, top, CGRectGetWidth(fullBounds) - 24, 0)];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.text = self.data.ps;
        [label sizeToFit];
        [self.view addSubview:label];
        top = CGRectGetMaxY(label.frame) + 12;
    }
    self.propInputArray = [NSMutableArray arrayWithCapacity:self.data.targetProperty.count];
    [self createOneInput:@"time" origin:@(1) target:nil topOffset:&top];
    if ([self.data.key isEqualToString:YYACountingNumberData])  {
        [self createOneInput:@"value" origin:[self.data.targetProperty valueForKey:@"fromValue"] target:[self.data.targetProperty valueForKey:@"toValue"] topOffset:&top];
    } else {
        for (NSString *propKey in self.data.targetProperty) {
            [self createOneInput:propKey origin:self.data.originProperty[propKey] target:self.data.targetProperty[propKey] topOffset:&top];
        }
    }
//    [self createOneInput:@"repeat" origin:@(1) target:nil topOffset:&top];
    [self createOneInput:@"delay" origin:@(0) target:nil topOffset:&top];
    
    self.animAreaView = [[UIView alloc] initWithFrame:CGRectMake(1, top, CGRectGetWidth(fullBounds) - 2, CGRectGetHeight(fullBounds) - top - 84)];
    self.animAreaView.layer.borderColor = [UIColor colorWithRed:82/255.0 green:178/255.0 blue:205/255.0 alpha:1].CGColor;
    self.animAreaView.layer.borderWidth = 1;
    [self.view addSubview:self.animAreaView];
    
    self.codeView = [[UITextView alloc] init];
    [self.view addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.fromButton.mas_top).offset(-2);
        make.height.equalTo(@(30));
    }];
    self.codeView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    self.codeView.adjustsFontForContentSizeCategory = YES;
    self.codeView.editable = NO;
    
    [self.animAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(top);
        make.left.equalTo(self.view).offset(1);
        make.right.equalTo(self.view).offset(-1);
        make.bottom.equalTo(self.codeView.mas_top).offset(-0);
    }];
}

- (void)createOneInput:(NSString *)key origin:(NSNumber *)origin target:(NSNumber *)target topOffset:(CGFloat *)top
{
    CGFloat height = 48;
    CGFloat gap = 12;
    YYAnimDemoInputView *inputView = target ? [YYAnimDemoInputView inputViewFor:key origin:origin target:target] : [YYAnimDemoInputView inputViewFor:key value:origin];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(*top);
        make.left.equalTo(self.view).offset(gap);
        make.right.equalTo(self.view).offset(-gap);
        make.height.equalTo(@(height));
    }];
    *top += 60;
    [self.propInputArray addObject:inputView];
}


@end
