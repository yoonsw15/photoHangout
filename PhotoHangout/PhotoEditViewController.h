//
//  PhotoEditViewController.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"
#import "CLFilterTool.h"
#import "CLDrawTool.h"
#import "SRWebsocket.h"

@interface PhotoEditViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CLFilterTool *filterTool;
@property (strong, nonatomic) CLDrawTool *drawTool;
@property (nonatomic, strong) SRWebSocket *friendWebSocket;
@property (nonatomic, strong) NSURLRequest *friendURL;
@property (nonatomic, strong) CLImageEditor *editor;

@end
