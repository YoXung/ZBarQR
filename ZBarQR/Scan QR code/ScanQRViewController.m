//
//  ScanQRViewController.m
//  ZBarQR
//
//  Created by YaoXiang on 16/5/11.
//  Copyright © 2016年 么翔的私房菜. All rights reserved.
//

#import "ScanQRViewController.h"
#define SCAN_QR_CROP_SIDE        MIN(SCREEN_WIDTH, SCREEN_HEIGHT) * 3/5
#define SCAN_BAR_CROP_WIDTH      SCREEN_WIDTH * 4/5
#define SCAN_BAR_CROP_HEIGHT     MIN(SCREEN_WIDTH, SCREEN_HEIGHT) * 2/5
#define DESCRIBECROPHEIGHT  60.0f

@interface ScanQRViewController () {
    CGRect      cropRect;
    CGRect      drawRect;
    BOOL        isQRscanner;
    NSString    *result;
}

@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    isQRscanner = YES;
    readerView = [[ZBarReaderView alloc] init];
    readerView.frame = CGRectMake(0.0f, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT);
    
    if (isQRscanner) {
        // 二维码扫描区域
        cropRect = CGRectMake((readerView.frame.size.width - SCAN_QR_CROP_SIDE) / 2.0f, (readerView.frame.size.height - SCAN_QR_CROP_SIDE) / 2.0f, SCAN_QR_CROP_SIDE, SCAN_QR_CROP_SIDE);
    } else {
        // 条形码扫描区域
        cropRect = CGRectMake((readerView.frame.size.width - SCAN_BAR_CROP_WIDTH) / 2.0f, (readerView.frame.size.height - SCAN_BAR_CROP_HEIGHT) / 2.0f, SCAN_BAR_CROP_WIDTH, SCAN_BAR_CROP_HEIGHT);
    }
    
    readerView.scanCrop = [self scanCrop:cropRect ofReaderViewBounds:readerView.bounds];
    
    // 是否显示绿色的追踪框，注意，即当选择yes的时候，这个框仅仅当扫瞄EAN和I2/5的时候才可见。
    readerView.tracksSymbols = NO;
    
    // 关闭闪光灯
    readerView.torchMode = 0;
    // 使用手动变焦，默认可以
    readerView.allowsPinchZoom = YES;
    
    // 处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        cameraSimulator = [[ZBarCameraSimulator alloc] initWithViewController:self];
        cameraSimulator.readerView = readerView;
    }
    readerView.readerDelegate = self;

    [self.view addSubview:readerView];
    // 考虑到层级关系
    [readerView insertSubview:[self customScanViewWithRect:cropRect] atIndex:1];
    [readerView addSubview:functionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [readerView start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [readerView stop];
}

#pragma mark - 扫码回调
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
//    ZBarSymbol *symbol = nil;
//    for (symbol in symbols) {
//        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
//            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
//        }
//        result = symbol.data;
//        break;
//    }
    [scanLineImageView.layer removeAllAnimations];
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    result = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    
    if (isQRscanner == YES && zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
        //判断是否包含 头'http:'
        NSString *regex = @"http+:[^\\s]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        //判断是否包含 头'ssid:'
        NSString *ssid = @"ssid+:[^\\s]*";;
        NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
        
        if ([predicate evaluateWithObject:result]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"It will use the browser to this URL" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else if([ssidPre evaluateWithObject:result]) {
            NSArray *arr = [result componentsSeparatedByString:@";"];
            NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
            NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
            
            result = [NSString stringWithFormat:@"ssid: %@ \n password:%@",[arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The password is copied to the clipboard , it will be redirected to the network settings interface" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                // 然后，可以使用如下代码来把一个字符串放置到剪贴板上：
                pasteboard.string = [arrInfoFoot objectAtIndex:1];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"二维码内容为：" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                // 使用如下代码来把条形码放置到剪贴板上：
                pasteboard.string = result;
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"条形码内容为：" message:result preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            // 使用如下代码来把条形码放置到剪贴板上：
            pasteboard.string = result;
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    

    // 扫描后返回
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取扫描区域，默认(0, 0, 1, 1)
- (CGRect)scanCrop:(CGRect)rect ofReaderViewBounds:(CGRect)readerViewBounds {
    CGFloat x, y, width, height;
    
    if (isQRscanner) {
        x = rect.origin.y / readerViewBounds.size.height;
        y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
        width = rect.size.height / readerViewBounds.size.height;
        height = rect.size.width / readerViewBounds.size.width;
    } else {
        x = rect.origin.x / readerViewBounds.size.width;
        y = rect.origin.y / readerViewBounds.size.height;
        width = rect.size.width / readerViewBounds.size.width;
        height = rect.size.height / readerViewBounds.size.height;
    }

    return CGRectMake(x, y, width, height);
}


- (UIImageView *)customScanViewWithRect:(CGRect)rect {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:MAINSCREEN_BOUNDS];
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.3f);
    drawRect = MAINSCREEN_BOUNDS;
    CGContextFillRect(context, MAINSCREEN_BOUNDS);
    
    if (descriptLabel)
        [descriptLabel removeFromSuperview];
    
    drawRect = CGRectMake(rect.origin.x - imageView.frame.origin.x, rect.origin.y - imageView.frame.origin.y - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT, rect.size.width, rect.size.height);

    descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(drawRect.origin.x, drawRect.origin.y + drawRect.size.height + STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, drawRect.size.width, DESCRIBECROPHEIGHT)];
    descriptLabel.font = [UIFont systemFontOfSize:12];
    descriptLabel.textAlignment = NSTextAlignmentCenter;
    descriptLabel.textColor= [UIColor whiteColor];
    descriptLabel.text = isQRscanner ? @"将二维码放入框内，即可自动扫描" : @"将条形码放入框内，即可自动扫描";
    [self.view addSubview:descriptLabel];
    
    [self addScanLineInFrame:drawRect];
    [self addScanCornerInFrame:drawRect];
    
    CGContextClearRect(context, drawRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.image = image;

    return imageView;
}

#pragma mark - 扫描条
- (void)addScanLineInFrame:(CGRect)frame {
    UIImage *image = [UIImage imageNamed:@"scan_line"];
    frame.size.height = 4.0f;
    scanLineImageView = [[UIImageView alloc] initWithFrame:frame];
    [readerView addSubview:scanLineImageView];
    scanLineImageView.image = image;
    if (isQRscanner) {
        frame.origin.y += SCAN_QR_CROP_SIDE;
    } else {
        frame.origin.y += SCAN_BAR_CROP_HEIGHT;
    }
    
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseOut animations:^{
        scanLineImageView.frame = frame;
    } completion:nil];
}

- (void)addScanCornerInFrame:(CGRect)frame {
    UIImageView *leftUpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x , frame.origin.y, 20.0f, 20.0f)];
    leftUpImgView.image = [UIImage imageNamed:@"corner_left_up"];
    UIImageView *leftDownImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x , frame.origin.y + frame.size.height - 20.0f, 20.0f, 20.0f)];
    leftDownImgView.image = [UIImage imageNamed:@"corner_left_down"];
    UIImageView *rightUpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x + frame.size.width - 20.0f, frame.origin.y, 20.0f, 20.0f)];
    rightUpImgView.image = [UIImage imageNamed:@"corner_right_up"];
    UIImageView *rightDownImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x + frame.size.width - 20.0f, frame.origin.y + frame.size.height - 20.0f, 20.0f, 20.0f)];
    rightDownImgView.image = [UIImage imageNamed:@"corner_right_down"];
    [readerView addSubview:leftUpImgView];
    [readerView addSubview:leftDownImgView];
    [readerView addSubview:rightUpImgView];
    [readerView addSubview:rightDownImgView];
}

