//
//  YYDemoConfigData.m
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/14.
//  Copyright © 2023 8474644. All rights reserved.
//

#import "YYDemoConfigData.h"
#import <objc/runtime.h>


@implementation YYDemoConfigData

+ (instancetype)dataFromConfigItem:(NSDictionary *)dict
{
    YYDemoConfigData *data = [[YYDemoConfigData alloc] init];
    unsigned int count;
    objc_property_t *property = class_copyPropertyList([YYDemoConfigData class], &count);
    for (int index = 0; index < count; index ++) {
        objc_property_t t = property[index];
        NSString *key = [NSString stringWithUTF8String:property_getName(t)];
        if ([dict objectForKey:key]) {
            [data setValue:[dict objectForKey:key] forKey:key];
        }
    }
    free(property);
    return data;
}

@end
