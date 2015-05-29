//
//  InitialViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface InitialViewController : UIViewController <UITextFieldDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *pwName;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (strong, nonatomic) IBOutlet UILabel *logo;

- (IBAction)loginTapped:(id)sender;
- (IBAction)signUpTapped: (id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userNameWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pwWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoVSpacing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textVSpacing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textVSpacing2;

@end
