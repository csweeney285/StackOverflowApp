//
//  TableViewController.m
//  StackOverflowApp
//
//  Created by Conor Sweeney on 4/24/18.
//  Copyright © 2018 Conor Sweeney. All rights reserved.
//

#import "TableViewController.h"
#import "CustomTableViewCell.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic) BOOL scrolling;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    for (UserObject *user in self.userArray) {
        //delete all the images for memory space
        user.image = nil;
    }
}

- (void)downloadData{
    //download data on a background thread
    dispatch_queue_t myprocess_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(myprocess_queue, ^{
        //the url is filtered to only inclued badges, display name, and the profile image url
        NSURL *url = [NSURL URLWithString:@"https://api.stackexchange.com/2.2/users?page=1&order=desc&sort=reputation&site=stackoverflow&filter=!0Z-UstkkOUv_5yY(tug5vnMSy"];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                //handle error
                //for now I'll assume no errors
            }
            id json =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([json isKindOfClass:[NSDictionary class]]) [self parseJSON: json];
        }] resume];
    });
}

- (void) parseJSON:(NSDictionary *)jsonDict{
    self.userArray = [NSMutableArray new];
    if ([jsonDict objectForKey:@"items"]) {
        NSArray *userArr = [jsonDict objectForKey:@"items"];
        for (NSDictionary *userDict in userArr) {
            UserObject *user = [[UserObject alloc] initWithDictionary:userDict];
            user.delegate = self;
            [self.userArray addObject: user];
        }
        //parsing is complete reload the tableview to display the users
        [self reloadTableViewFromMainthread];
    }
}

- (void)reloadTableViewFromMainthread{
    //always manipulate ui on the mainthread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UserObject Delegate
-(void)imageFinishedDownloading{
    [self reloadTableViewFromMainthread];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    UserObject *user = [self.userArray objectAtIndex: indexPath.row];
    if (!user.imageDownloaded) {
        cell.customIV.image = nil;
        cell.spinner.alpha = 1;
        [cell.spinner startAnimating];
        //only download the image if it has not already been downloaded and the user is not scrolling
        if (!self.scrolling) {
            [user downloadImage];
        }
    }
    else{
        cell.spinner.alpha = 0;
        [cell.spinner stopAnimating];
        cell.customIV.image = user.image;
    }
    cell.label.text = user.textLabelString;
    return cell;
}

#pragma mark - Scroll view
//used for lazy image loading
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.scrolling = YES;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    self.scrolling = NO;
}

@end
