//
//  menuViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 5. 14..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface MenuViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImagePickerController *camera;
@property (nonatomic,strong) UIImagePickerController *album;
@property (nonatomic,strong) ALAssetsLibrary *library;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userID;

@property (strong, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (strong, nonatomic) IBOutlet UIButton *cameraRollBtn;
@property (strong, nonatomic) IBOutlet UIButton *joinBtn;
@property (strong, nonatomic) IBOutlet UIButton *albumBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *albumHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cameraRollHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *joinHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *takePhotoHeight;

@end
