//
//  PhotoEditViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "CLImageEditor.h"
#import "MenuViewController.h"

@interface PhotoEditViewController ()<CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,SRWebSocketDelegate>

@end

@implementation PhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.friendURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: @"ws://162.243.153.67:8030/photohangout/websocket/ucla"]];
    
    //self.friendWebSocket = [[SRWebSocket alloc] initWithURLRequest:self.friendURL];
    //self.friendWebSocket.delegate = self;
    
    //NSLog(@"Server has now been connected!");
    //[self.friendWebSocket open];
    
    self.photoWebSocket = [SRWebSocket sharedInstance];
    self.photoWebSocket.delegate = self;
    
    self.filterTool = [[CLFilterTool alloc] init];
    self.drawTool = [[CLDrawTool alloc] init];
    self.stickerTool = [[CLStickerTool alloc] init];
    self.emoticonTool = [[CLEmoticonTool alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.editor == nil) {
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://162.243.153.67:8080/myapp/photos/gayweather/45"]]];
//        self.currentImage = image;
        self.editor = [[CLImageEditor alloc] initWithImage:self.currentImage delegate:self];
        [self presentViewController:self.editor animated:YES completion:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.parentViewController == nil) {
//        NSLog(@"PhotoEditViewController has now been closed!");
        //release stuff here
        //[self.friendWebSocket close];
    } else {
        NSLog(@"PhotoEditViewController now loaded!");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CLImageToolInfo *)createFilterToolInfo:(NSString *)filterName
{
    CLImageToolInfo *filterToolInfo = [CLImageToolInfo new];
    filterToolInfo.toolName  = filterName;
    filterToolInfo.title     = @"None";
    filterToolInfo.available = YES;
    filterToolInfo.dockedNumber = 0;
    
    return filterToolInfo;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    //Create ToolInfo and use filterTool to use call the method to get the result?
    
    //Create CLImageToolInfo with the message.
    //Use the proper tool to create the UIImage Product with the ToolInfo
    //Update the imageViewWrapper Image with the product.
    
    if ([message isEqual:@"SUCCESS"]) {
        
    }
    else if ([message isEqual:@"FAIL"]) {
        
    }
    else if([message isEqualToString:@"EmoticonRemoved"]) {
        [self.emoticonTool removeEmoticon];
    }
    else if([message hasPrefix:@"EmoticonScaledTo"]) {
        NSArray *emoticonData = [message componentsSeparatedByString: @"|#"];
        CGFloat newScale = [emoticonData[1] floatValue];
        CGFloat newArg = [emoticonData[2] floatValue];
        [self.emoticonTool updateEmoticonScaleTo:newScale WithArg:newArg];
    }
    else if([message hasPrefix:@"EmoticonPannedTo"]) {
        NSArray *emoticonData = [message componentsSeparatedByString: @"|#"];
        CGFloat newX = [emoticonData[1] floatValue];
        CGFloat newY = [emoticonData[2] floatValue];
        [self.emoticonTool updateEmoticonCenterTo:CGPointMake(newX, newY)];
    }
    else if([message hasPrefix:@"EmoticonCreateAt"]) {
        NSArray *emoticonData = [message componentsSeparatedByString: @"|#"];
        NSString *filePath = emoticonData[1];
        NSString *imageName = [filePath substringFromIndex:[filePath length]-7];
        [self.emoticonTool externalAddEmoticon:imageName withEditor:self.editor];
    }
    else if([message isEqualToString:@"StickerRemoved"]) {
        [self.stickerTool removeSticker];
    }
    else if([message hasPrefix:@"StickerScaledTo"]) {
        NSArray *stickerData = [message componentsSeparatedByString: @"|#"];
        CGFloat newScale = [stickerData[1] floatValue];
        CGFloat newArg = [stickerData[2] floatValue];
        [self.stickerTool updateStickerScaleTo:newScale WithArg:newArg];
    }
    else if([message hasPrefix:@"StickerPannedTo"]) {
        NSArray *stickerData = [message componentsSeparatedByString: @"|#"];
        CGFloat newX = [stickerData[1] floatValue];
        CGFloat newY = [stickerData[2] floatValue];
        [self.stickerTool updateStickerCenterTo:CGPointMake(newX, newY)];
    }
    else if([message hasPrefix:@"StickerCreateAt"]) {
        NSArray *stickerData = [message componentsSeparatedByString: @"|#"];
        NSString *filePath = stickerData[1];
        NSString *imageName = [filePath substringFromIndex:[filePath length]-7];
        [self.stickerTool externalAddSticker:imageName withEditor:self.editor];
    }
    else if ([message hasPrefix:@"DrawingFrom"]){
        NSArray *drawingData = [message componentsSeparatedByString: @"|#"];
        CGFloat fromX = [drawingData[1] floatValue];
        CGFloat fromY = [drawingData[2] floatValue];
        CGFloat toX = [drawingData[4] floatValue];
        CGFloat toY = [drawingData[5] floatValue];
        
        CGFloat width = [drawingData[7] floatValue];
        CGFloat red = [drawingData[9] floatValue];
        CGFloat green = [drawingData[10] floatValue];
        CGFloat blue = [drawingData[11] floatValue];
        CGFloat alpha = [drawingData[12] floatValue];
        [self.drawTool externalDrawLine:CGPointMake(fromX, fromY) to:CGPointMake(toX, toY) WithWidth:width withColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha] withEditor:self.editor];
    }
    else if ([message isEqual:@"Start"]){
        NSLog(@"What you expected is here. Uh Oh");
    }
    else if ([message isEqual:@"CloseSession"]) {
        [self.photoWebSocket close];
        [self.editor dismissViewControllerAnimated:YES completion:nil];
        
        MenuViewController *menuVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"menuVC"];
        [self presentViewController:menuVC animated:YES completion:nil];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIImage *product = [self.filterTool filteredImage:self.editor.orig_imageViewWrapper.image withToolInfo:[self createFilterToolInfo:message]];
        self.editor.imageViewWrapper.image = product;
    }
    
}

- (void)imageEditorDidCancel:(CLImageEditor*)editor
{
    [self.editor dismissViewControllerAnimated:YES completion:nil];
    
    MenuViewController *menuVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"menuVC"];
    [self presentViewController:menuVC animated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    if (self.isHost) {
        [self uploadImage:image];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sessionID = [ud objectForKey:@"SessionId"];
        [self endSessionWith: sessionID];
        
        [self.photoWebSocket send:@"CloseSession"];
    }
}

- (void)endSessionWith: (NSString *)sessionId
{
    //send the put method here.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://jingyuliu.com:8080/myapp/sessions/%@/complete", sessionId]]];
    [request setHTTPMethod:@"PUT"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *invitationData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if( [response statusCode] >= 200 && [response statusCode] <=300) {
        
    }
}

- (void)uploadImage:(UIImage *)image
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [ud objectForKey:@"UserName"];
    NSString *urlPathWithLogin = [NSString stringWithFormat:@"http://162.243.153.67:8080/myapp/photos/%@/upload", userName ];
    
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
            
        }
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

