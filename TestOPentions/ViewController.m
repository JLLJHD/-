//
//  ViewController.m
//  TestOPentions
//
//  Created by 郑超杰 on 2017/6/15.
//  Copyright © 2017年 ButterJie. All rights reserved.
//

#import "ViewController.h"
#import "ChildViewController.h"
#import "HDMultilevelSelectionView.h"

typedef void(^HDAlertConfirmHandle)();
typedef void(^HDAlertCancleHandle)();

@interface ViewController ()

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:topView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = self.view.center;
    button.backgroundColor = [UIColor  redColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonAction {
    HDMultilevelSelectionView *multilevelSelectionView = [HDMultilevelSelectionView new];
    
  NSDictionary *testDic =  @{
      @"typeName":@"测试1层",
      @"childList":@[
              @{
                  @"typeName":@"测试2层",
                  @"childList":@[
                          @{
                              @"typeName":@"测试3层",
                              @"childList":@[]
                              },
                          @{
                              @"typeName":@"测试3层",
                              @"childList":@[]
                              },
                          @{
                              @"typeName":@"测试3层",
                              @"childList":@[
                                      @{
                                          @"typeName":@"测试4层",
                                          @"childList":@[]
                                          }
                                      ]
                              }
                          ]
                  },
              @{
                  @"typeName":@"测试2层",
                  @"childList":@[]
                  },
              @{
                  @"typeName":@"测试2层",
                  @"childList":@[]
                  },
              @{
                  @"typeName":@"测试2层",
                  @"childList":@[]
                  }
              ]
      };
    
    NSDictionary *testDic1 =  @{
                               @"typeName":@"测试1层",
                               @"childList":@[]
                               };
    
    multilevelSelectionView.dataArray = [NSMutableArray arrayWithArray:@[testDic,testDic1]];
    multilevelSelectionView.childKey = @"childList";
    multilevelSelectionView.title = @"更改类型";
    multilevelSelectionView.Key = @"typeName";
    multilevelSelectionView.selectFinishBlock = ^(id selectItem) {
        NSLog(@"selectItem--->%@",selectItem);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAlertWithTitle:selectItem message:@"" confirmHandle:^{
                
            } cancleHandle:^{
                
            }];
        });
    };
    [multilevelSelectionView showInViewController:self];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(HDAlertConfirmHandle)confirmHandle cancleHandle:(HDAlertCancleHandle)cancleHandle {
    //TODO: 8.0 之后
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancleHandle) {
            cancleHandle();
        }
    }];
    UIAlertAction *confirAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandle) {
            confirmHandle();
        }
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirAction];
    [[self currentViewController] presentViewController:alertVC animated:YES completion:nil];
}

- (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *presentedVC = [[window rootViewController] presentedViewController];
    if (presentedVC) {
        return presentedVC;
    } else {
        return window.rootViewController;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
