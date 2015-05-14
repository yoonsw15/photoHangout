//
//  FriendsViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 24..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "FriendsViewController.h"
NSString *const kFriendsCellIdentifier = @"Friend";
NSString *const kFriendTableCellNibName = @"FriendsTableViewCell";
@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //use the server to get the online friends and instantiate the array.
    self.nearByFriends = [[NSMutableArray alloc] initWithCapacity:10];
    self.nearByFriends = @[@"Minsuk Oh", @"Won Jae Lee"];
    
    self.friendURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: @"ws://localhost:8025/photohangout/websocket"]];
    
    self.friendWebSocket = [[SRWebSocket alloc] initWithURLRequest:self.friendURL];
    self.friendWebSocket.delegate = self;
    
    [self.friendWebSocket open];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [self.nearByFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.nearByFriends objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section %li, Row: %li", indexPath.section, indexPath.row );
    
    NSString *message = [NSString stringWithFormat:@"%@%@",[self.nearByFriends objectAtIndex:indexPath.row], @" have been tapped"];
    
    [self.friendWebSocket send:message];
    
    if (indexPath.row == 1)
    {
        [self.friendWebSocket close];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
}

- (void)dealloc
{
    if ([self.friendWebSocket readyState] == SR_OPEN) {
        [self.friendWebSocket close];
    }
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
