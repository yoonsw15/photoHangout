//
//  CLDrawTool.h
//
//  Created by sho yakushiji on 2014/06/20.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "SRWebSocket.h"

@interface CLDrawTool : CLImageToolBase
- (UIImage *)externalDrawLine:(CGPoint)from to:(CGPoint)to WithWidth:(CGFloat)width withColor:(UIColor*)color onOriginal:(UIImageView *)imageView;

@end
