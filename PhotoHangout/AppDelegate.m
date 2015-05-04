//
//  AppDelegate.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /*
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480) //display height is 480 (3gs,4, 4s)
    {
        // UIStoryboard generation
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        // Get initial view controller from Generated UIStoryboard
        UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        // Generate window with adjusted size
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Set initial view controller of storyboard as rootViewController of window
        self.window.rootViewController = initialViewController;
        // see window
        [self.window makeKeyAndVisible];
    }
    else if (iOSDeviceScreenSize.height == 568) //display height is 568 (5/5s)
    {
            //Identical
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_4inch" bundle:nil];
            UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = initialViewController;
            [self.window makeKeyAndVisible];
    }
    else if (iOSDeviceScreenSize.height == 667) //display height is 667 (6)
    {
        //Identical
        UIStoryboard *iPhone47Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_4.7inch" bundle:nil];
        UIViewController *initialViewController = [iPhone47Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initialViewController;
        [self.window makeKeyAndVisible];
    }
    else if (iOSDeviceScreenSize.height == 736) //display height is 736 (6s)
    {
        //Identical
        UIStoryboard *iPhone55Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_5.5inch" bundle:nil];
        UIViewController *initialViewController = [iPhone55Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initialViewController;
        [self.window makeKeyAndVisible];
    }
    */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
