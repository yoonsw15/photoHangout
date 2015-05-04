//
//  SignupViewController.m
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/3/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

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
- (IBAction)doneBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end