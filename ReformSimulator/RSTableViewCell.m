//
//  ContentCell.m
//  ReformSimulator
//
//  Created by 山田 慶 on 2013/01/22.
//  Copyright (c) 2013年 yoshi. All rights reserved.
//

#import "RSTableViewCell.h"

@implementation RSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) cellSettings:(BOOL)setting contentImageName:(NSString *)contentImageName logoImageName:(NSString *)logoImageName name:(NSString *)name discription:(NSString *)discription {
    
    self.contentImage.image = [UIImage imageNamed:contentImageName];
    self.logoImage.image = [UIImage imageNamed:logoImageName];
    self.nameLabel.text = name;
    self.discriptionLabel.text =discription;
    
}

@end
