//
//  FriendsViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 24..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebsocket.h"
@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nearByFriends;
@property (nonatomic, strong) SRWebSocket *friendWebSocket;
@property (nonatomic, strong) NSURLRequest *friendURL;

@end
