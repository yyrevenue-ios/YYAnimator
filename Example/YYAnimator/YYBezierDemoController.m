//
//  YYBezierDemoController.m
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/28.
//  Copyright © 2023 8474644. All rights reserved.
//

#import "YYBezierDemoController.h"
#import "UIView+TweenStudio.h"

@interface YYBezierDemoController ()

@property (nonatomic, strong) UIView *throughRippleView;
@property (nonatomic, strong) NSMutableArray *throughRipplePoints;

@property (nonatomic, strong) UIView *quadRippleView;
@property (nonatomic, strong) NSMutableArray *quadRipplePoints;

@property (nonatomic, strong) UIView *cubicRippleView;
@property (nonatomic, strong) NSMutableArray *cubicRipplePoints;

@property (nonatomic, strong) UIView *playView;

@end

@implementation YYBezierDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat startPoint1 = 120;
    self.throughRippleView = [self playViewWithRect:CGRectMake(0, startPoint1 - 5, 10, 10)];
    
    CGFloat startPoint2 = 240;
    self.quadRippleView = [self playViewWithRect:CGRectMake(0, startPoint2 - 5, 10, 10)];
    
    CGFloat startPoint3 = 360;
    self.cubicRippleView = [self playViewWithRect:CGRectMake(0, startPoint3 - 5, 10, 10)];
    
    CGSize fullSize = [UIScreen mainScreen].bounds.size;
    self.throughRipplePoints = [NSMutableArray array];
    self.quadRipplePoints = [NSMutableArray array];
    self.cubicRipplePoints = [NSMutableArray array];
    
    for (int index = 0; index < 10; index++) {
        NSString *startP = [NSString stringWithFormat:@"%@,%@", @(index / 9.0 * fullSize.width), @(startPoint1 + (index % 2 ? 60 : 0))];
        [self.throughRipplePoints addObject:startP];
        
        startP = [NSString stringWithFormat:@"%@,%@", @(index / 9.0 * fullSize.width), @(startPoint2 + (index % 2 ? 60 : 0))];
        [self.quadRipplePoints addObject:startP];
        
        startP = [NSString stringWithFormat:@"%@,%@", @(index / 9.0 * fullSize.width), @(startPoint3 + (index % 2 ? 60 : 0))];
        [self.cubicRipplePoints addObject:startP];
    }
    
    [self.quadRipplePoints addObject:[NSString stringWithFormat:@"%@,%@", @(10 / 9.0 * fullSize.width), @(startPoint2)]];
    [self pathLayer].path = [YYAnimationParams bezierFromParam:self.throughRipplePoints option:YYBezierOptionThrough].CGPath;
    [self pathLayer].path = [YYAnimationParams bezierFromParam:self.quadRipplePoints option:YYBezierOptionQuad].CGPath;
    [self pathLayer].path = [YYAnimationParams bezierFromParam:self.cubicRipplePoints option:YYBezierOptionCubic].CGPath;
    
    self.playView = [self playViewWithRect:CGRectMake(0, 608, 10, 10)];
}

- (UIView *)playViewWithRect:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.layer.cornerRadius = rect.size.width * 0.5;
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    return view;
}

- (CAShapeLayer *)pathLayer
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.view.layer addSublayer:shapeLayer];
    return shapeLayer;
}

#pragma mark - button
- (void)clickTo:(id)sender
{
    self.throughRippleView.yya_to(3, @{YYABezier : self.throughRipplePoints, YYABezierOption : @(YYBezierOptionThrough)});
    self.quadRippleView.yya_to(3, @{YYABezier : self.quadRipplePoints, YYABezierOption : @(YYBezierOptionQuad)});
    self.cubicRippleView.yya_to(3, @{YYABezier : self.cubicRipplePoints, YYABezierOption : @(YYBezierOptionCubic)});
    [self playViewAnimation:NO];
}

- (void)clickFrom:(id)sender
{
    self.throughRippleView.yya_from(3, @{YYABezier : self.throughRipplePoints, YYABezierOption : @(YYBezierOptionThrough)});
    self.quadRippleView.yya_from(3, @{YYABezier : self.quadRipplePoints, YYABezierOption : @(YYBezierOptionQuad)});
    self.cubicRippleView.yya_from(3, @{YYABezier : self.cubicRipplePoints, YYABezierOption : @(YYBezierOptionCubic)});
    [self playViewAnimation:YES];
}

- (void)playViewAnimation:(BOOL)isFrom
{
    self.playView.transform = CGAffineTransformIdentity;
    CGSize fullSize = [UIScreen mainScreen].bounds.size;
    NSString *randomP1 = [NSString stringWithFormat:@"%@,%@", @(120 + arc4random() % 50), @(550 + arc4random() % 50)];
    NSString *randomP2 = [NSString stringWithFormat:@"%@,%@", @(260 + arc4random() % 25), @(580 + arc4random() % 50)];
    NSArray *playPoints = @[@"0,625", @"60,320", @"90,620", randomP1, @"180, 520", randomP2, [NSString stringWithFormat:@"%@,625", @(fullSize.width)]];
    CAShapeLayer *layer = [self pathLayer];
    layer.path = [YYAnimationParams bezierFromParam:playPoints option:YYBezierOptionCubic].CGPath;
    __weak typeof(layer) weakLayer = layer;
    YYTweenAnimatorBlock block = self.playView.yya_to;
    if (isFrom) {
        block = self.playView.yya_from;
    }
    block(3, @{YYARotateAngle: @(60), YYABezier : playPoints, YYABezierOption : @(YYBezierOptionCubic), YYAPostAnimationBlock: ^{
        weakLayer.lineWidth = 0.5;
        weakLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    }});
}

@end
