//
//  DownloadViewController.h
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/15/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *collectionImages;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;



@end

/*
@interface DownloadCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
*/

