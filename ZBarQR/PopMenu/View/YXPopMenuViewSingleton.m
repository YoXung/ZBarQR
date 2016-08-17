//
//  YXPopMenuViewSingleton.m
//  ZBarQR
//
//  Created by YaoXiang on 16/5/11.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import "YXPopMenuViewSingleton.h"

@interface YXPopMenuViewSingleton ()<YXPopMenuViewDelegate>

@property (nonatomic, strong) YXPopMenuView *popMenuView;

@end

@implementation YXPopMenuViewSingleton

SYNTHESIZE_SINGLETON_FOR_CLASS(YXPopMenuViewSingleton, sharedInstance)

- (void)showPopMenuWithPoint:(CGPoint)point width:(CGFloat)width items:(NSArray *)items action:(void (^)(NSInteger index))action {
    
    WS(weakSelf)
    
    if (self.popMenuView != nil) {
        [weakSelf hideMenu];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    self.popMenuView = [[YXPopMenuView alloc] initWithFrame:window.bounds
                                                   popPoint:point
                                                      width:width
                                                  menuItems:items
                                                     action:^(NSInteger index) {
                                                         action(index);
                                                        [weakSelf hideMenu];
                                                     }];
    self.popMenuView.delegate = self;
    self.popMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [window addSubview:self.popMenuView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.popMenuView.popMenuTableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3 animations:^{
        self.popMenuView.popMenuTableView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        [self.popMenuView.popMenuTableView removeFromSuperview];
        [self.popMenuView removeFromSuperview];
        self.popMenuView.popMenuTableView = nil;
        self.popMenuView = nil;
    }];
}


#pragma mark - delegate
- (void)disappearPopMenuView {
    [self hideMenu];
}


@end
