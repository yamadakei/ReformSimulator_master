//
//  RSMainViewController.h
//  ReformSimulator
//
//  Created by yoshi on 13/01/20.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "InfinitePagingView.h"

@interface RSMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

CGImageRef UIGetScreenImage(void);

@property (strong,  nonatomic) UIImagePickerController* imagePicker;

@property (nonatomic, strong) AVCaptureSession* session;

@property (strong,  nonatomic) InfinitePagingView*      pagingView;

@property (strong,  nonatomic) IBOutlet UITableView*    tableView;

@property (weak,    nonatomic) IBOutlet UIButton *shutter;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) BOOL libraryExists;

- (IBAction)takePicture:(UIButton *)sender;

@end
