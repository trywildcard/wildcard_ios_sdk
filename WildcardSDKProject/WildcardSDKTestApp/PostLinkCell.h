//
//  PostLinkCell.h
//  ParsePlusRSS
//
//  Created by Daniel Kerbel on 8/14/15.
//  Copyright (c) 2015 Daniel Kerbel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostLinkCell : UITableViewCell

//@property (strong, nonatomic) IBOutlet UILabel *businessNameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *postDateLabel;
//@property (strong, nonatomic) IBOutlet UILabel *postTextLabel;

@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *likeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UIView *topSeperator;
@property (weak, nonatomic) IBOutlet UIView *btmSeperator;
@property (strong, nonatomic) IBOutlet UIView *containerView;

//-(void)setCellPost:(Post *)post;

@end
