//
//  CustomTableViewCell.h
//  StackOverflowApp
//
//  Created by Conor Sweeney on 4/24/18.
//  Copyright © 2018 Conor Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *customIV;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)formatCell:(UserObject *)user;

@end
