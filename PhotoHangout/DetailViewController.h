//
//  DetailViewController.h
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/20/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationBar *Navi;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@end