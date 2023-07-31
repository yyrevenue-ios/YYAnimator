//
//  YYButtonsController.h
//  YYAnimator_Example
//
//  Created by wangchunhong01 on 2023/7/28.
//  Copyright © 2023 8474644. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YYButtonsController : UIViewController

@property (nonatomic, strong) UIButton *fromButton;
@property (nonatomic, strong) UIButton *toButton;

- (void)clickFrom:(id)sender;
- (void)clickTo:(id)sender;

@end


