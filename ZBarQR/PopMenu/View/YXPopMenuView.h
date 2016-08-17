//
//  YXPopMenuView.h
//  ZBarQR
//
//  Created by YaoXiang on 16/5/9.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXPopMenuViewDelegate <NSObject>

@optional
- (void)disappearPopMenuView;

@end

@interface YXPopMenuView : UIView

@property (nonatomic, assign) id<YXPopMenuViewDelegate> delegate;

@property (nonatomic, strong) UITableView *popMenuTableView;

- (instancetype)initWithFrame:(CGRect)frame popPoint:(CGPoint)popPoint width:(CGFloat)width menuItems:(NSArray *)menuItems action:(void (^)(NSInteger index))action;

@end
