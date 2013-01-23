//
//  ContentCell.h
//  ReformSimulator
//
//  Created by 山田 慶 on 2013/01/22.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *contentImage;
@property (nonatomic) IBOutlet UIImageView *logoImage;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *discriptionLabel;

- (void) cellSettings:(BOOL)setting contentImageName:(NSString *)contentImageName logoImageName:(NSString *)logoImageName name:(NSString *)name discription:(NSString *)discription;

@end
