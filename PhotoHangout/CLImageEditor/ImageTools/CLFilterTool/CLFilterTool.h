//
//  CLFilterTool.h
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "SRWebSocket.h"

@interface CLFilterTool : CLImageToolBase
- (UIImage*)filteredImage:(UIImage*)image withToolInfo:(CLImageToolInfo*)info;
@end
