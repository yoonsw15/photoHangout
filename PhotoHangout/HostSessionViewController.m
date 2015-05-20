//
//  HostSessionViewController.m
//  PhotoHangout
//
//  Created by SeungWon on 2015. 5. 15..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "HostSessionViewController.h"

NSString *const kHostSessionCellIdentifier = @"HostSessionCell";
NSString *const kHostSessionTableCellNibName = @"HostSessionTableViewCell";

@interface HostSessionViewController ()

@end

@implementation HostSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Run polling on a separate thread
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doPolling) object:nil ];
    [operationQueue addOperation:operation];
    
    // allocate the array for invited friends list
    //self.invitedFriends = [[NSMutableArray alloc] initWithCapacity:10];
    //self.invitedFriends = @[@"user1", @"user2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doPolling {
    while (true) {
        [self callAPIWithJSON];
        [NSThread sleepForTimeInterval:2];
        NSLog(@"supposed to poll every 2 seconds...");
    }
}

//-(void)callApi {
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://162.243.153.67:8080/myapp/sessions/1/"]]; // change URL here
//    [request setHTTPMethod:@"GET"];
//
//    // get placeholder variables for error and response msgs
//    NSError *error = [[NSError alloc] init];
//    NSHTTPURLResponse *response = nil;
//
//    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//
//    // get the response from the server
//    if( [response statusCode] >= 200 && [response statusCode] <=300) {
//
//        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//        NSString *message = [NSString stringWithFormat:@"%@%@%@%@", [response valueForKey:@"ownerId"], @" of total invited; ", [response valueForKey:@"photoId"], @" ppl have joined now!"];
//        self.joinedAlert.text = message;
//    } else {
//        NSLog(@"Connection could not be made");
//    }
//
//}

- (void)callAPIWithJSON
{
    NSArray * acceptedUsers = [[NSArray alloc] init];
    NSURL *acceptedUserURL = [NSURL URLWithString:@"http://162.243.153.67:8080/myapp/sessions/1/accepted"];
    NSData *acceptedUserData =[NSData dataWithContentsOfURL:acceptedUserURL];
    
    if(acceptedUserData != nil) {
        NSError *error = nil;
        acceptedUsers = [NSJSONSerialization JSONObjectWithData:acceptedUserData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            NSLog(@"Error has occurred for JSONSerialization: %@", error );
        }
    }
    
//    NSString *message = [NSString stringWithFormat:@"%@%@%@%@", [invitedUsers objectForKey:@"ownerId"], @" of total invited; ", [invitedUsers objectForKey:@"photoId"], @" ppl have joined now!"];
    
    // write the message to the UILabel
    //    self.joinedAlert.textColor = [UIColor blackColor];
    //    [self.joinedAlert setText: message];
    //[self.messageLabel performSelectorOnMainThread : @ selector(setText : ) withObject:message waitUntilDone:YES];
    
}

 #pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    #warning Potentially incomplete method implementation.
     
     // Return the number of sections.
     return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    #warning Incomplete method implementation.
     
     // Return the number of rows in the section.
     return [self.invitedFriends count];
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHostSessionCellIdentifier forIndexPath:indexPath];
     cell.textLabel.text = [self.invitedFriends objectAtIndex:indexPath.row];
 
     return cell;
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Code goes here when user selects a row in the tableView
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
