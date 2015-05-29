//
//  DownloadViewController.m
//  PhotoHangout
//
//  Created by Won Jae Lee on 5/15/15.
//  Copyright (c) 2015 cs130. All rights reserved.
//


#import "DownloadViewController.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "DetailViewController.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface DownloadViewController ()

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, weak) IBOutlet BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end


@implementation DownloadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionview.backgroundColor = [UIColor blackColor];
    
    [self.collectionview registerClass:[BHAlbumPhotoCell class] forCellWithReuseIdentifier: PhotoCellIdentifier];
    
    self.albums = [NSMutableArray array];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *UserName= [ud objectForKey:@"UserName"];
    NSArray * allListArray = [[NSArray alloc] init];
    //NSDictionary *objectsDict;
    NSArray *store;
    

    NSURL *urlPhotoList = [NSURL URLWithString:[NSString stringWithFormat:@"http://jingyuliu.com:8080/myapp/photos/%@/all", UserName]];
    NSURL *urlPrefix =[NSURL URLWithString:[NSString stringWithFormat:@"http://jingyuliu.com:8080/myapp/photos/%@/", UserName]];
    //NSURL *urlPrefix = [NSURL URLWithString:@"http://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    
    NSData * allUsersJSON =[NSData dataWithContentsOfURL:urlPhotoList];
    
    if(allUsersJSON != nil) {
        NSError *error = nil;
        allListArray = [NSJSONSerialization JSONObjectWithData:allUsersJSON options:NSJSONReadingMutableContainers error:&error];

        //self.allLists = [NSMutableArray arrayWithArray:allListArray];
        NSInteger temp = allListArray.count;
        
        store = [allListArray valueForKeyPath:@"photoId"];

        
        
    }
    
    NSInteger photoIndex = 0;

    if(store.count ==0) {
        BHAlbum *album = [[BHAlbum alloc] init];
        NSURL *blankPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"https://d1luk0418egahw.cloudfront.net/static/images/guide/NoImage_592x444.jpg"]];
        BHPhoto *photo = [BHPhoto photoWithImageURL:blankPhoto];
        [album addPhoto:photo];
        [self.albums addObject:album];
    }
    else {
        for (NSInteger a = 0; a < store.count; a++) {
            BHAlbum *album = [[BHAlbum alloc] init];

                NSString *photoFilename = [NSString stringWithFormat:@"%@",store[photoIndex]];
                NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
                BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
                [album addPhoto:photo];
                photoIndex++;
            
        
            [self.albums addObject:album];
        
            self.thumbnailQueue = [[NSOperationQueue alloc] init];
            self.thumbnailQueue.maxConcurrentOperationCount = 3;
        }
    }
    /*
     
     for (NSInteger a = 0; a < 12; a++) {
     BHAlbum *album = [[BHAlbum alloc] init];
     //album.name = [NSString stringWithFormat:@"Photo Album %d", a+1];
     
     NSUInteger photoCount = arc4random()%4 +2;
     for (NSInteger p = 0; p < photoCount; p++) {
     // there are up to 25 photos available to load from the code repository
     NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
     NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
     BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
     [album addPhoto:photo];
     
     photoIndex++;
     }
     
     [self.albums addObject:album];
     
     self.thumbnailQueue = [[NSOperationQueue alloc] init];
     self.thumbnailQueue.maxConcurrentOperationCount = 3;
     }

     */


}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}


 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 [collectionView deselectItemAtIndexPath:indexPath animated:YES];

     BHAlbum *album = self.albums [indexPath.section];
     BHPhoto *photo = album.photos[indexPath.item];
     UIImage *image = [photo image];
   
     DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
     detailVC.image = image;
     detailVC.imageView.frame = CGRectMake(0, 0, detailVC.imageView.image.size.width, detailVC.imageView.image.size.height );


     [self presentViewController:detailVC animated:YES completion:nil];

 }


#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BHAlbum *album = self.albums[section];
    return album.photos.count; //collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BHAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                                                    forIndexPath:indexPath];
    
    BHAlbum *album = self.albums [indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    //load photo images in the background
    __weak DownloadViewController * weakSelf =self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionview.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell = (BHAlbumPhotoCell *) [weakSelf.collectionview cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
                            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ? NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    
    return photoCell;
   }




#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 1;
        
        // handle insets for iPhone 5 or 6
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        65.0f : 65.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoAlbumLayout.numberOfColumns = 1;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 22.0f, 22.0f);
    }
}

@end

