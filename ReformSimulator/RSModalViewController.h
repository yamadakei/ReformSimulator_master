//
//  RSModalViewController.h
//  ReformSimulator
//
//  Created by yoshi on 13/01/20.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RSEventTypeChangeWallPaper = 0, // 壁紙を変更
    RSEventTypeSaveImage = 1,       // 画像を保存
    RSEventTypeRetake = 2              // 再撮影
} RSEventType;  // イベント種別

@interface RSModalViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)buttonTapped:(UIButton *)sender;

@end
