//
//  RSModalViewController.m
//  ReformSimulator
//
//  Created by yoshi on 13/01/20.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#define kLibraryExists @"library_exists"

#import "RSModalViewController.h"

#import "UIImage+RSCategory.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface RSModalViewController ()
{
    ALAssetsLibrary *library;
    UIImage *resultImage;
    UIImage *imageToSave;
}

@end

@implementation RSModalViewController

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
    [self setImageView:nil];
    [super viewDidUnload];
}
- (IBAction)buttonTapped:(UIButton *)sender {
    
    switch (sender.tag) {
        case RSEventTypeChangeWallPaper:
            NSLog(@"ChangeWallPaper");
            break;

        case RSEventTypeRetake:
            NSLog(@"Retake");
            break;

        case RSEventTypeSaveImage:
            NSLog(@"Save");
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:kLibraryExists]) {
                
                //Save時に不具合あり　すみませんまだ未完成です
//                [self.imageView.image saveImageInAlbum:@"ReformSimulator"];
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLibraryExists];
            
            imageToSave = [[UIImage alloc] init];
            imageToSave = self.imageView.image;
            CGSize size = {self.view.frame.size.height,self.view.frame.size.width};
            UIGraphicsBeginImageContext(size);
            CGRect rect;
            rect.origin = CGPointZero;
            
            rect.size = size;
            
            [imageToSave drawInRect:rect];
            
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
                
                library = [[ALAssetsLibrary alloc] init];
                [library addAssetsGroupAlbumWithName:@"Reform Simulator" resultBlock:nil failureBlock:nil];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLibraryExists];
                
                [library saveImage:resultImage toAlbum:@"Reform Simulator" completionBlock:nil failureBlock:nil];

//            }else{
//                [library saveImage:self.imageView.image toAlbum:@"Reform Simulator" completionBlock:nil failureBlock:nil];
//            };
            break;

        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
