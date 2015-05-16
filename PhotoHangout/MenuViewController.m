//
//  menuViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 5. 14..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "MenuViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AWSS3/AWSS3.h>
#import "Constants.h"

@interface MenuViewController () 

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)didTapOnCamera:(id)sender {
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.allowsEditing = NO;
    camera.delegate   = self;
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:camera animated:YES completion:nil];
}

- (IBAction)didTabOnAlbum:(id)sender {
    UIImagePickerController *album = [[UIImagePickerController alloc] init];
    album.allowsEditing = YES;
    album.delegate = self;
    album.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    [self presentViewController:album animated:YES completion:nil];
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
    NSData * imageData = UIImagePNGRepresentation(image);
    
    [imageData writeToFile:filePath atomically:YES];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = fileName;
    uploadRequest.bucket = S3BucketName;
    
    [self upload:uploadRequest];
    
//    PhotoEditViewController *photoVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"PhotoEdit"];
//    photoVC.currentImage = image;
//    
//    [self presentViewController:photoVC animated:YES completion:nil];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type]){
        if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            type = UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate   = self;
        picker.sourceType = type;
        
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
//    __weak UploadViewController *weakSelf = self;
    [[transferManager upload:uploadRequest] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            UploadViewController *strongSelf = weakSelf;
//                            NSUInteger index = [strongSelf.collection indexOfObject:uploadRequest];
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
//                                                                        inSection:0];
//                            [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                        });
                    }
                        break;
                        
                    default:
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UploadViewController *strongSelf = weakSelf;
//                NSUInteger index = [strongSelf.collection indexOfObject:uploadRequest];
//                [strongSelf.collection replaceObjectAtIndex:index withObject:uploadRequest.body];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
//                                                            inSection:0];
//                [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//            });
        }
        
        return nil;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
