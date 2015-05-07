//
//  CLEmoticonTool.h
//
//  Created by Mokhlas Hussein on 01/02/14.
//  Copyright (c) 2014 iMokhles. All rights reserved.
//  CLImageEditor Author sho yakushiji.
//

#import "CLImageToolBase.h"
#import "SRWebSocket.h"

@class _CLEmoticonView;

@interface CLEmoticonTool : CLImageToolBase

@property (nonatomic, strong) _CLEmoticonView* emoticonView;
- (void)externalAddEmoticon:(NSString *)imageName withEditor:(CLImageEditor *)editor;
- (void)updateEmoticonCenterTo:(CGPoint)center;
- (void)updateEmoticonScaleTo:(CGFloat)scale WithArg:(CGFloat)arg;
- (void)removeEmoticon;

@end


@interface _CLEmoticonView : UIView
+ (void)setActiveEmoticonView:(_CLEmoticonView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLEmoticonTool*)tool;
- (void)setScale:(CGFloat)scale;
- (void)setArg:(CGFloat)arg;
@end