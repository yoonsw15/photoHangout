//
//  CLImageToolInfo.h
//
//  Created by sho yakushiji on 2013/11/26.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLImageToolInfo : NSObject


@property (nonatomic, strong)   NSString *title;
@property (nonatomic, assign)   BOOL      available;
@property (nonatomic, assign)   CGFloat   dockedNumber;
@property (nonatomic, strong)   NSString *iconImagePath;
@property (nonatomic, readonly) UIImage  *iconImage;
@property (nonatomic, strong) NSMutableDictionary *optionalInfo;
@property (nonatomic, strong) NSString *toolName;
@property (nonatomic, strong) NSArray *subtools;


- (NSString*)toolTreeDescription;
- (NSArray*)sortedSubtools;

- (CLImageToolInfo*)subToolInfoWithToolName:(NSString*)toolName recursive:(BOOL)recursive;

@end
