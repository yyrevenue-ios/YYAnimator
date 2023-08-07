//
//  YYViewController.m
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import "YYViewController.h"
#import "UIView+TweenStudio.h"
#import "YYAnimator_Example-Swift.h"
#import <Masonry/Masonry.h>
#import "YYEntranceListController.h"


@interface YYViewController ()

@property (nonatomic, strong) UIView *animatorView;
@property (nonatomic, strong) UIView *animatorView2;
@property (nonatomic, strong) UIButton *viewAnimatorBtn;
@property (nonatomic, strong) UILabel *label;


@end

@implementation YYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _animatorView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 35, 190, 70, 70)];
    _animatorView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_animatorView];
    
    _animatorView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 35, 520, 70, 70)];
    _animatorView2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_animatorView2];
    
    
    // UIView Animator Btn
    _viewAnimatorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 83, self.view.bounds.size.width, 83)];
    
    [_viewAnimatorBtn setBackgroundColor:[UIColor yellowColor]];
    [_viewAnimatorBtn setTitle:@"StartAnimation" forState:UIControlStateNormal];
    [_viewAnimatorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_viewAnimatorBtn];
    [_viewAnimatorBtn addTarget:self action:@selector(viewAnimatorBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view2];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.width.height.equalTo(@100);
        make.top.equalTo(@100);
    }];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 100, 50)];
    self.label.text = @"100";
    self.label.textColor = [UIColor blackColor];
    [self.view addSubview:self.label];
    
//
//    [self.animatorView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.trailing.equalTo(view2).offset(10);
//        make.centerX.equalTo(view2).offset(0);
//        make.width.height.equalTo(@100);
////        make.top.equalTo(view2.mas_bottom).offset(10);
//        make.centerY.equalTo(view2).offset(100);
//    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        YYAnimatorCountingNumberData *data = [[YYAnimatorCountingNumberData alloc] init];
//        data.fromValue = 0;
//        data.toValue = 100;
//        data.numberFormatBlock = ^NSString * _Nonnull(double numberValue) {
//            NSString *str = [NSString stringWithFormat:@"%.2f", numberValue];
//            return str;
//        };
//        self.label.yya_to(2, @{YYACountingNumberData:data});
////        self.label.yya_to(2, @{YYACountingNumberValue: @20});
//    });
}


- (void)viewAnimatorBtnDidClicked:(UIButton *)sender
{
    self.animatorView.yya_add(1, @{YYAScale: @0.5});
    self.animatorView.yya_add(1, @{YYAMoveX: @50});
    [self.animatorView playAnimations];
    
    YYAnimatorCountingNumberData *data = [[YYAnimatorCountingNumberData alloc] init];
    data.fromValue = 0;
    data.toValue = 100;
    int showNumLength = 1;
    data.numberFormatBlock = ^NSString * _Nonnull(double numberValue) {
       int value = ceilf(powf(10, showNumLength) * numberValue);
       return [NSString stringWithFormat:@"%0.1f", value / powf(10, showNumLength)];
    };
    self.label.yya_to(10, @{YYACountingNumberData : data});
}

- (IBAction)swiftBtnClicked:(id)sender {
    YYTestViewController *vc = [[YYTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self.view updateConstraintsIfNeeded];
    
}

- (IBAction)demoListBtnClicked:(id)sender {
    YYEntranceListController *vc = [[YYEntranceListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

