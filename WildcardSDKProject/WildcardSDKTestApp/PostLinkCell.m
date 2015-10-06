//
//  PostLinkCell.m
//  ParsePlusRSS
//
//  Created by Daniel Kerbel on 8/14/15.
//  Copyright (c) 2015 Daniel Kerbel. All rights reserved.
//

#import "PostLinkCell.h"

@implementation PostLinkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    // (2)
//    [self.contentView updateConstraintsIfNeeded];
//    [self.contentView layoutIfNeeded];
//    
//    // (3)
//    self.postTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.postTextLabel.frame);
//}



@end
