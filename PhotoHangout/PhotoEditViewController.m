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
    self.friendURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: @"ws://localhost:8025/photohangout/websocket"]];
    
    self.friendWebSocket = [[SRWebSocket alloc] initWithURLRequest:self.friendURL];
    self.friendWebSocket.delegate = self;
    
    //[self.imageView setImage:[UIImage imageNamed:@"Marine"]];
    
    
    
    self.filterTool = [[CLFilterTool alloc] init];
    
    self.editor = [[CLImageEditor alloc] initWithImage:product delegate:self];
    
    [self presentViewController:self.editor animated:YES completion:nil];
    
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//        
//    });
   
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
    
    UIImage *product = [self.filterTool filteredImage:[UIImage imageNamed:@"Marine"] withToolInfo:[self createFilterToolInfo:@"CLDefaultProcessFilter"]];
    self.editor.imageViewWrapper.image = product;
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
