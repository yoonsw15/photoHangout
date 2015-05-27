//
//  BHEmblemView.m
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/20/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import "BHEmblemView.h"

static NSString * const BHEmblemViewImageName = @"emblem";

@interface BHEmblemView ()

@end

@implementation BHEmblemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:BHEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        
        [self addSubview:imageView];
    }
    return self;
}

+ (CGSize)defaultSize
{
    return [UIImage imageNamed:BHEmblemViewImageName].size;
}

@end