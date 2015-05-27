//
//  InitialViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "InitialViewController.h"
#import "JoinSessionViewController.h"
#import "SignupViewController.h"
#import "MenuViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //AVAudioPlayer *player
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"maple" ofType:@"mp3"]];
    
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player.numberOfLoops = -1;
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@", [error description]);
    } else {
        [self.player play];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.player stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userName endEditing:YES];
    [self.pwName endEditing:YES];
}

- (IBAction)loginTapped:(id)sender {
    
    NSString *post = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", self.userName.text, self.pwName.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://162.243.153.67:8080/myapp/accounts/login"]]; // change URL here
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if( [response statusCode] >= 200 && [response statusCode] <=300) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:self.userName.text forKey:@"UserName"];
        [ud synchronize];
        
        [self saveUserID];
        
        MenuViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
        [self.navigationController pushViewController:menuVC animated:YES];
        [self.player stop];
    } else {
        NSLog(@"Connection could not be made Login failed");
    }
    
}
- (IBAction)signUpTapped:(id)sender {
    SignupViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signupVC"];
    [self.navigationController pushViewController:signupVC animated: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)saveUserID
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userName = [ud objectForKey:@"UserName"];
    NSDictionary * userIDDict = [[NSDictionary alloc] init];
    NSURL * userIDURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://162.243.153.67:8080/myapp/accounts/%@", userName]];
    NSData * userJSON =[NSData dataWithContentsOfURL:userIDURL];
    
    if(userJSON != nil) {
        NSError *error = nil;
        userIDDict = [NSJSONSerialization JSONObjectWithData:userJSON options:NSJSONReadingMutableContainers error:&error];
        
        NSString *userIDStr = [userIDDict objectForKey:@"userId"];
        
        [ud setObject:userIDStr forKey:@"UserId"];
        [ud synchronize];
        
        if (error == nil) {
        }
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

@end
