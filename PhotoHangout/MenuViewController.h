//
//  menuViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 5. 14..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEditViewController.h"

@interface MenuViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImagePickerController *camera;

@end
