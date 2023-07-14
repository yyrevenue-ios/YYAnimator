//
//  YYAnimDemoInputView.m
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/14.
//  Copyright © 2023 8474644. All rights reserved.
//

#import "YYAnimDemoInputView.h"
#import <Masonry/Masonry.h>

@interface YYAnimDemoInputView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *originTextField;
@property (nonatomic, strong) UITextField *targetTextField;

@end

@implementation YYAnimDemoInputView

+ (instancetype)inputViewFor:(NSString *)text origin:(NSNumber *)origin target:(NSNumber *)target
{
    YYAnimDemoInputView *view = [[YYAnimDemoInputView alloc] init];
    view.propKey = text;
    [view buildUI];
    view.originTextField.text = [origin stringValue];
    view.targetTextField.text = [target stringValue];
    return view;
}

- (NSString *)originValue
{
    return self.originTextField.text;
}

- (NSString *)targetValue
{
    return self.targetTextField.text;
}

- (void)buildUI
{
    self.layer.borderColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.propKey;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
    [nameLabel sizeToFit];
    CGFloat width = MAX(48, CGRectGetWidth(nameLabel.bounds));
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-0);
        make.width.equalTo(@(width));
    }];
    self.label = nameLabel;
//    UIView *line = [self createSeparateLine:self.label];
    self.originTextField = [self createInputField:@"origin" placeHolder:@"初始值" lastView:self.label];
    UIView *line = [self createSeparateLine:self.originTextField];
    self.targetTextField = [self createInputField:@"target" placeHolder:@"目标值" lastView:line];
}

- (UIView *)createSeparateLine:(UIView *)leftView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 48)];
    view.backgroundColor = [UIColor colorWithRed:82/255.0 green:178/255.0 blue:205/255.0 alpha:1];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(1));
        make.left.equalTo(leftView.mas_right);
    }];
    return view;
}

- (UITextField *)createInputField:(NSString *)title placeHolder:(NSString *)placeholder lastView:(UIView *)view
{
    UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    inputField.textAlignment = NSTextAlignmentCenter;
    inputField.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [self addSubview:inputField];
    inputField.textColor = [UIColor colorWithRed:10/255.0 green:118/255.0 blue:148/255.0 alpha:1];
    inputField.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    inputField.placeholder = placeholder;
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_right).offset(1);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5).offset(-26);
    }];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = title;
    leftLabel.font = [UIFont systemFontOfSize:10];
    leftLabel.textColor = [UIColor darkGrayColor];
    [leftLabel sizeToFit];
    [self addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(inputField);
    }];
    return inputField;
}

@end
