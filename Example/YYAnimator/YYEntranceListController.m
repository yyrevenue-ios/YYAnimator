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

NSString * const kCellIden = @"cellReuse";


@interface YYEntranceListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datalist;
@property (nonatomic, strong) NSMutableDictionary <NSString *, YYDemoConfigData *>*dataConfig;

@end

@implementation YYEntranceListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"列表";
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIden];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.datalist = @[YYAMoveX, YYAMoveY, YYAMoveXY, YYAAlpha, YYAScale, YYARotateAngle, YYASize, YYACenter, YYAFrame, YYAWidth, YYAHeight, YYAAdjustWidth, YYAAdjustHeight, YYAOriginX, YYAOriginY, YYAOrigin, YYACountingNumberData];
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
            YYDemoConfigData *data = [YYDemoConfigData dataFromConfigItem:[dict objectForKey:animId]];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIden forIndexPath:indexPath];
    if (cell)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *animId = [self.datalist objectAtIndex:indexPath.row];
        NSString *title = [[self.dataConfig objectForKey:animId] title];
        if (@available(iOS 14, *)) {
            UIListContentConfiguration *config = [UIListContentConfiguration subtitleCellConfiguration];
            config.prefersSideBySideTextAndSecondaryText = YES;
            config.secondaryTextProperties.color = [UIColor colorWithRed:10/255.0 green:118/255.0 blue:148/255.0 alpha:1];
            config.secondaryTextProperties.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            config.text = title.length > 0 ? title : animId;
            config.secondaryText = title.length > 0 ? animId : nil;
            cell.contentConfiguration = config;
        } else {
            cell.textLabel.text = animId;
            cell.detailTextLabel.text = title;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.datalist.count) {
        NSString *animId = [self.datalist objectAtIndex:indexPath.row];
        YYDemoConfigData *data = [self.dataConfig objectForKey:animId];
        if (data) {
            YYAnimDemoController *vc = [[YYAnimDemoController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc setConfigData:data];
        }
    }
}

@end
