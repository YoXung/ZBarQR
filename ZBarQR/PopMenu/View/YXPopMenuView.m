//
//  YXPopMenuView.m
//  ZBarQR
//
//  Created by YaoXiang on 16/5/9.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import "YXPopMenuView.h"
#import "YXPopMenuModel.h"
#import "YXMenuTableCell.h"

#define CELLHEIGHT 40

@interface YXPopMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) CGPoint popPoint;
@property (nonatomic, copy)   NSArray *menuItems;
@property (nonatomic, copy)   void (^action)(NSInteger index);

@end

@implementation YXPopMenuView

- (instancetype)initWithFrame:(CGRect)frame popPoint:(CGPoint)popPoint width:(CGFloat)width menuItems:(NSArray *)menuItems action:(void (^)(NSInteger index))action {
    if (self = [super initWithFrame:frame]) {
        self.menuWidth = width;
        self.popPoint = popPoint;
        self.menuItems = menuItems;
        self.action = [action copy];
        self.popMenuTableView = [[UITableView alloc] initWithFrame:[self popMenuViewFrame] style:UITableViewStylePlain];
        self.popMenuTableView.delegate = self;
        self.popMenuTableView.dataSource = self;
        self.popMenuTableView.scrollEnabled = NO;
        self.popMenuTableView.layer.cornerRadius = 8;
        self.popMenuTableView.layer.anchorPoint = CGPointMake(1.0, 0);
        self.popMenuTableView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.popMenuTableView.rowHeight = CELLHEIGHT;
        [self addSubview:self.popMenuTableView];
        
        [self.popMenuTableView registerClass:[YXMenuTableCell class] forCellReuseIdentifier:@"cell"];
        
        if ([self.popMenuTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self.popMenuTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.popMenuTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self.popMenuTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (self.menuItems > 0) {
        YXPopMenuModel *model = self.menuItems[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:model.image];
        cell.textLabel.text = model.title;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.action)
    {
        self.action(indexPath.row);
    }
}

#pragma mark - 分割线从顶端开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 绘制popMenuView
- (CGRect)popMenuViewFrame
{
    CGFloat menuViewX = 75 + self.popPoint.x;
    CGFloat menuViewY = self.popPoint.y - self.menuItems.count * 20;
    CGFloat menuWidth = self.menuWidth;
    CGFloat menuHeight = self.menuItems.count * CELLHEIGHT;
    
    return CGRectMake(menuViewX, menuViewY, menuWidth, menuHeight);
    
}

#pragma mark - 绘制三角形
- (void)drawRect:(CGRect)rect
{
    // 背景色
    [[UIColor whiteColor] set];
    
    // 获取视图
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 开始绘制
    CGContextBeginPath(contextRef);
    
    // 底边长度为10，高度为5的三角形
    CGContextMoveToPoint(contextRef, self.popPoint.x + self.menuWidth - 10, self.popPoint.y);
    CGContextAddLineToPoint(contextRef, self.popPoint.x + self.menuWidth - 10 * 2, self.popPoint.y);
    CGContextAddLineToPoint(contextRef, self.popPoint.x + self.menuWidth - 10 * 1.5, self.popPoint.y - 7);
    // 结束绘制
    CGContextClosePath(contextRef);
    // 填充色
    [[UIColor whiteColor] setFill];
    // 边框颜色
    [[UIColor whiteColor] setStroke];
    // 绘制路径
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    PERFORM_DELEGATE_WITH_OBJ(self.delegate, disappearPopMenuView, self);
}


@end
