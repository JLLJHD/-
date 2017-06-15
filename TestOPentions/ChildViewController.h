//
//  ChildViewController.h
//  TestOPentions
//
//  Created by 郑超杰 on 2017/6/15.
//  Copyright © 2017年 ButterJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,   copy) NSString *key;

@property (nonatomic,   copy) NSString *childKey;

@property (nonatomic,   copy) void(^closeButtonClickBlock)();

@property (nonatomic, assign) BOOL showBackButton;

@property (nonatomic,   copy) NSString *titleStr;

@end
