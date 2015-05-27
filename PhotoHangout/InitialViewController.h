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

- (IBAction)loginTapped:(id)sender;
- (IBAction)signUpTapped: (id)sender;

@end
