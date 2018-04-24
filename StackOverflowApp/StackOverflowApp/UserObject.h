//
//  UserObject.h
//  StackOverflowApp
//
//  Created by Conor Sweeney on 4/24/18.
//  Copyright © 2018 Conor Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//I am using a delegate instead of notifications because this is a one to one data relationship between the user object and the tableview
@protocol UserObjectDelegate <NSObject>
- (void)imageFinishedDownloading;
@end

@interface UserObject : NSObject

@property (nonatomic) id<UserObjectDelegate> delegate;

- (id)initWithDictionary:(NSDictionary*)userInfo;

@property (nonatomic) long bronzeBadgeCount;
@property (nonatomic) long silverBadgeCount;
@property (nonatomic) long goldBadgeCount;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *textLabelString;
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL imageDownloaded;
- (void)downloadImage;

@end
