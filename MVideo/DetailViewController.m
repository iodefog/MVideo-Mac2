//
//  DetailViewController.m
//  MVideo
//
//  Created by LHL on 2017/4/24.
//  Copyright © 2017年 lihongli. All rights reserved.
//

#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface DetailViewController (){
    AVPlayerView *playerView;
}

@property (strong) IBOutlet NSView *customView;

@end

@implementation DetailViewController

- (void)viewDidDisappear{
    [super viewDidDisappear];
    [self back:nil];
}

- (void)viewDidLoad {
 
    self.title = @"Hello";
    [super viewDidLoad];
    
    __weak typeof(self) mySelf = self;

    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(mySelf.view);
    }];
    
    playerView = [[AVPlayerView alloc] init];
    playerView.controlsStyle = AVCaptureViewControlsStyleInlineDeviceSelection;
    [self.customView  addSubview:playerView];

    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(mySelf.customView);
    }];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.model.url]];
    AVPlayer  *player = [AVPlayer playerWithPlayerItem:playerItem];
    playerView.player = player;
    [player play];
    
//   NSImage *backImage = [NSImage imageNamed:@"All-Btn-BackOfLight-Highlighted"];
//    NSButton *backButton = [NSButton buttonWithImage:backImage target:self action:@selector(back:)];
//    backButton.tag = 1001;
//    backButton.frame = CGRectMake(0, 600-30, 50, 30);
   
//    [playerView addSubview:backButton];
}
- (void)back:(id)sender {
    [self dismissViewController:self];
    [playerView.player pause];
    [playerView removeFromSuperview];
}

- (void)dismissViewController:(NSViewController *)viewController NS_AVAILABLE_MAC(10_10){

}

- (IBAction)dismissController:(nullable id)sender NS_AVAILABLE_MAC(10_10){

}


- (void)viewDidLayout{
    [super viewDidLayout];
    NSButton *backButton = [self.view viewWithTag:1001];
    backButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-30, 50, 30);
}

@end
