//
//  CustomTableViewCell.m
//  StackOverflowApp
//
//  Created by Conor Sweeney on 4/24/18.
//  Copyright © 2018 Conor Sweeney. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)formatCell:(UserObject *)user{
    if (!user.imageDownloaded) {
        self.customIV.image = nil;
        self.spinner.alpha = 1;
        [self.spinner startAnimating];
    }
    else{
        self.spinner.alpha = 0;
        [self.spinner stopAnimating];
        self.customIV.image = user.image;
    }
    self.label.text = user.textLabelString;
}

@end
