//
//  InviteFriendsViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 5. 20..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "HostSessionViewController.h"

NSString *const kInviteFriendsCellIdentifier = @"InviteFriends";
NSString *const kInviteFriendTableCellNibName = @"InviteFriendsTableViewCell";
@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //use the server to get the online friends and instantiate the array.
    self.selectedUsers = [NSMutableArray array];
    self.selectedUserNames = [NSMutableArray array];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userName = [ud objectForKey:@"UserName"];
    NSArray * allUsersArray = [[NSArray alloc] init];
    NSURL * allUsersURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://162.243.153.67:8080/myapp/accounts/%@/friends", userName]];
    NSData * allUsersJSON =[NSData dataWithContentsOfURL:allUsersURL];
    
    if(allUsersJSON != nil) {
        NSError *error = nil;
        allUsersArray = [NSJSONSerialization JSONObjectWithData:allUsersJSON options:NSJSONReadingMutableContainers error:&error];
        
        self.allUsers = [NSMutableArray arrayWithArray:allUsersArray];
        
        if (error == nil) {
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.allUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInviteFriendsCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.allUsers[indexPath.row] objectForKey:@"username"];
    
    if ([self.selectedUsers containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
    //self.selectedIndexPath = indexPath;
    
    //the below code will allow multiple selection
    if ([self.selectedUsers containsObject:indexPath])
    {
        [self.selectedUsers removeObject:indexPath];
    }
    else
    {
        [self.selectedUsers addObject:indexPath];
    }
    [tableView reloadData];
}

- (IBAction)inviteTapped:(id)sender
{
    for (NSIndexPath *path in self.selectedUsers) {
        NSString *userName = [self.allUsers[path.row] objectForKey:@"username"];
        NSString *userId = [self.allUsers[path.row] objectForKey:@"userId"];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sessionID = [ud objectForKey:@"SessionId"];
        
        [self inviteServerCallFor:userId UserName:userName SessionID:sessionID];
        
        [self.selectedUserNames addObject:userName];
    }
    
    HostSessionViewController *hostSessionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HostSessionVC"];
    hostSessionVC.acceptedFriends = self.selectedUserNames;
    hostSessionVC.sessionImage = self.sessionImage;
    
    [self presentViewController:hostSessionVC animated:YES completion:nil];
    
}

- (void)inviteServerCallFor:(NSString *)userID UserName:(NSString *)userName SessionID:(NSString *)sessionID
{
    NSString *post = [NSString stringWithFormat:@"{\"sessionId\":\"%@\",\"receiverId\":\"%@\",\"accepted\":\"%@\"}", sessionID, userID, @"0"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://162.243.153.67:8080/myapp/invitations"]]; // change URL here
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if( [response statusCode] >= 200 && [response statusCode] <=300) {
        NSLog(@"Invitation created for %@", userName);
    } else {
        NSLog(@"Connection could not be made Invitation Failed");
    }
}

@end
