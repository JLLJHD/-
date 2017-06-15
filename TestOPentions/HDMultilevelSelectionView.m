//
//  HDMultilevelSelectionView.m
//  TestOPentions
//
//  Created by 郑超杰 on 2017/6/15.
//  Copyright © 2017年 ButterJie. All rights reserved.
//

#import "HDMultilevelSelectionView.h"
#import "ChildViewController.h"

#define kIphone6Width 375.0
#define SScreen_Width [UIScreen mainScreen].bounds.size.width
#define SScreen_Height [UIScreen mainScreen].bounds.size.height
#define kFit(x) (SScreen_Width*((x)/kIphone6Width))

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


@interface HDMultilevelSelectionView ()

@property (nonatomic, strong) UIView *leftShadowView;

@end

@implementation HDMultilevelSelectionView

static UIWindow *_selectWindow;


- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"closeMultilevelSelectionView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectLastItemNotificationCenter:) name:@"selectLastItemNotificationCenter" object:nil];
        self.frame = CGRectMake(0, 0, kFit(243), SScreen_Height - kFit(18.2));
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
}

- (void)setChildKey:(NSString *)childKey {
    _childKey = childKey;
}


- (void)setKey:(NSString *)Key {
    _Key = Key;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)showInViewController:(UIViewController *)superViewController {
    [self showInView:superViewController finishBlock:^{
        
    }];
}


- (void)showInView:(UIViewController *)superViewController finishBlock:(void(^)())finishBlock {
    @weakify(self)
    _selectWindow.hidden = YES; // 先隐藏之前的window
    _selectWindow = [[UIWindow alloc] init];
    _selectWindow.backgroundColor = [UIColor blackColor];
    _selectWindow.windowLevel = UIWindowLevelAlert;
    _selectWindow.frame = CGRectMake(SScreen_Width, kFit(18.2), kFit(243), SScreen_Height - kFit(18.2));
    _selectWindow.hidden = NO;
    
    
    _leftShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, kFit(18.2),SScreen_Width - kFit(243), SScreen_Height - kFit(18.2))];
    _leftShadowView.backgroundColor = [UIColor blackColor];
    _leftShadowView.alpha = 0;
    
    [superViewController.view addSubview:_leftShadowView];
    [_selectWindow addSubview:self];

    ChildViewController *childVC = [[ChildViewController alloc] init];
    childVC.dataArray = self.dataArray;
    childVC.childKey = self.childKey;
    childVC.key = self.Key;
    childVC.titleStr = self.title;
    childVC.closeButtonClickBlock = ^{
        [self dismiss];
    };
    [self addSubview:childVC.view];
    childVC.view.frame = CGRectMake(0, 0, kFit(243), SScreen_Height - kFit(18.2));
    [superViewController addChildViewController:childVC];
    [childVC didMoveToParentViewController:superViewController];
    
    [UIView animateWithDuration:0.3 // 动画时长
                          delay:0.0 // 动画延迟
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         CGRect frame = _selectWindow.frame;
                         frame.origin.x = SScreen_Width - kFit(243);
                         _selectWindow.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         // 动画完成后执行
                         @strongify(self)
                         self.leftShadowView.alpha = 0.3;
                         finishBlock();
                     }];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childVC];
    navigationController.navigationBarHidden = YES;
    _selectWindow.rootViewController = navigationController;
}


- (void)dismiss {
    [self dismissFinishBlock:^{
        _selectWindow = nil;
    }];
}

- (void)dismissFinishBlock:(void(^)())finishBlock {
    @weakify(self)
    [UIView animateWithDuration:0.3 // 动画时长
                          delay:0.0 // 动画延迟
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         @strongify(self)
                         CGRect frame = _selectWindow.frame;
                         frame.origin.x = SScreen_Width;
                         _selectWindow.frame = frame;
                         self.leftShadowView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         // 动画完成后执行
                         @strongify(self)
                         [self removeFromSuperview];
                         [self.leftShadowView removeFromSuperview];
                         finishBlock();
                     }];
}

- (void)setSelectFinishBlock:(void (^)(id))selectFinishBlock {
    _selectFinishBlock = selectFinishBlock;
}

- (void)selectLastItemNotificationCenter:(NSNotification*)notification {
    NSDictionary *nameDictionary = [notification userInfo];
    id selectItem = [nameDictionary objectForKey:@"selectItem"];
    if (self.selectFinishBlock) {
        self.selectFinishBlock(selectItem);
    }
    [self dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
