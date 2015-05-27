//
//  FriendsViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 24..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebsocket.h"
@interface JoinSessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *joinSessionTableView;

@property (strong, nonatomic) NSMutableArray *currentSessions;

@property (strong, nonatomic) NSMutableArray *invitationIDs;
@property (strong, nonatomic) NSMutableArray *photoIDs;
@property (strong, nonatomic) NSMutableArray *sessionIDs;
@property (strong, nonatomic) NSMutableArray *hostIDs;

@end
