//
//  BHPhotoAlbumLayout.h
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/19/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHPhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@end