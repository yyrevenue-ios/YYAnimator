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


@interface YYAnimDemoController ()

@property (nonatomic, strong) UIButton *fromButton;
@property (nonatomic, strong) UIButton *toButton;
@property (nonatomic, strong) YYDemoConfigData *data;
@property (nonatomic, strong) UIView *animAreaView;
@property (nonatomic, strong) UIView *animateView;
@property (nonatomic, strong) NSMutableArray *propInputArray;

@end

@implementation YYAnimDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupButtons];
}

- (void)setConfigData:(YYDemoConfigData *)data
{
    self.data = data;
    if (data) {
        self.navigationItem.title = data.title;
        [self setupInputs];
        [self createAnimateView];
    }
}

- (void)clickFrom:(id)sender
{
    NSDictionary *target = [self readValues:NO];
    self.animateView.yya_from(1, @{self.data.key : target.allValues[0]});
}

- (void)clickTo:(id)sender
{
    NSDictionary *target = [self readValues:NO];
    self.animateView.yya_to(1, @{self.data.key : target.allValues[0]});
}

- (NSDictionary *)readValues:(BOOL)isOrigin
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:self.propInputArray.count];
    for (YYAnimDemoInputView *inputView in self.propInputArray) {
        NSString *value = isOrigin ? [inputView originValue] : [inputView targetValue];
        [dict setValue:(value ? @([value floatValue]) : @0) forKey:inputView.propKey];
    }
    return dict;
}

#pragma mark - 动画的对象
- (void)createAnimateView
{
    if ([self.data.showContent hasPrefix:@"http"]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        NSURL *url = [NSURL URLWithString:self.data.showContent];
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
        UILabel *label = [[UILabel alloc] init];
        label.text = self.data.showContent;
        self.animateView = label;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        view.backgroundColor = [self colorFromHex:self.data.showContent];
        self.animateView = view;
    }
    [self.animAreaView addSubview:self.animateView];
}

- (UIColor *)colorFromHex:(NSString *)hex
{
    return [UIColor lightGrayColor];
}

#pragma mark - inputs
- (void)setupInputs
{
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 16;
    CGFloat height = 48;
    CGFloat gap = 12;
    self.propInputArray = [NSMutableArray arrayWithCapacity:self.data.targetProperty.count];
    for (NSString *propKey in self.data.targetProperty) {
        YYAnimDemoInputView *inputView = [YYAnimDemoInputView inputViewFor:propKey origin:self.data.originProperty[propKey] target:self.data.targetProperty[propKey]];
        [self.view addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(top);
            make.left.equalTo(self.view).offset(gap);
            make.right.equalTo(self.view).offset(-gap);
            make.height.equalTo(@(height));
        }];
        top += (height + gap);
        [self.propInputArray addObject:inputView];
    }
    self.animAreaView = [[UIView alloc] init];
    self.animAreaView.layer.borderColor = [UIColor colorWithRed:82/255.0 green:178/255.0 blue:205/255.0 alpha:1].CGColor;
    self.animAreaView.layer.borderWidth = 0.5;
    [self.view addSubview:self.animAreaView];
    [self.animAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(top);
        make.left.equalTo(self.view).offset(gap);
        make.right.equalTo(self.view).offset(-gap);
        make.bottom.equalTo(self.fromButton.mas_top).offset(-gap);
    }];
}

#pragma mark - buttons

- (void)setupButtons
{
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    UIColor *color = [UIColor colorWithRed:82/255.0 green:178/255.0 blue:205/255.0 alpha:1];
    self.fromButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenBounds.width * 0.5, 72)];
    [self.fromButton setBackgroundColor:color];
    [self.fromButton setTitle:@"from" forState:UIControlStateNormal];
    [self.fromButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.fromButton];
    [self.fromButton addTarget:self action:@selector(clickFrom:) forControlEvents:UIControlEventTouchUpInside];
    [self.fromButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.equalTo(@(72));
    }];
    self.fromButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.fromButton.layer.borderWidth = 0.5;
    
    self.toButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenBounds.width * 0.5, 72)];
    [self.toButton setBackgroundColor:color];
    [self.toButton setTitle:@"to" forState:UIControlStateNormal];
    [self.toButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.toButton];
    [self.toButton addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];
    [self.toButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.equalTo(@(72));
    }];
    self.toButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.toButton.layer.borderWidth = 0.5;
}

@end
