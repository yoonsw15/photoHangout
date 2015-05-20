//
//  HostSessionViewController.h
//  PhotoHangout
//
//  Created by SeungWon on 2015. 5. 15..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostSessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *invitedFriendTable;
@property (nonatomic, strong) NSMutableArray *acceptedFriends;
@property (nonatomic, strong) NSArray *acceptedUsersArray;
@end