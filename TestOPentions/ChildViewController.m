//
//  ChildViewController.m
//  TestOPentions
//
//  Created by 郑超杰 on 2017/6/15.
//  Copyright © 2017年 ButterJie. All rights reserved.
//

#import "ChildViewController.h"
#define kIphone6Width 375.0
#define SScreen_Width [UIScreen mainScreen].bounds.size.width
#define SScreen_Height [UIScreen mainScreen].bounds.size.height
#define kFit(x) (SScreen_Width*((x)/kIphone6Width))

@interface ChildViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *childTableView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ChildViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillLayoutSubviews {
    NSLog(@"----------%@",self.view);
    [super viewWillLayoutSubviews];
    _childTableView.frame = CGRectMake(0, 64 - kFit(18.2), self.view.frame.size.width, self.view.frame.size.height - (64 - kFit(18.2)));
    _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64 - kFit(18.2));
    _backButton.frame = CGRectMake(10, 0, 50, _topView.frame.size.height);
    _closeButton.frame = CGRectMake(self.view.frame.size.width - 60, 0, 50, _topView.frame.size.height);
    _titleLabel.frame = CGRectMake(65, 0, self.view.frame.size.width - 125, _topView.frame.size.height);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [self creatTopView];
    [self creatTableView];
}


- (void)creatTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectZero];
    _topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_topView];
    
    if (self.showBackButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_backButton addTarget:self action:@selector(backButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_backButton];
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = self.titleStr;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:_titleLabel];

    _closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_closeButton addTarget:self action:@selector(closeButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_closeButton];
}

- (void)backButtonClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonClickAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMultilevelSelectionView" object:nil];
}

- (void)setCloseButtonClickBlock:(void (^)())closeButtonClickBlock {
    _closeButtonClickBlock = closeButtonClickBlock;
}

- (void)creatTableView {
    _childTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _childTableView.delegate = self;
    _childTableView.dataSource = self;
    _childTableView.tableFooterView = [UIView new];
    [self.view addSubview:_childTableView];
}

#pragma mark -
#pragma mark 返回有多少分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -
#pragma mark 返回一个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -
#pragma mark 返回某个分区的单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark -
#pragma mark 返回表的单元格对象
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    id item = self.dataArray[indexPath.row];
    if([item isKindOfClass:[NSString class]]) {
        cell.textLabel.text = item;
    } else {
        cell.textLabel.text = [item valueForKey:_key];
        id childItem = [item valueForKey:_childKey];
        if (childItem != nil) {
            if ([childItem isKindOfClass:[NSArray class]] || [childItem isKindOfClass:[NSMutableArray class]]) {
                if ([childItem count] > 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"你点击了第%ld分区第%ld行", (long)indexPath.section ,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id item = self.dataArray[indexPath.row];
    
    ChildViewController *childVC = [[ChildViewController alloc] init];
    childVC.showBackButton = YES;
    childVC.childKey = self.childKey;
    childVC.titleStr = self.titleStr;
    childVC.key = self.key;
    if([item isKindOfClass:[NSString class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLastItemNotificationCenter" object:nil userInfo:@{@"selectItem":[item valueForKey:_key]}];
        return;
    } else {
        id childItem = [item valueForKey:_childKey];
        if (childItem != nil) {
            if ([childItem isKindOfClass:[NSArray class]] || [childItem isKindOfClass:[NSMutableArray class]]) {
                if ([childItem count] > 0) {
                    childVC.dataArray = childItem;
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLastItemNotificationCenter" object:nil userInfo:@{@"selectItem":[item valueForKey:_key]}];
                    return;
                }
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLastItemNotificationCenter" object:nil userInfo:@{@"selectItem":[item valueForKey:_key]}];
                return;
            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLastItemNotificationCenter" object:nil userInfo:@{@"selectItem":[item valueForKey:_key]}];
            return;
        }
    }
    
    childVC.view.frame = CGRectMake(0, 0, kFit(243), SScreen_Height - kFit(18.2));
    [self.navigationController pushViewController:childVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
