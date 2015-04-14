//
//  FriendsTableViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"

@interface FriendsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *nearByFriends;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
