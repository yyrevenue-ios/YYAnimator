//
//  YYDemoConfigData.h
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/14.
//  Copyright © 2023 8474644. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YYDemoConfigData : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *showContent;
@property (nonatomic, strong) NSDictionary *originProperty;
@property (nonatomic, strong) NSDictionary *targetProperty;
@property (nonatomic, strong) NSString *initialLayout;
@property (nonatomic, strong) NSString *option;
@property (nonatomic, strong) NSString *swiftKey;
@property (nonatomic, strong) NSString *customPropKey;
@property (nonatomic, strong) NSString *customSwiftPropKey;

+ (instancetype)dataFromConfigItem:(NSDictionary *)dict;

@end


