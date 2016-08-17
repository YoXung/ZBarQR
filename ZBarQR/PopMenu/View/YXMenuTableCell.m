//
//  YXMenuTableCell.m
//  ZBarQR
//
//  Created by YaoXiang on 16/5/11.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import "YXMenuTableCell.h"

@implementation YXMenuTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
