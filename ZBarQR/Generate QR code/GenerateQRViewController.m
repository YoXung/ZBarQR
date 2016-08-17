//
//  GenerateQRViewController.m
//  ZBarQR
//
//  Created by YaoXiang on 16/5/10.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import "GenerateQRViewController.h"

@interface GenerateQRViewController ()

@end

@implementation GenerateQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)generateQR:(id)sender {
    if ([[self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]  == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入字符不可为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
        self.inputField.text = @"";
        
    } else {
        self.QRcodeImageView.image = [QRCodeGenerator qrImageForString:self.inputField.text imageSize:self.QRcodeImageView.bounds.size.width];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
