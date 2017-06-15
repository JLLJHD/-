//
//  HDMultilevelSelectionView.h
//  TestOPentions
//
//  Created by 郑超杰 on 2017/6/15.
//  Copyright © 2017年 ButterJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMultilevelSelectionView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,   copy) NSString *childKey;

@property (nonatomic,   copy) NSString *Key;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) void(^selectFinishBlock)(id selectItem);

- (void)showInViewController:(UIViewController *)superViewController;
- (void)showInView:(UIViewController *)superViewController finishBlock:(void(^)())finishBlock;

- (void)dismiss;
- (void)dismissFinishBlock:(void(^)())finishBlock;

@end
