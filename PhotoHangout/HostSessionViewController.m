//
//  HostSessionViewController.m
//  PhotoHangout
//
//  Created by SeungWon on 2015. 5. 15..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "HostSessionViewController.h"
#import "PhotoEditViewController.h"

NSString *const kHostSessionCellIdentifier = @"HostSession";
NSString *const kHostSessionTableCellNibName = @"HostSessionTableViewCell";

@interface HostSessionViewController () <SRWebSocketDelegate>

@end

@implementation HostSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.acceptedUsersArray = [NSArray array];
    
    //open websocket here.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [ud objectForKey:@"SessionId"];
    
    NSURLRequest *websocketURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"ws://162.243.153.67:8030/photohangout/websocket/%@",sessionID]]];
    
    self.hostWebSocket = [[SRWebSocket alloc] initWithURLRequest:websocketURL];
    self.hostWebSocket.delegate = self;
    
    NSLog(@"Server has now been connected!");
    [self.hostWebSocket open];
    self.shouldPoll = YES;
    // Run polling on a separate thread
    self.operationQueue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doPolling) object:nil ];
    [self.operationQueue addOperation:operation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.shouldPoll = NO;
    [self.operationQueue cancelAllOperations];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.shouldPoll = NO;
    [self.operationQueue cancelAllOperations];
}

-(void)doPolling {
    int i = 0;
    while (self.shouldPoll) {
        [self callAPIWithJSON];
        [NSThread sleepForTimeInterval:2];
        NSLog(@"supposed to poll every 2 seconds...");
        i++;
    }
}

- (void)callAPIWithJSON
{
    NSArray * acceptedUsers = [[NSArray alloc] init];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [ud objectForKey:@"SessionId"];
    
    
    NSURL *acceptedUserURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://162.243.153.67:8080/myapp/sessions/%@/accepted", sessionID]];
    NSData *acceptedUserData =[NSData dataWithContentsOfURL:acceptedUserURL];
    if(acceptedUserData != nil) {
        NSError *error = nil;
        acceptedUsers = [NSJSONSerialization JSONObjectWithData:acceptedUserData options:NSJSONReadingMutableContainers error:&error];
        
        self.acceptedUsersArray = acceptedUsers;
        //reload tableview here will call cell for reow at indexpath.
        
        for (int i = 0; i < 1 ; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.invitedFriendTable cellForRowAtIndexPath:path];
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // Update data source array and reload table view.
                [self.invitedFriendTable reloadData];
            });
            
            
        }
        
        if (error != nil) {
            NSLog(@"Error has occurred for JSONSerialization: %@", error );
        }
    }
}

 #pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     
     // Return the number of sections.
     return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     
     // Return the number of rows in the section.
     return [self.acceptedFriends count];
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHostSessionCellIdentifier forIndexPath:indexPath];
     cell.textLabel.text = [self.acceptedFriends objectAtIndex:indexPath.row];
          
     if ([self.acceptedUsersArray count] != nil) {
         int row = indexPath.row;
         if ([[self.acceptedUsersArray[row] objectForKey:@"accepted"] isEqualToString:@"1"]) {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
         }
     }
     
     
     return cell;
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Code goes here when user selects a row in the tableView
 }

- (IBAction)editingTapped:(id)sender {
    
    //move to the photoeditor
    PhotoEditViewController *photoVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"PhotoEdit"];
        photoVC.currentImage = self.sessionImage;
    photoVC.isHost = YES;
    [self presentViewController:photoVC animated:YES completion:nil];
    
    [self.hostWebSocket send:@"Start"];
}
 
 
 /*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
