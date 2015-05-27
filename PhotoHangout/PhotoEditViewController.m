//
//  PhotoEditViewController.m
//  PhotoHangout
//
//  Created by Seung Won Yoon on 2015. 4. 13..
//  Copyright (c) 2015년 cs130. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "CLImageEditor.h"

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
    else {
        UIImage *product = [self.filterTool filteredImage:self.editor.orig_imageViewWrapper.image withToolInfo:[self createFilterToolInfo:message]];
        self.editor.imageViewWrapper.image = product;
    }
    
}

- (void)imageEditorDidCancel:(CLImageEditor*)editor
{
    [self.editor dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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

