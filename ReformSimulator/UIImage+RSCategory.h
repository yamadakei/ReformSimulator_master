//
//  UIImage+RSCategory.h
//  ReformSimulator
//
//  Created by yoshi on 13/01/21.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RSCategory)

+ (UIImage*)resizedImage:(UIImage *)img size:(CGSize)size;

+ (UIImage*)rotateImage:(UIImage *)img angle:(int)angle;

+ (UIImage *)viewImage:(UIView*)view rect:(CGRect)rect;

- (void)saveImageInAlbum:(NSString*)name;

@end
