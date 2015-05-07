//
//  CLStickerTool.h
//
//  Created by sho yakushiji on 2013/12/11.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "SRWebSocket.h"

@class _CLStickerView;

@interface CLStickerTool : CLImageToolBase
@property (nonatomic, strong) _CLStickerView* stickerView;
- (void)externalAddSticker:(NSString *)imageName withEditor:(CLImageEditor *)editor;
- (void)updateStickerCenterTo:(CGPoint)center;
- (void)updateStickerScaleTo:(CGFloat)scale WithArg:(CGFloat)arg;
- (void)removeSticker;
@end

@interface _CLStickerView : UIView
+ (void)setActiveStickerView:(_CLStickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool;
- (void)setScale:(CGFloat)scale;
- (void)setArg:(CGFloat)arg;
@end