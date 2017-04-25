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

- (void)viewDidLoad {
 
    self.title = @"Hello";
    [super viewDidLoad];
    
    playerView = [[AVPlayerView alloc] init];
    playerView.controlsStyle = AVCaptureViewControlsStyleInlineDeviceSelection;
    [self.customView  addSubview:playerView];
    playerView.frame = self.customView.bounds;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.model.url]];
    AVPlayer  *player = [AVPlayer playerWithPlayerItem:playerItem];
    playerView.player = player;
    [player play];
    
   NSImage *backImage = [NSImage imageNamed:@"All-Btn-BackOfLight-Highlighted"];
    NSButton *backButton = [NSButton buttonWithImage:backImage target:self action:@selector(back:)];
    backButton.frame = CGRectMake(0, 600-30, 50, 30);
    [playerView addSubview:backButton];
    
}
- (void)back:(id)sender {
    [self dismissViewController:self];
    [playerView.player pause];
    [playerView removeFromSuperview];
}


@end
