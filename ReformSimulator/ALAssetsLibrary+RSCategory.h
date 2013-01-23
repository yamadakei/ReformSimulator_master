//
//  ALAssetsLibrary+RSCategory.h
//  ReformSimulator
//
//  Created by yoshi on 13/01/22.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary (RSCategory)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end
