//
//  menuViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 5. 14..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "MenuViewController.h"
#import "InviteFriendsViewController.h"

@interface MenuViewController () 

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.userName = [ud objectForKey:@"UserName"];
    self.userID = [ud objectForKey:@"UserId"];
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
    
    [self uploadImage:image];
    
    InviteFriendsViewController *inviteFriendsVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"inviteFriendsVC"];
    inviteFriendsVC.sessionImage = image;
    
    [self presentViewController:inviteFriendsVC animated:YES completion:nil];
    
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

- (void)uploadImage:(UIImage *)image
{
    
    NSString *urlPathWithLogin = [NSString stringWithFormat:@"http://162.243.153.67:8080/myapp/photos/%@/upload", self.userName ];
    
    NSURL *url = [NSURL URLWithString:[urlPathWithLogin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"data"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            NSDictionary * photoIDDictionary = [[NSDictionary alloc] init];
            photoIDDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSNumber *photoID = (NSNumber *)[photoIDDictionary objectForKey:@"photoId"];
            NSLog(@"Photo ID is %tu", [photoID integerValue]);
            
            [self createSession:self.userID photoId:photoID];
        }
    }];
}

- (void)createSession:(NSString *)userID photoId:(NSNumber *)photoId
{
    NSString *post = [NSString stringWithFormat:@"{\"ownerId\":\"%@\",\"photoId\":\"%tu\"}",  userID, [photoId integerValue]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://162.243.153.67:8080/myapp/sessions"]]; // change URL here
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    
    NSHTTPURLResponse *response = nil;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if( [response statusCode] >= 200 && [response statusCode] <=300) {
        NSDictionary *sessionDict = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *sessionID = [sessionDict objectForKey:@"sessionId"];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject: sessionID forKey:@"SessionId"];
        [ud synchronize];
        
    } else {
        NSLog(@"Connection could not be made Creating Session Failed");
    }
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
