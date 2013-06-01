//
//  YSTableViewCell.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/16/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSTableViewCell.h"

@implementation YSTableViewCell

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

@end