- (IBAction)clickQRbtn:(id)sender {
    isQRscanner = YES;
    NSArray *arr = [readerView subviews];
    for (UIView *view in arr) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    // 二维码扫描区域
    cropRect = CGRectMake((readerView.frame.size.width - SCAN_QR_CROP_SIDE) / 2.0f, (readerView.frame.size.height - SCAN_QR_CROP_SIDE) / 2.0f, SCAN_QR_CROP_SIDE, SCAN_QR_CROP_SIDE);
    readerView.scanCrop = [self scanCrop:cropRect ofReaderViewBounds:readerView.bounds];
    [readerView insertSubview:[self customScanViewWithRect:cropRect] atIndex:1];
    [self.qrcodeBtn setImage:[UIImage imageNamed:@"qrcodeT"] forState:UIControlStateNormal];
    [self.qrcodeBtn setTitleColor:RGBA(96, 165, 255, 1) forState:UIControlStateNormal];
    [self.barcodeBtn setImage:[UIImage imageNamed:@"barcode"] forState:UIControlStateNormal];
    [self.barcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - 开灯
- (IBAction)clickLightbtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.lightBtn setImage:[UIImage imageNamed:@"lightO"] forState:UIControlStateNormal];
        [self.lightBtn setTitleColor:RGBA(251, 235, 25, 1) forState:UIControlStateNormal];
        readerView.torchMode = 1;
    } else {
        [self.lightBtn setImage:[UIImage imageNamed:@"lightD"] forState:UIControlStateNormal];
        [self.lightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        readerView.torchMode = 0;
    }
}

- (IBAction)clickBarbtn:(id)sender {
    isQRscanner = NO;
    NSArray *arr = [readerView subviews];
    for (UIView *view in arr) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    // 条形码扫描区域
    cropRect = CGRectMake((readerView.frame.size.width - SCAN_BAR_CROP_WIDTH) / 2.0f, (readerView.frame.size.height - SCAN_BAR_CROP_HEIGHT) / 2.0f, SCAN_BAR_CROP_WIDTH, SCAN_BAR_CROP_HEIGHT);
    readerView.scanCrop = [self scanCrop:cropRect ofReaderViewBounds:readerView.bounds];

    [readerView insertSubview:[self customScanViewWithRect:cropRect] atIndex:1];
    
    [self.barcodeBtn setImage:[UIImage imageNamed:@"barcodeT"] forState:UIControlStateNormal];
    [self.barcodeBtn setTitleColor:RGBA(96, 165, 255, 1) forState:UIControlStateNormal];
    [self.qrcodeBtn setImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
    [self.qrcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
