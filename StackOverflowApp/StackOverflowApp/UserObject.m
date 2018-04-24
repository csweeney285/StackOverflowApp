//
//  UserObject.m
//  StackOverflowApp
//
//  Created by Conor Sweeney on 4/24/18.
//  Copyright © 2018 Conor Sweeney. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

- (id)initWithDictionary:(NSDictionary*)userInfo{
    self = [super init];
    if (self) {
        self.username = [userInfo objectForKey:@"display_name"] ? [userInfo objectForKey:@"display_name"] : @"Unavailable";
        self.imageUrl = [userInfo objectForKey:@"profile_image"] ? [userInfo objectForKey:@"profile_image"] : @"";
        self.imageDownloaded = NO;
        NSMutableString *text = [NSMutableString new];
        [text appendString:self.username];
        if ([userInfo objectForKey:@"badge_counts"]) {
            NSDictionary *badgeDict = [userInfo objectForKey:@"badge_counts"];
            //-1 will be a default value for missing info (just in case)
            if ([badgeDict objectForKey:@"gold"]) {
                self.goldBadgeCount = [[badgeDict objectForKey:@"gold"] longValue];
                [text appendString:[NSString stringWithFormat:@" G: %ld",self.goldBadgeCount]];
            }
            if ([badgeDict objectForKey:@"silver"]) {
                self.bronzeBadgeCount = [[badgeDict objectForKey:@"silver"] longValue];
                [text appendString:[NSString stringWithFormat:@" S: %ld",self.silverBadgeCount]];
            }
            if ([badgeDict objectForKey:@"bronze"]) {
                self.bronzeBadgeCount = [[badgeDict objectForKey:@"bronze"] longValue];
                [text appendString:[NSString stringWithFormat:@" B: %ld",self.bronzeBadgeCount]];
            }
        }
        self.textLabelString = [text copy];
    }
    return self;
}

- (void)downloadImage{
    //Check that image url exists
    dispatch_queue_t myprocess_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(myprocess_queue, ^{
        if ([self.imageUrl length]>0 && !self.imageDownloaded) {
            NSURL *url = [NSURL URLWithString:self.imageUrl];
            NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    //handle error
                }
                else{
                    self.imageDownloaded = YES;
                    self.image = [UIImage imageWithData:data];
                    //we will push to main thread in the tableview controller
                    [self.delegate imageFinishedDownloading];
                }
            }] resume];
        }
    });
}

@end
