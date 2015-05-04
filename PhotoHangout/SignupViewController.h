//
//  SignupViewController.h
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/3/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebsocket.h"

@interface SignupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwTextField;


@end