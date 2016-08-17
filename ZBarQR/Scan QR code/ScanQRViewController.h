//
//  ScanQRViewController.h
//  ZBarQR
//
//  Created by YaoXiang on 16/5/11.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScanQRViewController : UIViewController <ZBarReaderViewDelegate>
{
    ZBarReaderView          *readerView;
    ZBarCameraSimulator     *cameraSimulator;
    __weak IBOutlet UIView  *functionView;
    UIImageView             *scanLineImageView;
    UILabel                 *descriptLabel;
}

@property (weak, nonatomic) IBOutlet UIButton *qrcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightBtn;
@property (weak, nonatomic) IBOutlet UIButton *barcodeBtn;

- (IBAction)clickQRbtn:(id)sender;
- (IBAction)clickLightbtn:(UIButton *)sender;
- (IBAction)clickBarbtn:(id)sender;

@end
