//
//  DetailViewController.m
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/20/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController()

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];

    self.imageView.image = self.image;
//    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height );

    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.Navi attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:64.0f]];
}


- (BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)CloseButtonPressed:(id)sender {

  [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}




@end
