//
//  FriendsViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 24..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "JoinSessionViewController.h"
NSString *const kJoinCellIdentifier = @"Join";
NSString *const kJoinTableCellNibName = @"JoinTableViewCell";
@interface JoinSessionViewController ()

@end

@implementation JoinSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doPolling) object:nil ];
    [operationQueue addOperation:operation];
    
    self.invitationIDs = [NSMutableArray array];
    self.sessionIDs = [NSMutableArray array];
    self.photoIDs = [NSMutableArray array];
    self.hostIDs = [NSMutableArray array];
    
    self.currentSessions = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doPolling {
    int i = 0;
    while (true) {
        [self getCurrentSessions];
        [NSThread sleepForTimeInterval:2];
        NSLog(@"supposed to poll every 2 seconds...");
        i++;
    }
}

- (void)getCurrentSessions
{
    NSArray * currentSessions = [[NSArray alloc] init];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userName = [ud objectForKey:@"UserName"];
    
    NSURL *currentSessionURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://jingyuliu.com:8080/myapp/invitations/%@", userName]];
    NSData *currentSessionData =[NSData dataWithContentsOfURL:currentSessionURL];
    if(currentSessionData != nil) {
        NSError *error = nil;
        currentSessions = [NSJSONSerialization JSONObjectWithData:currentSessionData options:NSJSONReadingMutableContainers error:&error];
        
        for (int index = 0 ; index < [currentSessions count] ; index++) {
            NSDictionary *invitation = [currentSessions objectAtIndex:index];
            [self.sessionIDs insertObject:[invitation objectForKey:@"sessionId"] atIndex:index];
            [self.photoIDs insertObject:[invitation objectForKey:@"photoId"] atIndex:index];
            [self.invitationIDs insertObject:[invitation objectForKey:@"invitationId"] atIndex:index];
            [self.hostIDs insertObject:[invitation objectForKey:@"hostId"] atIndex:index];
            
            [self.currentSessions insertObject:[invitation objectForKey:@"hostUserName"] atIndex:index];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Update data source array and reload table view.
            [self.joinSessionTableView reloadData];
        });
        
        //refresh the table here
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.currentSessions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJoinCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.currentSessions objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJoinCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *invitationID = [self.invitationIDs objectAtIndex:indexPath.row] ;
    
    //send the put method here.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://jingyuliu.com:8080/myapp/invitations/%@/accept", invitationID]]]; 
    [request setHTTPMethod:@"PUT"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];

     NSData *invitationData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *invitationDict = [NSDictionary dictionary];
    
    if( [response statusCode] >= 200 && [response statusCode] <=300) {
        invitationDict = [NSJSONSerialization JSONObjectWithData:invitationData options:NSJSONReadingMutableContainers error:&error];
        
        //join websocket here using the data from server.
        //start loading animation here.
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
}

- (void)dealloc
{

}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end
