//
//  RSMainViewController.m
//  ReformSimulator
//
//  Created by yoshi on 13/01/20.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import "RSMainViewController.h"
#import "RSModalViewController.h"
#import "UIImage+RSCategory.h"
#import "AppDelegate.h"
#import "RSItem.h"
#import "RSTableViewCell.h"

@interface RSMainViewController ()
{
    CGAffineTransform currentTransForm;
    UIView *transparentView;
    UIImage *originalImage;
    UIImage *capturedImage;
    UIImage *resultImage;
    AppDelegate *appDelegate;
}

@end

@implementation RSMainViewController

@synthesize imagePicker, pagingView, tableView, session, imageView, libraryExists;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpCaptureSession];                 //カメラセットアップ
    
    [self setUpTransparentView];                //透過のビュー

    [self setUpPagingView];                     //スクロール
    
    [self setUpPinchGestureForPagingView];      //PinchGesture登録
    
    [self setUpUISwipeGestureForTableView];     //SwipeGesture登録
    
    [self.view bringSubviewToFront:_shutter];   //シャッターボタンを最前面に
    
    [self.view bringSubviewToFront:tableView];  //テーブルを最前面に
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.shutter.hidden = NO;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidUnload {
    [self setShutter:nil];
    [self setTableView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

#pragma mark - IBAction

- (IBAction)takePicture:(UIButton *)sender {
    capturedImage = [UIImage viewImage:transparentView rect:self.view.bounds];
    
    originalImage = self.imageView.image;
    
    CGSize size = {self.view.frame.size.height,self.view.frame.size.width};
    UIGraphicsBeginImageContext(size);
    
    CGRect rect;
    rect.origin = CGPointZero;
    
    rect.size = size;
    [originalImage drawInRect:rect];
    [capturedImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UINavigationController *nc = self.navigationController;
    RSModalViewController* modalView = [nc.storyboard instantiateViewControllerWithIdentifier:@"RSModalViewController"];
    
    [self presentModalViewController:modalView animated:YES];
    modalView.imageView.image = resultImage;
}

#pragma mark - Private methods

- (void)setUpCaptureSession
{
    //デバイス取得
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //入力作成
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    //ビデオデータ出力作成
    NSDictionary* settings = @{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
    AVCaptureVideoDataOutput* dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    dataOutput.videoSettings = settings;
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //セッション作成
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:deviceInput];
    [self.session addOutput:dataOutput];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureConnection *videoConnection = NULL;
    
    // カメラの向きなどを設定する
    [self.session beginConfiguration];
    
    for ( AVCaptureConnection *connection in [dataOutput connections] )
    {
        for ( AVCaptureInputPort *port in [connection inputPorts] )
        {
            if ( [[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                
            }
        }
    }
    // 入ってきた画像の向きを回転し調整
    if([videoConnection isVideoOrientationSupported])
    {
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    
    [self.session commitConfiguration];
    // セッションをスタートする
    [self.session startRunning];

}

//透過のビューを作成
- (void)setUpTransparentView
{
    transparentView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transparentView];
}

- (void)setUpPagingView
{
    //pagingView
    pagingView = [[InfinitePagingView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.height * 0.5, self.view.frame.size.width * 0.5)];
    pagingView.center = CGPointMake(self.view.frame.size.height * 0.5, self.view.frame.size.width * 0.5);
    [transparentView addSubview:pagingView];
    
    //AppDelegateよりplistの情報を取得
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSArray * items = [[NSArray alloc]initWithArray:appDelegate.rsItems];

    for (RSItem* item in items){
        UIImage *image = [UIImage imageNamed:item.image];
        UIImageView *page = [[UIImageView alloc] initWithImage:image];
        page.frame = CGRectMake(0.f, 0.f, pagingView.frame.size.width * 0.8, pagingView.frame.size.height * 0.8);
        page.contentMode = UIViewContentModeScaleAspectFit;
        [pagingView addPageView:page];
    }
    
}

- (void)setUpPinchGestureForPagingView
{
    // ピンチジェスチャーを登録する
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [pagingView addGestureRecognizer:pinch];
}

- (void)setUpUISwipeGestureForTableView
{
    //スワイプの初期設定
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:gesture];
}

#pragma mark - UIPinchGestureRecognizer Selector
- (void)pinchAction : (UIPinchGestureRecognizer *)sender {
    
    // ピンチジェスチャー発生時に、Imageの現在のアフィン変形の状態を保存する
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        currentTransForm = pagingView.transform;
        // currentTransFormは、フィールド変数。imgViewは画像を表示するUIImageView型のフィールド変数。
    }
	
    // ピンチジェスチャー発生時から、どれだけ拡大率が変化したかを取得する
    // 2本の指の距離が離れた場合には、1以上の値、近づいた場合には、1以下の値が取得できる
    CGFloat scale = [sender scale];
    
    // スケーリングのMAX値とMIN値を設定
    if (scale < 0.8) {
        scale = 0.8;
    }else if(scale > 1.2) {
        scale = 1.2;
    }else{
        scale = scale;
    }
    
    // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
    pagingView.transform = CGAffineTransformConcat(currentTransForm, CGAffineTransformMakeScale(scale, scale));
}

#pragma mark - UISwipeGestureRecognizer Selector

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{    
    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationTransitionNone animations:^{
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            
            [tableView setTransform:CGAffineTransformMakeTranslation(250.0, 0)];
        }else{
            [tableView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        }
    } completion:^(BOOL finished) {
        if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            recognizer.direction = UISwipeGestureRecognizerDirectionRight;
        }else{
            recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        }
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBuffer Delegate Methods

//delegateメソッド。各フレームにおける処理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // 画像の表示
    self.imageView.image = [self imageFromSampleBufferRef:sampleBuffer];
}

// CMSampleBufferRefをUIImageへ
- (UIImage *)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBuffer
{
    // イメージバッファの取得
    CVImageBufferRef    buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);
    // イメージバッファ情報の取得
    uint8_t*    base;
    size_t      width, height, bytesPerRow;
    base = CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace;
    CGContextRef    cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(
                                      base, width, height, 8, bytesPerRow, colorSpace,
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    // 画像の作成
    CGImageRef  cgImage;
    UIImage*    image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage scale:1.0f
                          orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    // イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    return image;
}

#pragma mark - TableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return appDelegate.rsItems.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    /* iOS6.0以降のセルの再利用する書き方
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     
     cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
     */
    
    // Configure the cell...
    // ↓iOS5.1以前のセルの再利用する書き方
    RSTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    RSItem *rsItems = [appDelegate.rsItems objectAtIndex:indexPath.row];
    
    NSLog(@"%@", rsItems.description);
    [cell cellSettings:YES contentImageName:rsItems.image logoImageName:rsItems.logo  name:rsItems.name discription:rsItems.description];
    
    return cell;
    
}

@end
