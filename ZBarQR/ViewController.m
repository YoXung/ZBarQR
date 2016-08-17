//
//  ViewController.m
//  ZBarQR
//
//  Created by YaoXiang on 16/5/9.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import "ViewController.h"
#import "YXPopMenuModel.h"
#import "YXPopMenuViewSingleton.h"
#import "ScanQRViewController.h"
#import "GenerateQRViewController.h"

#define MENUVIEW_WIDTH  150
#define POP_POINT(menuViewWidth) \
    CGPointMake([UIScreen mainScreen].bounds.size.width - menuViewWidth - 10, 64 + 8)

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *arr;

@end

typedef NS_ENUM(NSInteger, ActionType) {
    ActionScanQR = 0,
    ActionGenerateQR
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showPop:(id)sender {
    if (!_arr) {
        _arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[self titles] count]; i++) {
            YXPopMenuModel *model = [[YXPopMenuModel alloc] init];
            model.image = [self images][i];
            model.title = [self titles][i];
            [_arr addObject:model];
        }
    }
    
    [[YXPopMenuViewSingleton sharedInstance] showPopMenuWithPoint:POP_POINT(MENUVIEW_WIDTH) width:MENUVIEW_WIDTH items:_arr action:^(NSInteger index) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        WS(weakSelf)
        if (index == ActionScanQR) {
            ScanQRViewController *scanQRViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ScanQR"];
            [weakSelf.navigationController pushViewController:scanQRViewController animated:YES];
        }
        if (index == ActionGenerateQR) {
            GenerateQRViewController *generateQRViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"GenerateQR"];
            [weakSelf.navigationController pushViewController:generateQRViewController animated:YES];
        }
    }];
}

- (NSArray *)images {
    return @[@"ScanImage",
             @"GenerateImage"];
}

- (NSArray *)titles {
    return @[@"扫一扫",
             @"我的二维码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
