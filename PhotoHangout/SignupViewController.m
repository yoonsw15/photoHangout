//
//  SignupViewController.m
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/3/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController () <NSURLConnectionDataDelegate>

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameTextField endEditing:YES];
    [self.pwTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
}
- (IBAction)cancelBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneBtnPressed:(id)sender {
    
    NSString *post = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\",\"email\":\"%@\"}", self.userNameTextField.text, self.pwTextField.text, self.emailTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://162.243.153.67:8080/myapp/accounts/"]]; // change URL here
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if( [response statusCode] >= 200 && [response statusCode] <=300) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"Connection could not be made");
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

@end