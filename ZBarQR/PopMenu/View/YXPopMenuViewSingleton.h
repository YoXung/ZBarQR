//
//  YXPopMenuViewSingleton.h
//  ZBarQR
//
//  Created by YaoXiang on 16/5/11.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXPopMenuView.h"

@interface YXPopMenuViewSingleton : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(YXPopMenuViewSingleton, sharedInstance)

- (void)showPopMenuWithPoint:(CGPoint)point width:(CGFloat)width items:(NSArray *)items action:(void (^)(NSInteger index))action;

@end
