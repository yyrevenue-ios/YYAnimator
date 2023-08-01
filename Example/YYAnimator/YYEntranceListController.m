//
//  YYEntranceListController.m
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/13.
//  Copyright © 2023 8474644. All rights reserved.
//

#import "YYEntranceListController.h"
#import <Masonry/Masonry.h>
#import <YYAnimator/UIView+TweenStudio.h>
#import "YYDemoConfigData.h"
#import "YYAnimDemoController.h"
#import "YYBezierDemoController.h"


NSString * const kCellIden = @"cellReuse";

@interface YYEntranceHeadView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, copy) dispatch_block_t clickBlock;
@end

@implementation YYEntranceHeadView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 14, 80, 21)];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        UIImage *icon = [UIImage imageNamed:@"arrow_right"];
        self.iconView = [[UIImageView alloc] initWithImage:icon];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconView];
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@(14));
            make.height.equalTo(@(14));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSeaction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)updateTitle:(NSString *)title foldState:(BOOL)folded
{
    self.titleLabel.text = title;
    self.iconView.image = folded ? [UIImage imageNamed:@"arrow_right"] : [UIImage imageNamed:@"arrow_down"];
}

- (void)tapOnSeaction:(id)sender
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end


@interface YYEntranceListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *datalist;
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSMutableDictionary <NSString *, YYDemoConfigData *>*dataConfig;

@property (nonatomic, strong) NSMutableDictionary *foldState;
@property (nonatomic, strong) NSMutableDictionary <NSString *, YYEntranceHeadView *>*headViewCache;

@end

@implementation YYEntranceListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"列表";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIden];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 44;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.foldState = [NSMutableDictionary dictionary];
    self.datalist = @{
        @"位置": @[YYAMoveX,YYAOriginX, YYAMoveY,YYAOriginY, YYAMoveXY, YYAOrigin, YYACenter, YYAFrame],
        @"宽高": @[YYASize,  YYAWidth, YYAHeight, YYAAdjustWidth, YYAAdjustHeight]
    };
    self.sectionList = @[YYABezier, YYAAlpha, YYAScale, YYARotateAngle, YYACountingNumberData, @"位置", @"宽高"];
    [self loadDataConfig];
}

- (void)loadDataConfig
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        NSMutableDictionary *convertedDict = [NSMutableDictionary dictionaryWithCapacity:dict.count];
        for (NSString *animId in dict.allKeys) {
            YYDemoConfigData *data = [YYDemoConfigData dataFromConfigItem:[dict valueForKey:animId]];
            if (data.key != nil) {
                [convertedDict setObject:data forKey:data.key];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataConfig = convertedDict;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sectionList objectAtIndex:section];
    NSArray *sublist = [self.datalist valueForKey:key];
    if (!sublist || [[self.foldState valueForKey:key] boolValue]) { //收起状态
        return 0;
    }
    return sublist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIden forIndexPath:indexPath];
    if (cell)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *key = [self.sectionList objectAtIndex:indexPath.section];
        NSArray *sublist = [self.datalist valueForKey:key];
        if (sublist && sublist.count > 0) {
            NSString *animId = [sublist objectAtIndex:indexPath.row];
            NSString *title = [[self.dataConfig objectForKey:animId] title];
            if (@available(iOS 14, *)) {
                UIListContentConfiguration *config = [UIListContentConfiguration subtitleCellConfiguration];
                config.prefersSideBySideTextAndSecondaryText = YES;
                config.secondaryTextProperties.color = [UIColor colorWithRed:10/255.0 green:118/255.0 blue:148/255.0 alpha:1];
                config.secondaryTextProperties.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
                config.text = title.length > 0 ? title : animId;
                config.secondaryText = title.length > 0 ? animId : nil;
                cell.contentConfiguration = config;
                return cell;
            }
        }
        NSString *title = [[self.dataConfig valueForKey:key] title];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = title;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.sectionList objectAtIndex:section];
    return [self sectionView:key index:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < self.sectionList.count) {
        NSString *key = [self.sectionList objectAtIndex:indexPath.section];
        NSArray *sublist = [self.datalist valueForKey:key];
        if (sublist.count > 0) {
            [self showDetailPage:[sublist objectAtIndex:indexPath.row]];
        }
    }
}

- (void)showDetailPage:(NSString *)animId
{
    if ([animId isEqualToString:YYABezier]) {
        YYBezierDemoController *vc = [[YYBezierDemoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    YYDemoConfigData *data = [self.dataConfig objectForKey:animId];
    if (data) {
        YYAnimDemoController *vc = [[YYAnimDemoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc setConfigData:data];
    }
}

- (UIView *)sectionView:(NSString *)key index:(NSInteger)index
{
    YYEntranceHeadView *headView = [self.headViewCache valueForKey:key];
    if (!headView) {
        headView = [[YYEntranceHeadView alloc] init];
        [self.headViewCache setValue:headView forKey:key];
    }
    NSArray *sublist = [self.datalist valueForKey:key];
    headView.backgroundColor = sublist.count == 0 ? [UIColor whiteColor] :  [UIColor colorWithRed:239/255.0 green:238/255.0 blue:248/255.0 alpha:1];
    BOOL folded = [[self.foldState objectForKey:key] boolValue];
    [headView updateTitle:key foldState:(sublist == 0) ? YES : folded];
    __weak typeof(self) wself = self;
    headView.clickBlock = ^{
        [wself tapOnSection:key];
    };
    return headView;
}

- (void)tapOnSection:(NSString *)key
{
    if ([self.datalist valueForKey:key]) {
        BOOL folded = [[self.foldState valueForKey:key] boolValue];
        [self.foldState setValue:@(!folded) forKey:key];
        [self.tableView reloadData];
    } else {
        [self showDetailPage:key];
    }
}

@end
