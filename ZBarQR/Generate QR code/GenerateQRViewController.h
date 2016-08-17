//
//  GenerateQRViewController.h
//  ZBarQR
//
//  Created by YaoXiang on 16/5/10.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeGenerator.h"

@interface GenerateQRViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIImageView *QRcodeImageView;

- (IBAction)generateQR:(id)sender;

@end
