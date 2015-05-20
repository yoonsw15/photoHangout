//
//  InviteFriendsViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 5. 20..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allUsers;
@property (nonatomic, strong) UIImage *sessionImage;
@property (nonatomic, strong) NSMutableArray *selectedUsers;
@end
