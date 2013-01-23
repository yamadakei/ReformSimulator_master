//
//  UIImage+RSCategory.m
//  ReformSimulator
//
//  Created by yoshi on 13/01/21.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import "UIImage+RSCategory.h"

#import <QuartzCore/QuartzCore.h>

#import "ALAssetsLibrary+RSCategory.h"

@implementation UIImage (RSCategory)

+ (UIImage*)resizedImage:(UIImage *)img size:(CGSize)size
{
    CGFloat widthRatio  = size.width  / img.size.width;
    CGFloat heightRatio = size.height / img.size.height;
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    CGSize resizedSize = CGSizeMake(img.size.width*ratio, img.size.height*ratio);
    
    UIGraphicsBeginImageContext(resizedSize);
    
    [img drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

+ (UIImage *) rotateImage:(UIImage *)img angle:(int)angle
{
    CGImageRef imgRef = [img CGImage];
    CGContextRef context;
    
    switch (angle) {
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, M_PI/2.0);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI/2.0);
            break;
        default:
            NSLog(@"you can select an angle of 90, 180, 270");
            return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ret;
}

+ (UIImage *)viewImage:(UIView*)view rect:(CGRect)rect
{
	UIGraphicsBeginImageContext(rect.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)saveImageInAlbum:(NSString*)name
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library addAssetsGroupAlbumWithName:name resultBlock:nil failureBlock:nil];

    [library saveImage:self toAlbum:name withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"save error: %@", [error description]);
        }
    }];
}

@end
