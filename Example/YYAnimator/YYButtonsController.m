//
//  YYButtonsController.m
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/28.
//  Copyright © 2023 8474644. All rights reserved.
//

#import "YYButtonsController.h"
#import <Masonry/Masonry.h>

@interface YYButtonsController ()

@end

@implementation YYButtonsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupButtons];
}

- (void)clickFrom:(id)sender
{
}

- (void)clickTo:(id)sender
{
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
