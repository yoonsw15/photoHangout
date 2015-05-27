//
//  AppDelegate.h
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SRWebSocketDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

